Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab2CLP6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:58:36 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:48720 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751533Ab2CLP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:58:33 -0400
Message-ID: <4F5E1D22.5000003@ti.com>
Date: Mon, 12 Mar 2012 21:28:26 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Aneesh V <aneesh@ti.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 0/8] Add TI EMIF SDRAM controller driver
References: <1331222065-3579-1-git-send-email-aneesh@ti.com>
In-Reply-To: <1331222065-3579-1-git-send-email-aneesh@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 March 2012 09:24 PM, Aneesh V wrote:
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
> integrated with Dynamic Voltage and Frequency Scaling (DVFS).
> This can not be done now as DVFS support is not available in
> the mainline yet.
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
> - Tested the driver as a module
> 
> Cc: Greg KH <greg@kroah.com>
> 
> Aneesh V (7):
>   misc: ddr: add LPDDR2 data from JESD209-2
>   misc: emif: add register definitions for EMIF
>   misc: emif: add basic infrastructure for EMIF driver
>   misc: emif: handle frequency and voltage change events
>   misc: emif: add interrupt and temperature handling
>   misc: emif: add one-time settings
>   misc: emif: add debugfs entries for emif
> 
I have scanned all the patches again. Thanks a
lot for taking forward this work. Feel free to
add mine SOB for entire EMIF driver series.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Regards
Santosh
