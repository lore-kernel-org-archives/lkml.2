Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab0LUHcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 02:32:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49517 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0LUHcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 02:32:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eP/fIt39D4sZTnFTdQhhEv2Tob66B2uEzOnh8vtirVyzvlgahw7xoNltk2jmPmUkKH
         OjKrn//Ah4DpoPgwZcXtyJjaoyXeMZZrBAojdvwRBi8doY5gr5+E9AKBfA7SneiL1Kiw
         6d4r98PkkL8PiArPfffKyd2o8hTe7BXMdk8oI=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1012202048220.15447@tigran.mtv.corp.google.com>
References: <cover.1292604745.git.minchan.kim@gmail.com>
	<20101220103307.GA22986@infradead.org>
	<AANLkTikss0RW_xRrD_vVvfqy1rH+NC=WPUB2qKBaw5qo@mail.gmail.com>
	<alpine.LSU.2.00.1012202048220.15447@tigran.mtv.corp.google.com>
Date: Tue, 21 Dec 2010 16:32:41 +0900
Message-ID: <AANLkTimMKjLRiV5dpZL0wJ0FWLJyqQ8oNJbCQt9ZdrHP@mail.gmail.com>
Subject: Re: [RFC 0/5] Change page reference hanlding semantic of page cache
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 2:07 PM, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 21 Dec 2010, Minchan Kim wrote:
>> On Mon, Dec 20, 2010 at 7:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> > You'll need to merge all patches into one, otherwise you create really
>> > nasty memory leaks when bisecting between them.
>> >
>>
>> Okay. I will resend.
>>
>> Thanks for the notice, Christoph.
>
> Good point from hch, but I feel even more strongly: if you're going to
> do this now, please rename remove_from_page_cache (delete_from_page_cache
> was what I chose back when I misdid it) - you're changing an EXPORTed
> function in a subtle (well, subtlish) confusing way, which could easily
> waste people's time down the line, whether in not-yet-in-tree filesystems
> or backports of fixes.  I'd much rather you break someone's build,
> forcing them to look at what changed, than crash or leak at runtime.
>
> If you do rename, you can keep your patch structure, introducing the
> new function as a wrapper to the old at the beginning, then removing
> the old function at the end.

It is very good idea!!
Thanks for good suggestion, Hugh.

>
> (As you know, I do agree that it's right to decrement the reference
> count at the point of removing from page cache.)
>
> Hugh
>



-- 
Kind regards,
Minchan Kim
