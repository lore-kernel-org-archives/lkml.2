Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0CWJhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 05:37:04 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:60943 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab0CWJhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 05:37:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BzcT4YHeLB9ImkV3EPz2uyabKLDC56HmkS0XE9iy1he16O4C4nk/8IBJTofCFh+rFr
         JdDxwGm/09YqoL+aCsNuKRVxfzvVnZ9qhzlj5+yC3xMC/6dWg7p/JUS6V+dUu+7YvsE2
         UUjzY0N9hKW1iUpRdtX6dz6XoaGFJWy8PPe20=
MIME-Version: 1.0
In-Reply-To: <201003231027.34095.linux@rainbow-software.org>
References: <201003221601.36559.linux@rainbow-software.org>
	 <201003221630.47510.linux@rainbow-software.org>
	 <a32f33a41003220840p7e3c3ba5j70d85950e4646b3c@mail.gmail.com>
	 <201003231027.34095.linux@rainbow-software.org>
Date: Tue, 23 Mar 2010 10:36:58 +0100
Message-ID: <a32f33a41003230236q348c8aeata724042a9c3d9537@mail.gmail.com>
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken HW 
	encryption by default
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:27 AM, Ondrej Zary
<linux@rainbow-software.org> wrote:
> On Monday 22 March 2010, Ivo Van Doorn wrote:
>> >> But I though it was mentioned that disabling HW crypto didn't solve
>> >> the issue due to a second bug in a later kernel?
>> >
>> > That was a false positive. Probably because the device was not unplugged
>> > between the tests (and looks like the driver does not initialize the chip
>> > completely). It's not reliable, it sometimes stops working after reboot.
>>
>> Ah well that at least simplifies the problem. I'll have to retest rt2500usb
>> soon to see why the HW crypto failed. I am sure I had it working for WEP,
>> WPA and WPA2
>> before I submitted the patch.
>
> So let's try to fix it instead of disabling.
>
> First, the unrealiability (keeping HW encryption disabled). With the driver
> loaded but not doing anything more, the register dumps are same for both
> working and non-working case (dump-init.txt).
>
> dump-good-connected.txt is a dump after successful association and DHCP
> dump-bad-attempt.txt is a dump after successful association during non-working
> DHCP attempt
> dump-bad-after.txt is a dump after DHCP timed out

With association working, but DHCP failing it most likely means that
somehow the frame was malformatted.
The code for HW crypto alters the frame (alters IV/EIV/ICV data etc).
And that is commonly the source of
problems, because what has to be done depends heavily on the encryption type.

So could you verify which of the encryption types (WEP,WPA,WPA2) is
failing or working? That would give a starting
position on which bytes might be corrupted.

Ivo
