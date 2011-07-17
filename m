Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab1GQRIM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 13:08:12 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:47577 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754345Ab1GQRIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 13:08:10 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=j2gvXTY64pZ/yHa5XRjqJZnZ+SA8mXF19AXsF4LnNctTHIUOPjhAfjaduhK1MY9XBSpXsJzV2NxEfghtL6QYdw0vFt10SDONM6VkoH9Thy76jQaAivXCyre90k0OvJ/l;
Date: Sun, 17 Jul 2011 10:08:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
Cc: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix compilation warning when CONFIG_PNP is not
 defined
Message-Id: <20110717100807.97637264.rdunlap@xenotime.net>
In-Reply-To: <1310903758.15064.9.camel@d941e-10>
References: <1310903758.15064.9.camel@d941e-10>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jul 2011 07:55:58 -0400 Stefan Berger wrote:

> The is_itpm() function is only accessed from a block surrounded by
> #ifdef CONFIG_PNP. Therefore, also surround it with #ifdef CONFIG_PNP
> and remove the #else branch causing the warning.
> 
> http://lxr.linux.no/#linux+v2.6.39/drivers/char/tpm/tpm_tis.c#L622
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by:  Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> 
> ---
>  drivers/char/tpm/tpm_tis.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> Index: linux-2.6/drivers/char/tpm/tpm_tis.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm_tis.c
> +++ linux-2.6/drivers/char/tpm/tpm_tis.c
> @@ -80,7 +80,7 @@ enum tis_defaults {
>  static LIST_HEAD(tis_chips);
>  static DEFINE_SPINLOCK(tis_lock);
>  
> -#ifdef CONFIG_ACPI
> +#ifdef CONFIG_PNPN
>  static int is_itpm(struct pnp_dev *dev)
>  {
>  	struct acpi_device *acpi = pnp_acpi_device(dev);
> @@ -93,11 +93,6 @@ static int is_itpm(struct pnp_dev *dev)
>  
>  	return 0;
>  }
> -#else
> -static int is_itpm(struct pnp_dev *dev)
> -{
> -	return 0;
> -}
>  #endif
>  
>  static int check_locality(struct tpm_chip *chip, int l)
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
