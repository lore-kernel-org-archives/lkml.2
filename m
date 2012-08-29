Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab2H2Rz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 13:55:26 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:35930 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab2H2RzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 13:55:24 -0400
Date: Wed, 29 Aug 2012 19:54:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: james.d.ralston@intel.com
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Rob Landley <rob@landley.net>, Seth Heasley <seth.heasley@intel.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        Olof Johansson <olof@lixom.net>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] i2c-i801: Add Device IDs for Intel Lynx Point-LP
 PCH
Message-ID: <20120829195452.4fa8ebaa@endymion.delvare>
In-Reply-To: <1344530632-2645-1-git-send-email-james.d.ralston@intel.com>
References: <1344530632-2645-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Quite a long Cc list for such a trivial patch...

On Thu,  9 Aug 2012 09:43:52 -0700, james.d.ralston@intel.com wrote:
> From: James Ralston <james.d.ralston@intel.com>
> 
> This patch adds the SMBus Device IDs for the Intel Lynx Point-LP PCH. The Device IDs are defined in drivers/i2c/busses/i2c-i801.c

I'm curious what the "LP" stands for. Low power?

> 
> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
>  Documentation/i2c/busses/i2c-i801 |    1 +
>  drivers/i2c/busses/Kconfig        |    1 +
>  drivers/i2c/busses/i2c-i801.c     |    3 +++
>  3 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
> index 615142d..53207df 100644
> --- a/Documentation/i2c/busses/i2c-i801
> +++ b/Documentation/i2c/busses/i2c-i801
> @@ -21,6 +21,7 @@ Supported adapters:
>    * Intel DH89xxCC (PCH)
>    * Intel Panther Point (PCH)
>    * Intel Lynx Point (PCH)
> +  * Intel Lynx Point_LP (PCH)

You spelled it "Lynx Point-LP" (with dash not underscore) in the patch
summary. Consistency in naming would be preferred. I'll use a dash
everywhere and apply your patch.

>     Datasheets: Publicly available at the Intel website
>  
>  On Intel Patsburg and later chipsets, both the normal host SMBus controller
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 2e7530a..3500af7 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -104,6 +104,7 @@ config I2C_I801
>  	    DH89xxCC (PCH)
>  	    Panther Point (PCH)
>  	    Lynx Point (PCH)
> +	    Lynx Point_LP (PCH)
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-i801.
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 898dcf9..c467038 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -52,6 +52,7 @@
>    DH89xxCC (PCH)        0x2330     32     hard     yes     yes     yes
>    Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
>    Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
> +  Lynx Point_LP (PCH)   0x9c22     32     hard     yes     yes     yes
>  
>    Features supported by this driver:
>    Software PEC                     no
> @@ -155,6 +156,7 @@
>  #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
>  #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
>  #define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
>  
>  struct i801_priv {
>  	struct i2c_adapter adapter;
> @@ -771,6 +773,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS) },
>  	{ 0, }
>  };
>  


-- 
Jean Delvare
