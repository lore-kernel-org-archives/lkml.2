Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1CYWu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:50:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44753 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1CYWu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:50:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=eKWUPi3RvJAx5tut+wJs7WqGGWKb19xy/8w9PF93SZKwIvcJq3WXT0j+uZMEutHdMt
         tispuIDb3BW2kgllloprQq7qi6qYwrDttRNLghz4LBq720mpOtR8jAAMTuNUPSMceT/c
         UDp9xqRW8onvyMCt89Lono+B2GLOqab7ZOcz0=
MIME-Version: 1.0
In-Reply-To: <20110325224726.GU3130@pulham.picochip.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
 <1301073283-30821-2-git-send-email-jamie@jamieiles.com> <AANLkTinLBbKaw=DwVFgORtQ=uA+zkF8QUUKj6uiqLaMw@mail.gmail.com>
 <20110325224726.GU3130@pulham.picochip.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 25 Mar 2011 18:50:36 -0400
X-Google-Sender-Auth: UPEQTNikjZdEn3N22D0J-EDYiPI
Message-ID: <AANLkTi=XGNdLq4=cp3iv++rg=yXUVsp4mjcW7CVuQZUV@mail.gmail.com>
Subject: Re: [RFC PATCHv3 1/4] drivers/otp: add initial support for OTP memory
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 18:47, Jamie Iles wrote:
> On Fri, Mar 25, 2011 at 05:58:05PM -0400, Mike Frysinger wrote:
>> On Fri, Mar 25, 2011 at 13:14, Jamie Iles wrote:
>> > +/* We'll allow OTP devices to be named otpa-otpz. */
>> > +#define MAX_OTP_DEVICES                26
>>
>> mmm is that still true ?
>
> I think so - the actual devices should be otpa-otpz, but when you
> register regions they could be otpa1, otpa2, otpb1, otpb2 etc.
>
>>
>> > +static unsigned long registered_otp_map[BITS_TO_LONGS(MAX_OTP_DEVICES)];
>> > +static DEFINE_MUTEX(otp_register_mutex);
>>
>> do we really need this ?  if we let the minor number dictate
>> availability, then we can increment until that errors/wraps, and we
>> dont need to do any tracking ...
>
> OK, so it would be nice to get rid of this but afaict we still need to
> do some accounting of available minor numbers in the range that we've
> allocated.  We could do a simple increment % 255 for the minor number
> but if OTP devices are removed at runtime then that may get fragmented
> and we would need to do retries of device_register() which feels a bit
> too easy to mess up.
>
> Certainly allocating one major number for OTP devices then allocating
> the minors one by one would be much better than what I have now.
>
> We probably also want it so that if you remove the OTP device that has
> had regions called otpaN then reinsert it they doesn't suddenly become
> otpbN.

yeah that's true.  guess i'll leave it be then ;).

whatever naming is picked in /dev/ should match the stuff in /sys/ btw ...
-mike
