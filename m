Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341Ab2CMKSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 06:18:18 -0400
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:47498 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115Ab2CMKSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 06:18:15 -0400
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <alpine.LNX.2.00.1203122316420.18356@pobox.suse.cz>
Date: Tue, 13 Mar 2012 11:17:38 +0100
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0EB7B0B6-EE4F-4E42-A1E6-0414D39AEAE6@enac.fr>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com> <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>    <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>   <20120308105737.GA11201@polaris.bitmath.org>   <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>   <alpine.LNX.2.00.1203121650500.18356@pobox.suse.cz>  <1331574151.14217.86.camel@aeonflux>  <4B25AD62-B1C9-4C57-AE64-34EB7F47DC9B@enac.fr> <alpine.LNX.2.00.1203122316420.18356@pobox.suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 12 mars 2012 à 23:21, Jiri Kosina a écrit :

> On Mon, 12 Mar 2012, Stéphane Chatty wrote:
> 
>> Just in case it makes a difference, I knew nothing about HIDP when I 
>> wrote the message above. My point was rather that hid looks like a bus 
>> to which several transport layers can connect (USB, Bluetooth, ZigBee, 
>> etc), and that having USB-specific code in hid/ (as opposed to having it 
>> in usb/) seems biased towards USB. I was (and am still) wondering how 
>> much it limits future uses of the hid core by making it USB-dependent.
>> 
>> In other words: is the hid core generic enough or are there steps to 
>> take to make it more generic wrt transport layers? If we are talking 
>> about restructuring parts of it, this seems like the right time to ask 
>> :-)
> 
> Let me answer by a bit of history here. Originally, there have been two 
> copies of HID code in the kernel -- one for USB HID devices, one for 
> Bluetooth HID devices.
> The parsers were not kept in sync, and there was a lot of code 
> duplication, creating quite some mess.
> 
> What I did back then in 2006 was that I have extracted the abstract HID 
> parts into HID core, and made it transport-independent in principle, so 
> that both USB HID and Bluetooth HID shared the common infrastructure, 
> while implementing different transport protocols.
> 
> Then we extended it a little bit further, making HID core a proper bus, to 
> which individual drivers (independently on underlying transport protocol 
> used) can register.
> 
> Currently there are just Bluetooth (hidp) and USB (usbhid) transport 
> implementations, with HID core being transport independent.
> 
> Hope this helps,

Very useful clarification, thanks. Now, I guess I understand why Marcel wants to keep hidp in bluetooth/. And, to be honest, things would have been clearer to me when I explored the handling of the USB/HID class if I had found a hid (or usbhid) directory in usb/ rather than a usbhid subdirectory in hid/: it did not make the above situation very obvious to me. Don't you think we could go along with Marcel and move usbhid to usb/?

St.




