Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2BPKvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:51:20 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42993 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906Ab2BPKvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:51:18 -0500
Message-ID: <4F3CDF9F.9080204@ti.com>
Date: Thu, 16 Feb 2012 16:21:11 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: akpm@linux-foundation.org, greg@kroah.com
CC: Aneesh V <aneesh@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] Add TI EMIF SDRAM controller driver
References: <1328357771-31644-1-git-send-email-aneesh@ti.com>
In-Reply-To: <1328357771-31644-1-git-send-email-aneesh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Greg,

On Saturday 04 February 2012 05:46 PM, Aneesh V wrote:
> Add a driver for the EMIF SDRAM controller used in TI SoCs
> 
> EMIF is an SDRAM controller that supports, based on its revision,
> one or more of LPDDR2/DDR2/DDR3 protocols.This driver adds support
> for LPDDR2.
> 
> The driver supports the following features:
> - Calculates the DDR AC timing parameters to be set in EMIF
>   registers using data from the device data-sheets and based
>   on the DDR frequency. If data from data-sheets is not available
>   default timing values from the JEDEC spec are used. These
>   will be safe, but not necessarily optimal
> - API for changing timings during DVFS or at boot-up
> - Temperature alert configuration and handling of temperature
>   alerts, if any for LPDDR2 devices
>   * temperature alert is based on periodic polling of MR4 mode
>     register in DDR devices automatically performed by hardware
>   * timings are de-rated and brought back to nominal when
>     temperature raises and falls respectively
> - Cache of calculated register values to avoid re-calculating
>   them
> 
> The driver will need some minor updates when it is eventually
> integrated with DVFS. This can not be done now as DVFS support
> is not available yet in mainline.
> 
> Discussions with Santosh Shilimkar <santosh.shilimkar@ti.com>
> were immensely helpful in shaping up the interfaces. Vibhore Vardhan
> <vvardhan@gmail.com> did the initial code snippet for thermal
> handling.
> 
> Testing: 
> - The driver is tested on OMAP4430 SDP.
> - The driver in a slightly adapted form is also tested on OMAP5.
> - Since mainline kernel doesn't have DVFS support yet,
>   testing was done using a test module.
> - Temperature alert handling was tested with simulated interrupts
>   and faked temperature values as testing all cases in real-life
>   scenarios is difficult.
> 
[...]

>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c |  110 ++
>  drivers/misc/Kconfig                       |   20 +
>  drivers/misc/Makefile                      |    2 +
>  drivers/misc/emif.c                        | 1522 ++++++++++++++++++++++++++++
>  drivers/misc/emif_regs.h                   |  461 +++++++++
>  drivers/misc/jedec_ddr_data.c              |  141 +++
>  include/linux/emif.h                       |  257 +++++
>  include/linux/jedec_ddr.h                  |  174 ++++

Any suggestion on where this driver can reside. It's a memory
controller driver which supports standard DDR functionality
as per JDEC specs including thermal alert. On top of
that it does support DVFS using the TI PRCM IP block.

Regards,
Santosh


