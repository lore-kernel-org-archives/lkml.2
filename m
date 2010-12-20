Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab0LTC1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 21:27:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42515 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0LTC1t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 21:27:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F/wscQrjO3R55u6QS3gmJqnuKHdKoChGXpRzE7E9VqaZCU/wh0tE9Oi62/TAyWvDt4
         lkklFIeW+/XqeTB2YOz+vp7ty70BgODkGCJMfa9h0YApdrvmBLQLzShqERQdcwSJDcDz
         Hgwj0DL84uAtEPhzn68ChlVKLvpdC9p0tpdsQ=
MIME-Version: 1.0
In-Reply-To: <20101220112227.E566.A69D9226@jp.fujitsu.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<02ab98b3a1450f7a1c31edc48ccc57e887cee900.1292604746.git.minchan.kim@gmail.com>
	<20101220112227.E566.A69D9226@jp.fujitsu.com>
Date: Mon, 20 Dec 2010 11:27:48 +0900
Message-ID: <AANLkTimaW7X6w2e=4SvynHQHO-Kv3wXGv4_NCKDsuYRR@mail.gmail.com>
Subject: Re: [RFC 5/5] truncate: Remove unnecessary page release
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 11:21 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> This patch series changes remove_from_page_cache's page ref counting
>> rule. page cache ref count is decreased in remove_from_page_cache.
>> So we don't need call again in caller context.
>>
>> Cc: Nick Piggin <npiggin@suse.de>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
>> ---
>>  mm/truncate.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index 9ee5673..8decb93 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -114,7 +114,6 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
>>        * calls cleancache_put_page (and note page->mapping is now NULL)
>>        */
>>       cleancache_flush_page(mapping, page);
>> -     page_cache_release(page);       /* pagecache ref */
>>       return 0;
>
> Do we _always_ have stable page reference here? IOW, I can assume

I think so.
Because the page is locked so caller have to hold a ref to unlock it.

> cleancache_flush_page() doesn't cause NULL deref?
>
>
>
>



-- 
Kind regards,
Minchan Kim
