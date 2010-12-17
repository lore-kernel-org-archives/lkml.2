Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab0LQBky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 20:40:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40576 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0LQBkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 20:40:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GPNxvsHndO7QqvCWXSe7U2rGVtfCGaJ3Eu5E+81N8VqmanyxGlC4S9ZhXv7/hqQ3Ze
         ZJ4E4sg4yBrl2o6dOOfqXO80a5Av18UZSPHd7/2tDD7WsP0yVVzxJi19MvT939Si0WQS
         KWyFHFSW9xLbRls0emHPZ6u5WvYS/vWt4TBVw=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1012161708260.3351@tigran.mtv.corp.google.com>
References: <E1PStc6-0006Cd-0Z@pomaz-ex.szeredi.hu>
	<AANLkTikXQmsgZ8Ea-GoQ4k2St6yCJj8Z3XthuBQ9u+EV@mail.gmail.com>
	<E1PTCV4-0007sR-SO@pomaz-ex.szeredi.hu>
	<20101216220457.GA3450@barrios-desktop>
	<alpine.LSU.2.00.1012161708260.3351@tigran.mtv.corp.google.com>
Date: Fri, 17 Dec 2010 10:40:51 +0900
Message-ID: <AANLkTinhkZKWkthN1R39+6nDbN0xZq-g7jP5-LVLxZ3E@mail.gmail.com>
Subject: Re: [PATCH] mm: add replace_page_cache_page() function
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

On Fri, Dec 17, 2010 at 10:21 AM, Hugh Dickins <hughd@google.com> wrote:
> On Fri, 17 Dec 2010, Minchan Kim wrote:
>> On Thu, Dec 16, 2010 at 12:59:58PM +0100, Miklos Szeredi wrote:
>> > On Thu, 16 Dec 2010, Minchan Kim wrote:
>> > >
>> > > Why do you release reference of old?
>> >
>> > That's the page cache reference we release.  Just like we acquire the
>> > page cache reference for "new" above.
>>
>> I mean current page cache handling semantic and page reference counting semantic
>> is separeated. For example, remove_from_page_cache doesn't drop the reference of page.
>> That's because we need more works after drop the page from page cache.
>> Look at shmem_writepage, truncate_complete_page.
>
> I disagree with you there: I like the way Miklos made it symmetric,
> I like the way delete_from_swap_cache drops the swap cache reference,
> I dislike the way remove_from_page_cache does not - I did once try to
> change that, but did a bad job, messed up reiserfs or reiser4 I forget
> which, retreated in shame.

I agree symmetric is good. I just said current fact which is that
remove_from_page_cache doesn't release ref.
So I thought we have to match current semantic to protect confusing.
Okay. I will not oppose current semantics.
Instead of it, please add it (ex, caller should hold the page
reference) in function description.

I am happy to hear that you tried it.
Although it is hard, I think it's very valuable thing.
Could you give me hint to googling your effort and why it is failed?

>
> In both the examples you give, shmem_writepage and truncate_complete_page,
> the caller has to be holding their own reference, in part because they
> locked the page, and will need to unlock it before releasing their ref.
> I think that would be true of any replace_page_cache_page caller.

Agree.

>
>>
>> You makes the general API and caller might need works before the old page
>> is free. So how about this?
>>
>> err = replace_page_cache_page(oldpage, newpage, GFP_KERNEL);
>> if (err) {
>>         ...
>> }
>>
>> page_cache_release(oldpage); /* drop ref of page cache */
>>
>>
>> >
>> > I suspect it's historic that page_cache_release() doesn't drop the
>> > page cache ref.
>>
>> Sorry I can't understand your words.
>
> Me neither: I believe Miklos meant __remove_from_page_cache() rather
> than page_cache_release() in that instance.

Maybe. :)

Thanks for the comment, Hugh.
>
> Hugh
>



-- 
Kind regards,
Minchan Kim
