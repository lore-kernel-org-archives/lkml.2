Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab2GVOpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 10:45:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53889 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2GVOpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 10:45:13 -0400
Date: Sun, 22 Jul 2012 07:44:29 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: next/mmotm unbootable on G5: irqdomain
In-Reply-To: <1342962554.29855.23.camel@pasglop>
Message-ID: <alpine.LSU.2.00.1207220742340.1289@eggly.anvils>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils> <1342962554.29855.23.camel@pasglop>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jul 2012, Benjamin Herrenschmidt wrote:
> On Sat, 2012-07-21 at 19:47 -0700, Hugh Dickins wrote:
> > I have to revert the patch below from mmotm 2012-07-20-16-30 or
> > next-20120720 in order to boot on the PowerPC G5: otherwise it
> > freezes before switching to the framebuffer console - but I'm
> > not certain where because that initial console doesn't scroll
> > (there are mpic messages at bottom and at top of screen, probably
> > later messages at the top but I don't know the sequence).
> 
> Remind me your G5 variant ? (/proc/cpuinfo will do). I'll have a look
> tomorrow (and thanks for testing !).
> 
> > commit 94f036a1f242f98cc30700b7676c07270a9c5c27
> > Author: Grant Likely <grant.likely@secretlab.ca>
> > Date:   Sun Jun 3 22:04:39 2012 -0700
> > 
> > irqdomain: eliminate slow-path revmap lookups

Thanks, Ben - here's my /proc/cpuinfo:

processor	: 0
cpu		: PPC970MP, altivec supported
clock		: 2500.000000MHz
revision	: 1.1 (pvr 0044 0101)

processor	: 1
cpu		: PPC970MP, altivec supported
clock		: 2500.000000MHz
revision	: 1.1 (pvr 0044 0101)

processor	: 2
cpu		: PPC970MP, altivec supported
clock		: 2500.000000MHz
revision	: 1.1 (pvr 0044 0101)

processor	: 3
cpu		: PPC970MP, altivec supported
clock		: 2500.000000MHz
revision	: 1.1 (pvr 0044 0101)

timebase	: 33333333
platform	: PowerMac
model		: PowerMac11,2
machine		: PowerMac11,2
motherboard	: PowerMac11,2 MacRISC4 Power Macintosh 
detected as	: 337 (PowerMac G5 Dual Core)
pmac flags	: 00000000
L2 cache	: 1024K unified
pmac-generation	: NewWorld

Hugh
