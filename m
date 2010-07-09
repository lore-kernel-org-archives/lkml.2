Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0GII0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:26:06 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45213 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0GII0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:26:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=un16B8f952gfeZN6us8dXF7YotOzJ+4rzqJPxKiCY2weTMWNerxVK5o6OX2PQPLPHK
         HJ22n2w5ExFm3kwKAtP3vEkRbzD1artKmnATHWljmskqnevcDNn4YvXcFvvlbVojTQXV
         pwarWrq0weH7HbXtAp5DHOPCnFB8qqot3MtL4=
MIME-Version: 1.0
In-Reply-To: <20100709155108.3D2A.A69D9226@jp.fujitsu.com>
References: <20100709155108.3D2A.A69D9226@jp.fujitsu.com>
Date: Fri, 9 Jul 2010 17:26:00 +0900
Message-ID: <AANLkTinhGeX1_YazJn8PHOFsPboTRmry17qHAENfZVbK@mail.gmail.com>
Subject: Re: [PATCH] vmscan: protect to read reclaim_stat by lru_lock
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 3:52 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Rik van Riel pointed out reading reclaim_stat should be protected
> lru_lock, otherwise vmscan might sweep 2x much pages.
>
> This fault was introduced by followint commit.
>
>  commit 4f98a2fee8acdb4ac84545df98cccecfd130f8db
>  Author: Rik van Riel <riel@redhat.com>
>  Date:   Sat Oct 18 20:26:32 2008 -0700
>
>    vmscan: split LRU lists into anon & file sets
>
>    Split the LRU lists in two, one set for pages that are backed by real file
>    systems ("file") and one for pages that are backed by memory and swap
>    ("anon").  The latter includes tmpfs.
>
>    The advantage of doing this is that the VM will not have to scan over lots
>    of anonymous pages (which we generally do not want to swap out), just to
>    find the page cache pages that it should evict.
>
>    This patch has the infrastructure and a basic policy to balance how much
>    we scan the anon lists and how much we scan the file lists.  The big
>    policy changes are in separate patches.
>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks, Kosaki. I have forgotten this issue.

-- 
Kind regards,
Minchan Kim
