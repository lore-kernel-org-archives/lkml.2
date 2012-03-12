Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611Ab2CLWWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:22:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297Ab2CLWV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:21:59 -0400
Date: Mon, 12 Mar 2012 23:21:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?St=E9phane_Chatty?= <chatty@enac.fr>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        "benjamin.tissoires" <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
In-Reply-To: <4B25AD62-B1C9-4C57-AE64-34EB7F47DC9B@enac.fr>
Message-ID: <alpine.LNX.2.00.1203122316420.18356@pobox.suse.cz>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com> <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>   <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>  <20120308105737.GA11201@polaris.bitmath.org> 
 <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>  <alpine.LNX.2.00.1203121650500.18356@pobox.suse.cz> <1331574151.14217.86.camel@aeonflux> <4B25AD62-B1C9-4C57-AE64-34EB7F47DC9B@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, Stéphane Chatty wrote:

> Just in case it makes a difference, I knew nothing about HIDP when I 
> wrote the message above. My point was rather that hid looks like a bus 
> to which several transport layers can connect (USB, Bluetooth, ZigBee, 
> etc), and that having USB-specific code in hid/ (as opposed to having it 
> in usb/) seems biased towards USB. I was (and am still) wondering how 
> much it limits future uses of the hid core by making it USB-dependent.
> 
> In other words: is the hid core generic enough or are there steps to 
> take to make it more generic wrt transport layers? If we are talking 
> about restructuring parts of it, this seems like the right time to ask 
> :-)

Let me answer by a bit of history here. Originally, there have been two 
copies of HID code in the kernel -- one for USB HID devices, one for 
Bluetooth HID devices.
The parsers were not kept in sync, and there was a lot of code 
duplication, creating quite some mess.

What I did back then in 2006 was that I have extracted the abstract HID 
parts into HID core, and made it transport-independent in principle, so 
that both USB HID and Bluetooth HID shared the common infrastructure, 
while implementing different transport protocols.

Then we extended it a little bit further, making HID core a proper bus, to 
which individual drivers (independently on underlying transport protocol 
used) can register.

Currently there are just Bluetooth (hidp) and USB (usbhid) transport 
implementations, with HID core being transport independent.

Hope this helps,

-- 
Jiri Kosina
SUSE Labs
