Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab0FFSwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 14:52:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54591 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab0FFSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 14:52:45 -0400
Date: Sun, 6 Jun 2010 14:52:40 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, sr@denx.de,
       linuxppc-dev@ozlabs.org, jgarzik@pobox.com
Subject: Re: [PATCH]460EX on-chip SATA driver<kernel 2.6.33><resubmission>
Message-ID: <20100606185240.GD7801@zod.rchland.ibm.com>
References: <201006041226.o54CQH2V017366@amcc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006041226.o54CQH2V017366@amcc.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 05:56:17PM +0530, Rupjyoti Sarmah wrote:
>This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.
>
>Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com> 
>Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
>Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>

What does the <kernel 2.6.33> mean in the Subject?

>
>---
> drivers/ata/Kconfig          |    9 +
> drivers/ata/Makefile         |    1 +
> drivers/ata/sata_dwc_460ex.c | 1808 ++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 1818 insertions(+), 0 deletions(-)
> create mode 100644 drivers/ata/sata_dwc_460ex.c
>
>diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
>index 56c6374..bba7b8a 100644
>--- a/drivers/ata/Kconfig
>+++ b/drivers/ata/Kconfig
>@@ -82,6 +82,15 @@ config SATA_FSL
>
> 	  If unsure, say N.
>
>+config SATA_DWC
>+	tristate "DesignWare Cores SATA support"
>+	depends on 460EX
>+	help
>+	  This option enables support for the on-chip SATA controller of the
>+	  AppliedMicro processor 460EX.
>+
>+	  If unsure, say N.
>+
> config ATA_SFF
> 	bool "ATA SFF support"
> 	default y
>diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
>index fc936d4..96ff315 100644
>--- a/drivers/ata/Makefile
>+++ b/drivers/ata/Makefile
>@@ -19,6 +19,7 @@ obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
> obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
> obj-$(CONFIG_SATA_FSL)		+= sata_fsl.o
> obj-$(CONFIG_PATA_MACIO)	+= pata_macio.o
>+obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
>
> obj-$(CONFIG_PATA_ALI)		+= pata_ali.o
> obj-$(CONFIG_PATA_AMD)		+= pata_amd.o
>diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
>new file mode 100644
>index 0000000..e6e2896
>--- /dev/null
>+++ b/drivers/ata/sata_dwc_460ex.c
>@@ -0,0 +1,1808 @@
>+/*
>+ * drivers/ata/sata_dwc_460ex.c
>+ *
>+ * Synopsys DesignWare Cores (DWC) SATA host driver
>+ *
>+ * Author: Mark Miesfeld <mmiesfeld@amcc.com>
>+ *
>+ * Ported from 2.6.19.2 to 2.6.25/26 by Stefan Roese <sr@denx.de>
>+ * Copyright 2008 DENX Software Engineering

I'm pretty sure Denx uses Signed-off-by lines in their trees.  If you've ported
it from their tree, perhaps you should keep Stefan's S-o-b line intact.

>+/******************************************************************************
>+ * Function: get_burst_length_encode
>+ * arguments: datalength: length in bytes of data
>+ * returns value to be programmed in register corrresponding to data length
>+ * This value is effectively the log(base 2) of the length
>+ *****************************************************************************/
>+static  int get_burst_length_encode(int datalength)
>+{
>+	int items = datalength >> 2;	/* div by 4 to get lword count */

A minor suggestion, but if you're going to document the interfaces this way
you might want to go ahead and use KernelDoc.  It's pretty close to what you 
have already.

josh
