Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab1AWRvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 12:51:44 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45251 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab1AWRvn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 12:51:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BY4/ZArpyNOvaD/Sqh/6FKumDz8gd24boqffI12uf7R4ioLY9v44erWepIGgILE3uU
         OqVwIP9Zw2aRsXEQnDaRFE2MNPn+qmWPbDZhOLgJcSNh6ENGlBTieEzhoVNLX0P5b/Vj
         PrwQBKBSSNzpsP+gRkGb9aW5zJybJKBTcG56Q=
MIME-Version: 1.0
In-Reply-To: <20110122183800.GU9506@random.random>
References: <AANLkTikdwZp1r_MD4TH7bsLjzPAtHzq7XWoLZmFwdK=S@mail.gmail.com>
	<20110122183800.GU9506@random.random>
Date: Sun, 23 Jan 2011 18:51:42 +0100
Message-ID: <AANLkTik6QKuoGmYBsP8goZSCWDoWxd0hwnMvSAEeNa_k@mail.gmail.com>
Subject: Re: [PATCH] compaction: don't depend on HUGETLB_PAGE
From: Luca Tettamanti <kronos.it@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 7:38 PM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> Hello,
>
> On Sat, Jan 22, 2011 at 03:48:03PM +0100, Luca Tettamanti wrote:
>> Hello Andrea,
>> this commit:
>>
>> commit 5d6892407cab23d4bf2f6de065ca351a53849323
>> Author: Andrea Arcangeli <aarcange@redhat.com>
>> Date:   Thu Jan 13 15:47:07 2011 -0800
>>
>>     thp: select CONFIG_COMPACTION if TRANSPARENT_HUGEPAGE enabled
>>
>> causes this warning during the configuration process:
>>
>> warning: (TRANSPARENT_HUGEPAGE) selects COMPACTION which has unmet
>> direct dependencies (EXPERIMENTAL && HUGETLB_PAGE && MMU)
>>
>> This happens because 'select' does not enable the dependencies of its
>> target, so when I selected THP it also enabled COMPATION but I don't
>> have HUGETLBFS (=HUGETLB_PAGE) enabled.
>> Making THP select HUGETLB_PAGE fixes the warning but I'm not 100% sure
>> that's correct (does it work without HUGETLBFS?).
>
> Mel, what's your take about this issue?
>
> Luca does the below fix all your .config problems?

Yes, no more warnings; I haven't tested the kernel though.

Luca

> diff --git a/mm/Kconfig b/mm/Kconfig
> index 3ad483b..e9c0c61 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -179,7 +179,7 @@ config SPLIT_PTLOCK_CPUS
>  config COMPACTION
>        bool "Allow for memory compaction"
>        select MIGRATION
> -       depends on EXPERIMENTAL && HUGETLB_PAGE && MMU
> +       depends on MMU
>        help
>          Allows the compaction of memory for the allocation of huge pages.
