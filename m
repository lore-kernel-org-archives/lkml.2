Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1AEExH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 23:53:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61419 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1AEExF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 23:53:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WRD+kDJ/kWS6s7LB4mRhPwMdQLfqBckeLbwVxgbwdKcAN2TS7utP7TMK+KkbKxPskV
         e8hytDeHQLdmn5cghV4NNj3JRgwsOaWbWKjMsbcjOoUdKWEQVs2AIWeCWXnkhNz8P80M
         ceJvAN3xK5NdXplSuFBuPLaDtANq/Zv9G3/B8=
MIME-Version: 1.0
In-Reply-To: <20110104161805.GE3120@balbir.in.ibm.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
	<20110104161805.GE3120@balbir.in.ibm.com>
Date: Wed, 5 Jan 2011 13:53:04 +0900
Message-ID: <AANLkTinSuEF-+CCiCyoQbMfMMUJyQAw5JQB8iNrkHgmX@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] Change page reference handling semantic of page cache
From: Minchan Kim <minchan.kim@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

On Wed, Jan 5, 2011 at 1:18 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * MinChan Kim <minchan.kim@gmail.com> [2011-01-03 00:44:29]:
>
>> Now we increases page reference on add_to_page_cache but doesn't decrease it
>> in remove_from_page_cache. Such asymmetric makes confusing about
>> page reference so that caller should notice it and comment why they
>> release page reference. It's not good API.
>>
>> Long time ago, Hugh tried it[1] but gave up of reason which
>> reiser4's drop_page had to unlock the page between removing it from
>> page cache and doing the page_cache_release. But now the situation is
>> changed. I think at least things in current mainline doesn't have any
>> obstacles. The problem is fs or somethings out of mainline.
>> If it has done such thing like reiser4, this patch could be a problem but
>> they found it when compile time since we remove remove_from_page_cache.
>>
>> [1] http://lkml.org/lkml/2004/10/24/140
>>
>> The series configuration is following as.
>>
>> [1/7] : This patch introduces new API delete_from_page_cache.
>> [2,3,4,5/7] : Change remove_from_page_cache with delete_from_page_cache.
>> Intentionally I divide patch per file since someone might have a concern
>> about releasing page reference of delete_from_page_cache in
>> somecase (ex, truncate.c)
>> [6/7] : Remove old API so out of fs can meet compile error when build time
>> and can notice it.
>> [7/7] : Change __remove_from_page_cache with __delete_from_page_cache, too.
>> In this time, I made all-in-one patch because it doesn't change old behavior
>> so it has no concern. Just clean up patch.
>>
>
> Could you please describe any testing done, was it mostly functional?

I didn't test it since I think it's okay as a code review.
Do you find any faults or guess it?
Anyway, I should have tested it before sending patches.

we are now -rc8 and Andrew doesn't held a patch.
So I will test it until he grab a patch.

Thanks,

>
> --
>        Three Cheers,
>        Balbir
>



-- 
Kind regards,
Minchan Kim
