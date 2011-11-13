Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1KMJwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 04:52:34 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65434 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab1KMJwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 04:52:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAHR064jx4jWdLHRaKECEz-1Wauhm1xR+pGNLXsPPn7jYKJ81Uw@mail.gmail.com>
References: <20110920161743.GA32737@kroah.com>
	<CAHR064gzgKtLSNQ-NuoKWW9-Nv_S0myOusQT+-CxVVeyO5fMKA@mail.gmail.com>
	<20111107181209.GB5474@suse.de>
	<CAHR064jx4jWdLHRaKECEz-1Wauhm1xR+pGNLXsPPn7jYKJ81Uw@mail.gmail.com>
Date: Sun, 13 Nov 2011 10:52:29 +0100
Message-ID: <CAHR064i+PNSae_3+PnMtmkhpRw=+5qEAdUu_EzOiBfVzF_gfhA@mail.gmail.com>
Subject: Re: [patch 0/8] Samsung Laptop driver patches - resend
From: Corentin Chary <corentin.chary@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 7, 2011 at 11:57 PM, Corentin Chary
<corentin.chary@gmail.com> wrote:
> On Mon, Nov 7, 2011 at 7:12 PM, Greg KH <gregkh@suse.de> wrote:
>> On Sun, Nov 06, 2011 at 11:54:39PM +0100, Corentin Chary wrote:
>>> Just got a 90X3A from Intel and I'll try to take a look at samsung-laptop
>>> since some features are missing (keyboard backlight for example).
>>
>> Try adding your device to this driver.  Or, watch out, as newer Samsung
>> devices support backlight control "properly" through acpi, which is
>> good, and this driver is not needed by them at all.
>
> I'm speaking about *keyboard* backlight here, not screen backlight
> (which is already available using both the acpi driver and the intel
> graphic driver). There is also a setting to enable USB power while
> sleeping without having to change it in the BIOS, and it's probably
> possible to control the sound and wlan led.
>
>>> Do you have any doc on the vendor "interface" (other than just reading
>>> the code :) ) ?
>>
>> I do not have any documentation for the interface, sorry.  The code
>> should be self-explanatory.
>
> Arg... I can understand the code, I can easilly write ACPI and WMI
> drivers, but the "SABI" thing will be harder to reverse engineer :).

It was in fact very fun to find out new commands, and I found interesting stuff.

However, I have a quick question: what does "wireless button" control
exactly ? Because my laptop (SwSmi@ one), seems to have a totally
different command to control rfkill (both for bluetooth and wlan). My
guess is that command do the same thing that happens when you press
the Fn+F12 key, but if it's really that I'd prefer use the "true"
rfkill interface with differencied control for bluetooth and wlan.

I have found other interesting information including:
- you can pass up to 11 byte of data for each command (but I didn't
found any command using more than 6)
- there is a way to find the model name and bios version near the signature
- wlan and bluetooth control
- USB charge control
- Keyboard backlight control
- Battery life extender control

I'll try to clean that up and send some patches in one week or two.

-- 
Corentin Chary
http://xf.iksaif.net
