Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2HOUGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:06:32 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33905 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab2HOUG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:06:26 -0400
Date: Wed, 15 Aug 2012 15:04:58 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: "Zhang, Xiaoyan" <xiaoyan.zhang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Cihula, Joseph" <joseph.cihula@intel.com>,
        "Wei, Gang" <gang.wei@intel.com>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>,
        "srajiv@linux.vnet.ibm.com" <srajiv@linux.vnet.ibm.com>,
        "m.selhorst@sirrix.com" <m.selhorst@sirrix.com>,
        "shpedoikal@gmail.com" <shpedoikal@gmail.com>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "james.l.morris@oracle.com" <james.l.morris@oracle.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] driver: add PPI support in tpm driver
Message-ID: <20120815200458.GB27618@linux.vnet.ibm.com>
References: <1340203963.24516.2.camel@localhost>
 <20120711152430.GC21153@linux.vnet.ibm.com>
 <953B7F5DA8C0F44CBD2621D8763F4F600C8A32@SHSMSX101.ccr.corp.intel.com>
 <20120712144529.GA32640@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712144529.GA32640@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081520-5518-0000-0000-000006DDEFA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 09:45:29AM -0500, Kent Yoder wrote:
> On Thu, Jul 12, 2012 at 02:38:56AM +0000, Zhang, Xiaoyan wrote:
> > Hi Kent,
> > 
> > Thanks for your comment on the patch. But there's some confusion on my side.
> > You mentioned not to change the tpm driver name. But the driver is linked from tpm.c and tpm_ppi.c, so I should change the original tpm.c file name, right? Is it acceptable to change tpm.c to tpm_common.c or tpm_utils.c or else?
> 
>   I think you can just add tpm_ppi.c like this:
> 
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index beac52f6..96b9222 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -4,7 +4,7 @@
>  obj-$(CONFIG_TCG_TPM) += tpm.o
>  ifdef CONFIG_ACPI
>         obj-$(CONFIG_TCG_TPM) += tpm_bios.o
> -       tpm_bios-objs += tpm_eventlog.o tpm_acpi.o
> +       tpm_bios-objs += tpm_eventlog.o tpm_acpi.o tpm_ppi.o
>  endif
>  obj-$(CONFIG_TCG_TIS) += tpm_tis.o
>  obj-$(CONFIG_TCG_TIS_I2C_INFINEON) += tpm_i2c_infineon.o

Hi Xiaoyan,

  Can you please resubmit the PPI patches applying on top of this tree?

  git://github.com:shpedoikal/linux.git v3.6-rc1-tpmdd-staging

Thanks,
Kent

> 
> Kent
> 
> > 
> > Thanks,
> > Xiaoyan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

