Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab1F3QNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:13:33 -0400
Received: from ns.penguin.cz ([84.21.108.25]:57539 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab1F3QNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:13:32 -0400
Subject: Re: kernel panic in spi_complete() on spitz (PXA270)
From: Stanislav Brabec <utx@penguin.cz>
To: Igor Grinberg <grinberg@compulab.co.il>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
        zaurus-devel@www.linuxtogo.org,
        spi-devel-general@lists.sourceforge.net, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com
In-Reply-To: <4E0C957F.8080807@compulab.co.il>
References: <1308845380.4533.54.camel@oct.suse.cz>
	 <201106301352.21684.marek.vasut@gmail.com>
	 <1309445118.4406.47.camel@oct.suse.cz>  <4E0C957F.8080807@compulab.co.il>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Jun 2011 18:13:26 +0200
Message-ID: <1309450406.4406.59.camel@oct.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Grinberg wrote:
> On 06/30/11 17:45, Stanislav Brabec wrote:
> I want to
> > add .needs_regulator bool to ads7846.c and send the patch again to the
> > list.
> 
> Please, don't...
> I thought we've finished discussing the regulator issue...

The discussion ended without a fix (at least for spitz). I seen two
proposals:
- As ADS7846 hardware does not require dedicated regulator, don't
  require it in driver and fail only on platforms that have a dedicated
  regulator.
- Use dummy regulators for all platforms without dedicated ADS7846
  regulator.

>1) add regulator definition for ads7846 into the board file
There is no dedicated regulator on spitz, ADS7846 uses common always-on
power supply.

>2) enable the CONFIG_REGULATOR_DUMMY in your kernel configuration
>3) use regulator_use_dummy_regulator() call in the board file.

OK, I will do 2 or 3. In the new kernel spitz has a regulator, but it is
not related to ADS7846. And it is actually broken:

I2C: i2c-0: PXA I2C adapter
Resetting I2C Controller Unit
 (null): i2c_pxa_abort: called in slave mode
i2c i2c-1: adapter [pxa_i2c-i2c.1] registered
i2c 1-000c: uevent
isl6271a 1-000c: probe
i2c i2c-1: master_xfer[0] R, addr=0x0c, len=1
i2c i2c-1: setting to bus master
i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000442, ICR=000007e0, IBMR=03
i2c i2c-1: state:i2c_pxa_irq_txempty:932: ISR=00000002, ICR=000007e0, IBMR=03
i2c i2c-1: Retrying transmission
i2c i2c-1: setting to bus master
i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000045, ICR=000007e1, IBMR=00
i2c i2c-1: state:i2c_pxa_irq_txempty:932: ISR=00000005, ICR=000017ee, IBMR=00
i2c i2c-1: state:i2c_pxa_handler:981: ISR=00000087, ICR=000017e6, IBMR=00
print_constraints: vcc_core range: 850 <--> 1600 mV at 1350 mV 
print_constraints: vcc_core range: 1100 mV 
isl6271a 1-000c: Failed to set supply vcc_core
isl6271a 1-000c: failed to register isl6271a
isl6271a: probe of 1-000c failed with error -16
i2c i2c-1: client [isl6271a] registered with bus id 1-000c
I2C: i2c-1: PXA I2C adapter
...
cpufreq: Didn't find vcc_core regulator

-- 
Stanislav Brabec
http://www.penguin.cz/~utx

