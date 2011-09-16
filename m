Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab1IPSzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:55:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:50864 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1IPSzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:55:14 -0400
Message-ID: <4E739B8B.9060209@linutronix.de>
Date: Fri, 16 Sep 2011 20:55:07 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Icedove/3.1.13
MIME-Version: 1.0
To: Steve Calfee <stevecalfee@gmail.com>
CC: Greg KH <gregkh@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>	<20110908191146.GA8552@suse.de>	<op.v1jdo3g53l0zgt@mnazarewicz-glaptop>	<20110909184354.GA30278@suse.de>	<20110916171824.GA23338@linutronix.de> <CAJJ6jxsC3vUS1dPSYDXCcjrdYB=ybHWaC9=RhHDWQgM6WgcGmw@mail.gmail.com>
In-Reply-To: <CAJJ6jxsC3vUS1dPSYDXCcjrdYB=ybHWaC9=RhHDWQgM6WgcGmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2011 08:22 PM, Steve Calfee wrote:
> Hi,
Hi Steve,

> To literally make a gadget that can emulate a hub (where it could
> present port 1 as function x, port 2 as function y etc) would require
> special hardware. The (bus speed) translations and (ack/nak) timings
> are speced very tightly for hubs (see chapter 11 of the spec). Each
> function would have its own usb bus address - otherwise one gadget
> could not nak while another transfered data. Each bus address would
> have to meet the spec in responding to all signaling.

That is something I haven't figured out. So the plan was to expose each
gadget as an individual port with its own descriptors. The device
number is indeed a problem that can be hardly solved. The Host sets the
address of the device it talks to and the hub routes it properly. This
is someting we can't emulate.
Hmm. So it boils down to an efficient way of providing multiple
interface descriptors without adding a lot of code each time?

> Regards, Steve
Sebastian
