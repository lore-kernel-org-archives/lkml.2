Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab2KWJlk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:41:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59758 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759180Ab2KWJlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:41:37 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V3 3/3] mfd: stmpe: Update DT support in stmpe driver
To: Viresh Kumar <viresh.kumar@linaro.org>, sameo@linux.intel.com
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org
In-Reply-To: <7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org> <7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org>
Date: Fri, 23 Nov 2012 09:41:32 +0000
Message-Id: <20121123094132.EFCB73E07BE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Nov 2012 00:26:20 +0530, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> From: Vipul Kumar Samar <vipulkumar.samar@st.com>
> 
> This patch extends existing DT support for stmpe devices. This updates:
> - DT support from stmpe SPI and I2C drivers
> - missing header files in stmpe.c
> - stmpe_of_probe() with pwm, rotator and new bindings.
> - Bindings are updated in binding document.
> 
> Signed-off-by: Vipul Kumar Samar <vipulkumar.samar@st.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> V2->V3:
> ------
> - Removed sub-modules DT bindings from this patch
> - Retain original work done by Lee Jones
> 
>  Documentation/devicetree/bindings/mfd/stmpe.txt | 12 ++++++++----
>  drivers/mfd/stmpe-i2c.c                         | 15 +++++++++++++++
>  drivers/mfd/stmpe-spi.c                         | 15 +++++++++++++++
>  drivers/mfd/stmpe.c                             | 21 +++++++++++++++------
>  4 files changed, 53 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/stmpe.txt b/Documentation/devicetree/bindings/mfd/stmpe.txt
> index 8f0aeda..8f65c8d 100644
> --- a/Documentation/devicetree/bindings/mfd/stmpe.txt
> +++ b/Documentation/devicetree/bindings/mfd/stmpe.txt
> @@ -1,13 +1,17 @@
> -* STMPE Multi-Functional Device
> +* ST Microelectronics STMPE Multi-Functional Device
> +
> +STMPE is an MFD device which may expose following inbuilt devices: gpio, keypad,
> +touchscreen, adc, pwm, rotator.
>  
>  Required properties:
> - - compatible                   : "st,stmpe[811|1601|2401|2403]"
> - - reg                          : I2C address of the device
> + - compatible                   : "st,stmpe[610|801|811|1601|2401|2403]"
> + - reg                          : I2C/SPI address of the device
>  
>  Optional properties:
>   - interrupts                   : The interrupt outputs from the controller
> - - interrupt-controller         : Marks the device node as an interrupt controller
>   - interrupt-parent             : Specifies which IRQ controller we're connected to
> + - irq-trigger			: IRQ trigger to use for the interrupt to the host
> + - irq-invert-polarity		: bool, IRQ line is connected with reversed polarity

This looks odd. Normally the interrupt polarity should be encoded in the irq
specifier flags field.

g.

