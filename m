Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab0FFVJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 17:09:34 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45226 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab0FFVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 17:09:32 -0400
X-Auth-Info: 4HqbFoBIvd7/UTmr4ASnaXUPJ0Dakdx63BAGW7hv0pw=
To: Rupjyoti Sarmah <rsarmah@amcc.com>
cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, sr@denx.de,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       jgarzik@pobox.com
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH]460EX on-chip SATA driver<kernel 2.6.33><resubmission>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <201006041226.o54CQH2V017366@amcc.com>
References: <201006041226.o54CQH2V017366@amcc.com>
Comments: In-reply-to Rupjyoti Sarmah <rsarmah@amcc.com>
   message dated "Fri, 04 Jun 2010 17:56:17 +0530."
Date: Sun, 06 Jun 2010 23:09:28 +0200
Message-Id: <20100606210928.1BEE6FA8EE@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rupjyoti Sarmah,

In message <201006041226.o54CQH2V017366@amcc.com> you wrote:
> This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.
> 
> Signed-off-by: Rupjyoti Sarmah <rsarmah@appliedmicro.com> 
> Signed-off-by: Mark Miesfeld <mmiesfeld@appliedmicro.com>
> Signed-off-by: Prodyut Hazarika <phazarika@appliedmicro.com>
> 
> ---
>  drivers/ata/Kconfig          |    9 +
>  drivers/ata/Makefile         |    1 +
>  drivers/ata/sata_dwc_460ex.c | 1808 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1818 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/ata/sata_dwc_460ex.c

This driver needs fixing. It will not compile against recent kernel
versions.

...
> diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
> new file mode 100644
> index 0000000..e6e2896
> --- /dev/null
> +++ b/drivers/ata/sata_dwc_460ex.c
> @@ -0,0 +1,1808 @@
...
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/device.h>
> +#include <linux/of_platform.h>
> +#include <linux/libata.h>
> +#include "libata.h"
> +
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_cmnd.h>

You miss a "#include <linux/slab.h>" here.

...
> +	for (i = 0; i < SATA_DWC_QCMD_MAX; i++)
> +		hsdevp->cmd_issued[i] = SATA_DWC_CMD_ISSUED_NOT;
> +
> +	ap->prd = 0;	/* set these so libata doesn't use them */
> +	ap->prd_dma = 0;

s/prd/bmdma_prd/ in these two lines (cf. commit f60d7011).


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
He had quite a powerful intellect, but it  was  as  powerful  like  a
locomotive,  and  ran on rails and was therefore almost impossible to
steer.                          - Terry Pratchett, _Lords and Ladies_
