Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab1CaNMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:12:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46355 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1CaNMQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:12:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110331124925.GA2202@pengutronix.de>
References: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
 <1301574600-4861-2-git-send-email-monstr@monstr.eu> <20110331124925.GA2202@pengutronix.de>
From: John Williams <john.williams@petalogix.com>
Date: Thu, 31 Mar 2011 23:11:56 +1000
Message-ID: <AANLkTinJrG=s3Xuvf_=bNtYF-z8u+YXvd217UKKz24ik@mail.gmail.com>
Subject: Re: [PATCH] uio/pdrv_genirq: Add OF support
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        hjk@linutronix.de, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Sorry for the resend, my gmail session was in rich formatting mode and
the reply was rejected from the list servers.

On Thu, Mar 31, 2011 at 10:49 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
> On Thu, Mar 31, 2011 at 02:30:00PM +0200, Michal Simek wrote:
> > Support OF support. "generic-uio" compatible property is used.
>
> And exactly this was the issue last time (when I tried). This is a
> generic property, which is linux-specific and not describing HW. The
> agreement back then was to we probably need to add compatible-entries at
> runtime (something like new_id for USB). So the uio-of-driver could be
> matched against any device. Otherwise, we would collect a lot of
> potential entries like "vendor,special-card1". Although I wonder
> meanwhile if it is really going to be that bad; we don't have so much
> UIO-driver in tree as well. Maybe worth a try?


Maybe I misunderstand you, in my view it is the responsibility of
<vendor> to create their DTS files to indicate they want
<special-card1> to bind to generic-uio.

So, no great list of compat strings should grow in the driver, but
rather the user of the driver must make it happen.

Am I missing something?

Our use-case is pretty clear, in FPGA-based systems it is common to
create arbitrary devices that developers just want to control from
userspace, with simple IRQ and IO capabilities (DMA can come later :).
 They don't need to bind to other kernel APIs or subsystems, and don't
want to invest in one-off kernel drivers that simply will never go
upstream.

UIO is perfect, and simply tagging the device as generic-uio in the
DTS is so simple, clean, and elegant.  Traditional embedded developers
really light up when you tell them you can write simple IRQ handlers
in Linux userspace.  They love it even more if they don't have to
write a line of kernel code, which generic-uio enables.

John
--
John Williams, PhD, B. Eng, B. IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
