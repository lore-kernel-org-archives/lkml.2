Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab0EMUad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:30:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63283 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab0EMUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:30:31 -0400
Message-ID: <4BEC6141.2010201@oracle.com>
Date: Thu, 13 May 2010 13:29:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, jmorris@namei.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH] TPM: ACPI/PNP dependency removal
References: <1273782204.8536.4.camel@blackbox.ibm.com>
In-Reply-To: <1273782204.8536.4.camel@blackbox.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BEC6163.0130:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rajiv Andrade wrote:
> This patch pushes the ACPI dependency into the device driver code
> itself. Now, even without ACPI/PNP enabled, the device can be registered
> using the TIS specified memory space. This will however result in the
> lack of access to the bios event log, being the only implication of such
> ACPI removal.
> 
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  drivers/char/tpm/Kconfig   |    6 ++++--
>  drivers/char/tpm/tpm_tis.c |   42 ++++++++++++++++++++++--------------------
>  2 files changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index f5fc64f..fffc994 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -17,14 +17,16 @@ menuconfig TCG_TPM
>  	  obtained at: <http://sourceforge.net/projects/trousers>.  To 
>  	  compile this driver as a module, choose M here; the module 
>  	  will be called tpm. If unsure, say N.
> -	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
> +	  Notes: 
> +	  1) For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
>  	  and CONFIG_PNPACPI.
> +	  2) Without ACPI enabled, the bios event log won't be accessible,

s/bios/BIOS/ please

> +	  which is required to validate the PCR 0-7 values.
>  
>  if TCG_TPM
>  
>  config TCG_TIS
>  	tristate "TPM Interface Specification 1.2 Interface"
> -	depends on PNP
>  	---help---
>  	  If you have a TPM security chip that is compliant with the
>  	  TCG TIS 1.2 TPM specification say Yes and it will be accessible

Thanks for the update.
