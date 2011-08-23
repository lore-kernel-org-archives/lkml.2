Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab1HWPHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:07:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:11525 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab1HWPHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:07:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:content-type:to:cc:subject:references:
	mime-version:content-transfer-encoding:from:organization:date:message-id:
	in-reply-to:user-agent:x-system-of-record;
	b=oze9co2M66dabWkpdaesLqaQIlHOdJm6uiwn1KqBfzClDCM6ktGkglgx7fc6Fv2RU
	yB1LY9WDJI5huuBYLTvvw==
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Alan Stern" <stern@rowland.harvard.edu>, "Felipe Balbi" <balbi@ti.com>
Cc: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
        "Yang Rui Rui" <ruirui.r.yang@tieto.com>,
        "Dave Young" <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
References: <op.v0n67imkvgw7ix@mnazarewicz-glaptop>
 <Pine.LNX.4.44L0.1108231030270.2069-100000@iolanthe.rowland.org>
 <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mnazarewicz@google.com>
Organization: Google
Date: Tue, 23 Aug 2011 17:07:11 +0200
Message-ID: <op.v0n9l9h9vgw7ix@mnazarewicz-glaptop>
In-Reply-To: <20110823145759.GM1341@legolas.emea.dhcp.ti.com>
User-Agent: Opera Mail/11.50 (Linux)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 16:58:01 +0200, Felipe Balbi <balbi@ti.com> wrote:
> I stand with the fact that if they are part of the same configuration,
> there's no way around it, storage will have to come down to full speed.
> Unless I'm missing something.

If you look at config_buf() in composite.c, you'll notice that composite
just skips functions that do not support current speed.  This means, that
if a connection uses high speed but given function can handle only full
speed, it won't be included in the descriptors.

config_buf() is called from config_desc() which similarly, iterates over
configurations skipping the ones that do not support given speed.

Configuration is defined to support given speed if at least one function
that is added to that configuration supports that speed (see
usb_add_function()).

This also allows creating functions that support high speed but do not
support full speed (which I'm unsure whether it makes sense).

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
