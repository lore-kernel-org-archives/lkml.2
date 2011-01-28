Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1A1SKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 13:10:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54186 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1A1SKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 13:10:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=i2SyvJiPMb8m4dA5I2mwdYx/OXHa2pFAAmyFb9PYlg6MaUug0clK4T2KHmy6FaoklR
         dAdddt2NbXY5AWUoUYX6BEGdac0exwT26nX9v8zbcEzBUCfaMjHfjpIAtd41akCNqRtp
         3xxSs9Y+Wj8hkcxbysLX0jWaMAarmGCipoaL0=
MIME-Version: 1.0
In-Reply-To: <20110128173355.GD2586@polaris.bitmath.org>
References: <1296124547-3323-1-git-send-email-benjamin.tissoires@enac.fr>
	<1296124547-3323-2-git-send-email-benjamin.tissoires@enac.fr>
	<20110127120603.GB15626@polaris.bitmath.org>
	<AANLkTim7DbxhEO7vHPFcC1PFf=d2mSEyL+wurzUQa0pg@mail.gmail.com>
	<20110128173355.GD2586@polaris.bitmath.org>
Date: Fri, 28 Jan 2011 19:10:34 +0100
X-Google-Sender-Auth: AhtknGbdxNJs-6i3C9PZmAu59Pg
Message-ID: <AANLkTikM-DguswOb6Hv5jgkrirfFf+MHTJgK_Xk45gz5@mail.gmail.com>
Subject: Re: [RFC 1/2] input: mt: Add method to extract the MT slot state
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ping Cheng <pingc@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>, Chris Bagwell <chris@cnpbagwell.com>,
        Rafi Rubin <rafi@seas.upenn.edu>, Stephane Chatty <chatty@lii-enac.fr>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 18:33, Henrik Rydberg <rydberg@euromail.se> wrote:
> On Thu, Jan 27, 2011 at 01:49:18PM +0100, Benjamin Tissoires wrote:
>> Hi Henrik,
>>
>> On Thu, Jan 27, 2011 at 13:06, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > Hi Benjamin,
>> >
>> > On Thu, Jan 27, 2011 at 11:35:46AM +0100, Benjamin Tissoires wrote:
>> >> This patch adds the function input_mt_get_abs_value(), which may be
>> >
>> > Ehm, input_mt_get_absinfo?
>>
>> In fact, the idea was to put this on the table again ;). I have no
>> idea of what is the right think to do in such case.
>> So I'll take all comments.
>>
>> >
>> >> used to extract the current state of the MT slots.
>> >>
>> >> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
>> >
>> > I had rather re-add this myself, thanks.
>>
>> That was my question. Plus I had a subliminal message in which I
>> intend you to take the drive on this work. ;)
>
> Thanks for the patches, Benjamin, perhaps they do need a bit of
> rewrite or a new ioctl. We will see what happens.
>

Today  I found a bug in these 2 patches: they send garbage with
devices that use protocol A.
This is definitely a bad idea to send the input_absinfo.

In addition to that, using the original behavior (which seems better)
does not seems to add sth in regard to input_mt_get_value.
It would just add some guards that can be resumed in just a test:
(code >= ABS_MT_FIRST && code <= ABS_MT_LAST && dev->mt &&
	slot >= 0 && slot < dev->mtsize)

Henrik, if you want to introduce the new IOCTL, feel free, I don't
need it right now.

Cheers,
Benjamin
