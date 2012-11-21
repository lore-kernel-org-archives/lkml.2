Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2KUQiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 11:38:12 -0500
Received: from v37049.1blu.de ([89.202.2.49]:54766 "EHLO v37049.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab2KUQiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 11:38:11 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, patrik.r.jakobsson@gmail.com,
        christian.gmeiner@gmail.com
Subject: Re: SDVO on E6xx
Date: Wed, 21 Nov 2012 17:38:08 +0100
Message-ID: <20121121163808.426108@zweiblum.hodek.net>
From: roman@hodek.net
In-Reply-To: <20121121145027.4dce136d@pyramind.ukuu.org.uk>
References: <20121121140442.782733@zweiblum.hodek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Mailer: RoMail 2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> There is an Intel driver with open kernel code and proprietary userspace for
> the Imagination 3D engine (EMGD) although only for an out of maintenance
> Fedora and for Meego and in both cases for ancient kernels.

I knew about EMGD, but not that there's code available for parts of it.

> The fully open driver is built by extracting the relevant information and
> code from these releases.

Ah, ok. Then I'll try to extract even a bit more ;-) Thanks very much for that
hint!

> If you unpack that it contains a tar ball which you can unpack which
> contains the driver.
>
> emgd/pal/sdvo
>
> looks kind of promising.

Got it now (it's common/drm/emgd_drm.tgz). 

I started to look around there, and emgd/display/pi/tnc/i2c_gmbus_tnc.c looks
as a good source of infos. At least it mentions E6xx quite often, and it uses
functions read/write_mmio_reg_tnc on TunnelCreek.

>From there I got to an interesting comment:

#ifdef CONFIG_TNC
/* Based on display port determine which mmio base to use:
 *       port_type == SDVO ==> use 0:3:0 device mmio
 *       port_type == LVDS ==> use 0:2:0 device mmio
 *       port_type == LPC  ==> use 0:31:0 device mmio
 */

Indeed, I have those additional PCI devices, and the BARs of 0:03.0 look much
like those of 0:02.0. It has PCI ID 8086:8182 and class 0x0400
(multimedia/video). And in BAR 0 at offset 0x5100 there are values that look
more like GMBUS...
(0:1f.0 exists, it declares itself as ISA bridge, and it has no BARs
assigned.)

Ok, I'll go down that road, poke around a bit there, and we'll see how far I
can get!

Roman

