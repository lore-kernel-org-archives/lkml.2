Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab0ENOkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:40:11 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55775 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab0ENOkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:40:08 -0400
Subject: Re: [PATCH] ima: remove ACPI dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
       Serge Hallyn <serue@us.ibm.com>, James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>
In-Reply-To: <1273011390-6090-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1273011390-6090-1-git-send-email-zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 10:39:56 -0400
Message-ID: <1273847996.3215.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once the 'TPM: ACPI/PNP dependency removal' patch is accepted
http://lkml.org/lkml/2010/5/13/410, please accept this previously posted
patch (with either updating the prereq URL or removing it.)

thanks,

Mimi

On Tue, 2010-05-04 at 18:16 -0400, Mimi Zohar wrote:
> The ACPI dependency moved to the TPM, where it belongs.  Although
> IMA per-se does not require access to the bios measurement log,
> verifying the IMA boot aggregate does, which requires ACPI.
> 
> This patch prereq's 'TPM: ACPI/PNP dependency removal'
> http://lkml.org/lkml/2010/5/4/378.
> 
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Tested-by: Serge Hallyn <serue@us.ibm.com>
> ---
>  security/integrity/ima/Kconfig |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index 3d7846d..b6ecfd4 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -2,15 +2,14 @@
>  #
>  config IMA
>  	bool "Integrity Measurement Architecture(IMA)"
> -	depends on ACPI
>  	depends on SECURITY
>  	select SECURITYFS
>  	select CRYPTO
>  	select CRYPTO_HMAC
>  	select CRYPTO_MD5
>  	select CRYPTO_SHA1
> -	select TCG_TPM
> -	select TCG_TIS
> +	select TCG_TPM if !S390
> +	select TCG_TIS if TCG_TPM
>  	help
>  	  The Trusted Computing Group(TCG) runtime Integrity
>  	  Measurement Architecture(IMA) maintains a list of hash


