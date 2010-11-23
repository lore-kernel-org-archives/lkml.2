Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab0KWFXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 00:23:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38337 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099Ab0KWFXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 00:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FbmnQw5cBXATw6A49+rf65ykJrDXsSGWui4w26jC6Z4G5x03BNOYP0ny5dEgwxWJXK
         f0sDeiQx19/o4AYjvZp6piTNEGc9KdPZ1TgEXAwrjTNMq4zZqVavC6ErxgmA0IzhRtKI
         FVFLxkcbVAccHl+JCIML55nljiG9OtD6Tg7c4=
MIME-Version: 1.0
In-Reply-To: <20101122210132.be9962c7.akpm@linux-foundation.org>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<20101122141449.9de58a2c.akpm@linux-foundation.org>
	<AANLkTimk4JL7hDvLWuHjiXGNYxz8GJ_TypWFC=74Xt1Q@mail.gmail.com>
	<20101122210132.be9962c7.akpm@linux-foundation.org>
Date: Tue, 23 Nov 2010 14:23:33 +0900
Message-ID: <AANLkTin62R1=2P+Sh0YKJ3=KAa6RfLQLKJcn2VEtoZfG@mail.gmail.com>
Subject: Re: [RFC 1/2] deactive invalidated pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 2:01 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 23 Nov 2010 13:52:05 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> >> +/*
>> >> + * Function used to forecefully demote a page to the head of the inactive
>> >> + * list.
>> >> + */
>> >
>> > This comment is wrong? __The page gets moved to the _tail_ of the
>> > inactive list?
>>
>> No. I add it in _head_ of the inactive list intentionally.
>> Why I don't add it to _tail_ is that I don't want to be aggressive.
>> The page might be real working set. So I want to give a chance to
>> activate it again.
>
> Well..  why?  The user just tried to toss the page away altogether.  If
> the kernel wasn't able to do that immediately, the best it can do is to
> toss the page away asap?
>
>> If it's not working set, it can be reclaimed easily and it can prevent
>> active page demotion since inactive list size would be big enough for
>> not calling shrink_active_list.
>
> What is "working set"?  Mapped and unmapped pagecache, or are you
> referring solely to mapped pagecache?

I mean it's mapped by other processes.

>
> If it's mapped pagecache then the user was being a bit silly (or didn't
> know that some other process had mapped the file).  In which case we
> need to decide what to do - leave the page alone, deactivate it, or
> half-deactivate it as this patch does.


What I want is the half-deactivate.

Okay. We will use the result of invalidate_inode_page.
If fail happens by page_mapped, we can do half-deactivate.
But if fail happens by dirty(ex, writeback), we can add it to tail.
Does it make sense?



-- 
Kind regards,
Minchan Kim
