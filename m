Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2CMQNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:13:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab2CMQNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:13:32 -0400
Date: Tue, 13 Mar 2012 17:13:29 +0100 (CET)
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
In-Reply-To: <0EB7B0B6-EE4F-4E42-A1E6-0414D39AEAE6@enac.fr>
Message-ID: <alpine.LNX.2.00.1203131710120.18356@pobox.suse.cz>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com> <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>    <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>   <20120308105737.GA11201@polaris.bitmath.org>  
 <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>   <alpine.LNX.2.00.1203121650500.18356@pobox.suse.cz>  <1331574151.14217.86.camel@aeonflux>  <4B25AD62-B1C9-4C57-AE64-34EB7F47DC9B@enac.fr> <alpine.LNX.2.00.1203122316420.18356@pobox.suse.cz>
 <0EB7B0B6-EE4F-4E42-A1E6-0414D39AEAE6@enac.fr>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Stéphane Chatty wrote:

> > Let me answer by a bit of history here. Originally, there have been 
> > two copies of HID code in the kernel -- one for USB HID devices, one 
> > for Bluetooth HID devices. The parsers were not kept in sync, and 
> > there was a lot of code duplication, creating quite some mess.
> > 
> > What I did back then in 2006 was that I have extracted the abstract HID 
> > parts into HID core, and made it transport-independent in principle, so 
> > that both USB HID and Bluetooth HID shared the common infrastructure, 
> > while implementing different transport protocols.
> > 
> > Then we extended it a little bit further, making HID core a proper bus, to 
> > which individual drivers (independently on underlying transport protocol 
> > used) can register.
> > 
> > Currently there are just Bluetooth (hidp) and USB (usbhid) transport 
> > implementations, with HID core being transport independent.
> > 
> > Hope this helps,
> 
> Very useful clarification, thanks. Now, I guess I understand why Marcel 
> wants to keep hidp in bluetooth/. And, to be honest, things would have 
> been clearer to me when I explored the handling of the USB/HID class if 
> I had found a hid (or usbhid) directory in usb/ rather than a usbhid 
> subdirectory in hid/: it did not make the above situation very obvious 
> to me. Don't you think we could go along with Marcel and move usbhid to 
> usb/?

It seemed to be convenient back then, and it's still convenient for me in 
some sense, as I am maintaining both HID core and USB HID, but bluetooth 
guys are maintaining the bluetooth transport.

But I don't have strong opinion either way, I can as well move usbhid to 
drivers/usb and maintain it there (will need to talk to Greg about it 
first of course). But frankly, I don't see it making things magically 
clear for everyone :)

-- 
Jiri Kosina
SUSE Labs
