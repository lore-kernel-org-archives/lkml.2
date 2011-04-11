Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1DKOjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:39:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:58285 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1DKOjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:39:35 -0400
Date: Mon, 11 Apr 2011 16:39:30 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5 v6] usb: Add usb_endpoint_descriptor to be part of
 the struct usb_ep
Message-ID: <20110411143930.GD4018@linutronix.de>
References: <1300867420-20864-1-git-send-email-tlinder@codeaurora.org>
 <20110325134248.GN2609@legolas.emea.dhcp.ti.com>
 <000301cbec7a$3ff5cdf0$bfe169d0$@org>
 <20110328084624.GI2251@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110328084624.GI2251@legolas.emea.dhcp.ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi | 2011-03-28 11:46:25 [+0300]:

>> Could you please share you concerns? Even if they are not strong arguments
>> :).
>> Our pros for this change were that it seems more accurate that the EP
>> descriptor will be handled by the composite layer and not the FDs. Thus we
>> tried to spare the FD from saving the chosen EP descriptor and passing it to
>> different functions.
>> This change is needed for our algorithm of SS implementation in the later
>> patches in this series. 
>
>Yes, I understood that much, but it's useful for UDCs to access the EP
>descriptor (ok, we can still access it by dereferencing ep) since we can
>(actually we need to) use that to let the HW know about max packet
>sizes, endpoint types, etc etc.
>
>Also, I'm not sure composite.c should know the details about the
>endpoint. That's just a thin layer implementing the more generic part
>(standard usb requests, handling, helpers for finding endpoints, etc),
>but the one who should look into endpoint descriptors is the underlying
>controller code for the reasons I listed above.
>
>That's my feeling...

If I look at the diffstat between patch 2 and 4 I see 
| 30 files changed, 299 insertions(+), 393 deletions(-)

So she got rid of almost 100 lines. While looking at the code it seems
that every gadget driver does the same thing which is now done in one
place. I like that so far :)

Sebastian
