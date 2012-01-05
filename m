Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2AELm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 06:42:59 -0500
Received: from vm4.telegraphics.com.au ([98.124.60.149]:40201 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab2AELm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 06:42:58 -0500
Date: Thu, 5 Jan 2012 22:42:54 +1100 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Debian GNU/Linux m68k <debian-68k@lists.debian.org>
Subject: Re: [RFC] m68k: Update defconfigs
In-Reply-To: <alpine.DEB.2.00.1201042252450.15625@ayla.of.borg>
Message-ID: <alpine.LNX.2.00.1201052212470.6601@nippy.intranet>
References: <alpine.DEB.2.00.1201042252450.15625@ayla.of.borg>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Jan 2012, Geert Uytterhoeven wrote:

> Findings:
>   - CONFIG_BLK_DEV_SWIM is m, while CONFIG_AMIGA_FLOPPY and
>     CONFIG_ATARI_FLOPPY are y.

My defconfig patch used "m" because (if I recall correctly) the SWIM 
driver is experimental code that couldn't be safely loaded on all 
machines.

>   - Amiga and Atari use CONFIG_RTC_CLASS, the others don't.
>     Should we switch everything to CONFIG_RTC_CLASS (and thus drop
>     CONFIG_GEN_RTC)? We do have CONFIG_RTC_DRV_GENERIC now.

This would alter the device major/minor numbers and devtmpfs path, right?

Also I wonder about CONFIG_RTC_HCTOSYS on Macs without a working RTC 
driver. Would enabling CONFIG_RTC_HCTOSYS change present behaviour?

I suppose it might need some testing. Otherwise, I think harmonising this 
across defconfigs (and distro configs) is a good idea.

Finn
