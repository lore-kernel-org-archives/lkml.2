Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2GPWH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 18:07:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37836 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2GPWHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 18:07:23 -0400
Date: Mon, 16 Jul 2012 15:07:19 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: psmouse synaptics: "hardware appears to be different" bail out
Message-ID: <20120716220718.GA28635@core.coreip.homeip.net>
References: <20120716214453.GA14785@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716214453.GA14785@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 11:44:53PM +0200, Andreas Mohr wrote:
> Hi,
> 
> just found the following in dmesg after resume
> (currently running -rc7):
> 
> [ 9312.672073] psmouse serio2: synaptics: hardware appears to be
> different: id(149271-149271), model(114865-114865), caps(d04771-d04773),
> ext(a40000-a40000).
> 
> Acer Aspire One A110L here.
> 
> Any clever thoughts about this?
> Just thought that it might be useful to report it,
> especially since the function (in drivers/input/mouse/synaptics.c)
> bails out right after this check/message.

Hmm, we do not really expect the touchpad change it's caracteristics at
all during its lifetime, so no clever ideas here... It looks like a
single bit error, but KBC should have signalled parity error in this
case...

-- 
Dmitry
