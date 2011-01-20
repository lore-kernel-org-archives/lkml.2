Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1ATTh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:37:27 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52437 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1ATThV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=K41E9xLdaJ1UXaBNeCc+gJ88vtd1z77pw1Kxc1NfyNl347Xp9PTZuUdsZT5/mftoCO
         stlF93Ea0ODXmjUwnKkexhSPxs/jX+K4RQHMzjc0+3qRgdF0PTFaBQUkci+hQ3U4Ut59
         XqKCF6aVRWixU7RGB4QrFDZEufLj3IgNJQSWY=
MIME-Version: 1.0
In-Reply-To: <20110120173029.GA26121@infradead.org>
References: <1295543648-13788-1-git-send-email-torbenh@gmx.de>
	<20110120173029.GA26121@infradead.org>
Date: Thu, 20 Jan 2011 11:37:19 -0800
X-Google-Sender-Auth: 6gE-seQlImQUwPQRL6cJoZoHFcQ
Message-ID: <AANLkTikS0WAUngUXVx3uCynXt07-1L+=aR5A09XOMtK9@mail.gmail.com>
Subject: Re: [PATCH] RFC: abstract access to xtime_lock into a set of inline functions
From: john stultz <johnstul@us.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@tglx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 9:30 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Jan 20, 2011 at 06:14:08PM +0100, Torben Hohn wrote:
>> the -rt patches change the xtime_lock to a raw_seqlock_t
>> so a pretty huge portion of the patch deals with changing
>> the locking functions.
>>
>> this commit uses inline functions, to hide the type
>> of the lock.
>
> That's not how kernel code usually works.

Yea, I'm not a fan of this patch either.


>> -     write_seqlock(&xtime_lock);
>> +     xtime_write_seqlock();
>>       do_timer(1);
>> -     write_sequnlock(&xtime_lock);
>> +     xtime_write_sequnlock();
>
> However there's a pretty clear pattern of taking xtime_lock, calling
> do_timer and then releasing.  A useful thing you could do is to rename
> do_timer to do_timer_locked and make do_timer take and release
> xtime_lock in one place.

Seems like a reasonable suggestion.  I suspect there's still quite a
bit of stuff done under the same lock right around do_timer on a
number of arches, but  having a locked call would cut down on how
widely xtime is used.

thanks
-john
