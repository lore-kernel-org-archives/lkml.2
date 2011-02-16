Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1BPV1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:27:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51876 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab1BPV1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:27:49 -0500
Date: Wed, 16 Feb 2011 14:27:46 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: dilinger@queued.net, sodaville@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH TIP 02/14] x86: Add device tree support
Message-ID: <20110216212746.GB22837@angua.secretlab.ca>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
 <1295843342-1122-3-git-send-email-bigeasy@linutronix.de>
 <20110124043427.GA20274@www.tglx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110124043427.GA20274@www.tglx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:04:27AM +0530, Sebastian Andrzej Siewior wrote:
> * Sebastian Andrzej Siewior | 2011-01-24 09:58:50 [+0530]:
> 
> >This patch adds minimal support for device tree support on x86. It will
> >be passed to the kernel via setup_data which requires atleast boot
> >protocol 2.09.
> >Memory size, restricted memory regions, boot arguments are gathered the
> >traditional way so things like cmd_line are just here to let the code
> >compile.
> >The current plan is use the device tree as an extension and to gather
> >informations from it which can not be enumerated and have to be
> >hardcoded otherwise. This includes things like
> >- which devices are on this I2C/ SPI bus?
> >- how are the interrupts wired to IO APIC?
> >- where could my hpet be?
> >
> 
> Andres, this patch moves some of the OF defines you added for OLPC from
> irq.c to prom.c which requires CONFIG_X86_OF to be enabled. A later

Why not simply make prom.c depend on CONFIG_OF?  There is no need to
have an x86 specific config value for enabling devicetree code.

> patch changes irq_create_of_mapping() from returning intspec[0] to
> actually doing something. Could you please check how of OLPC gets broken
> and what we could do about it? :)
> 
> Sebastian
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss
