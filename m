Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966045Ab0GPQYs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 12:24:48 -0400
Received: from mail4.comsite.net ([205.238.176.238]:31473 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965979Ab0GPQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 12:24:47 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=129.33.193.72;
From: Milton Miller <miltonm@bga.com>
To: Lee Jones <lee.jones@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>, Martin Michlmayr <tbm@cyrius.com>,
        Woody Suwalski <terraluna977@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Stop ARM boards crashing when CUPS is loaded -
	2.6.35-rc5
Message-id: <miltonm-arm-parport-1@bga.com>
In-Reply-To: <4C402746.6080309@canonical.com>
References: <4C3C72C6.4000005@canonical.com>
	<20100715130214.4c9303b2.akpm@linux-foundation.org>
	<20100715200618.GA6773@n2100.arm.linux.org.uk>
	<4C40218A.4090806@canonical.com>
	<20100716092018.GB16995@n2100.arm.linux.org.uk>
Date: Fri, 16 Jul 2010 11:23:55 -0500
X-Originating-IP: 129.33.193.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Jul 16 2010 about 05:33:06 EST,  Lee Jones wrote:
> > The best solution is probably for the parport code to go through a
> > modernisation cycle like the serial code did, essentially using
> > platform devices to pass the base addresses. This would make the
> > driver more portable, and eliminates this problem entirely (because
> > platforms which don't have parports won't register the platform device(s)
> > necessary for parport to even probe illegal addresses.)
> 
> This sounds brilliant - when are you going to start? </kidding>

It has a long time ago ...

drivers/parport/parport_pc.c calls parport_pc_find_nonpci_ports,
which is in asm/parport.h

> 
> In all seriousness, do you think anyone is likely to undertake this
> work anytime soon? I am seeing this problem in a distribution which
> is due for release in October. I have no problem implementing a config
> change in the meantime, but as you say, a more _correct_ and portable
> solution should be sought.

Why not replace the arm asm/parport.h with asm-generic/parport.h which
already has a check for CONFIG_ISA, which appears to only be selected
on a few ARM platforms?

milton
