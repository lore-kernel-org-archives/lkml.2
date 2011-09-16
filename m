Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab1IPSWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:22:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37696 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1IPSWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:22:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110916171824.GA23338@linutronix.de>
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
	<20110908191146.GA8552@suse.de>
	<op.v1jdo3g53l0zgt@mnazarewicz-glaptop>
	<20110909184354.GA30278@suse.de>
	<20110916171824.GA23338@linutronix.de>
Date: Fri, 16 Sep 2011 11:22:05 -0700
Message-ID: <CAJJ6jxsC3vUS1dPSYDXCcjrdYB=ybHWaC9=RhHDWQgM6WgcGmw@mail.gmail.com>
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
From: Steve Calfee <stevecalfee@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, Michal Nazarewicz <mina86@mina86.com>,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 10:18 AM, Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
> Would it be possible to come up with a gadget-hub driver which can have
> multiple gadget attached? This should get rid of this kind of gadget
> drivers, right?
>
> Sebastian
> --

Hi,

To literally make a gadget that can emulate a hub (where it could
present port 1 as function x, port 2 as function y etc) would require
special hardware. The (bus speed) translations and (ack/nak) timings
are speced very tightly for hubs (see chapter 11 of the spec). Each
function would have its own usb bus address - otherwise one gadget
could not nak while another transfered data. Each bus address would
have to meet the spec in responding to all signaling.

Think about how the individual functions would announce themselves to
the host - when the port is enabled the available/speed pull ups would
have to be set, but other ports have to be in their old state.
Reset/Suspend signaling would have to be handled only by the selected
function.

So while it would make multiple function gadgets somewhat easier I
don't see how it is possible, do composite and/or compound gadgets
instead.

Regards, Steve
