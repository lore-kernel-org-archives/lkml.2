Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab1HWXcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:32:03 -0400
Received: from tundra.namei.org ([65.99.196.166]:59599 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab1HWXbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:31:18 -0400
Date: Wed, 24 Aug 2011 09:31:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>, m.selhorst@sirrix.com
Subject: Re: [PATCH] [REPOST] tpm: suppress durations sysfs output if not
 read
In-Reply-To: <1314103930.17826.2.camel@d941e-10>
Message-ID: <alpine.LRH.2.00.1108240930570.1603@tundra.namei.org>
References: <1314103930.17826.2.camel@d941e-10>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Stefan Berger wrote:

> Suppress the output in the 'durations' sysfs entry if they were not read
> during driver initialization. This is similar to other sysfs entries
> that return nothing if for some reason sending the commands to the TPM
> fails.
> 
> Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


> 
> ---
>  drivers/char/tpm/tpm.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/drivers/char/tpm/tpm.c
> ===================================================================
> --- linux-2.6.orig/drivers/char/tpm/tpm.c
> +++ linux-2.6/drivers/char/tpm/tpm.c
> @@ -963,6 +963,9 @@ ssize_t tpm_show_durations(struct device
>  {
>  	struct tpm_chip *chip = dev_get_drvdata(dev);
>  
> +	if (chip->vendor.duration[TPM_LONG] == 0)
> +		return 0;
> +
>  	return sprintf(buf, "%d %d %d [%s]\n",
>  		       jiffies_to_usecs(chip->vendor.duration[TPM_SHORT]),
>  		       jiffies_to_usecs(chip->vendor.duration[TPM_MEDIUM]),
> 

-- 
James Morris
<jmorris@namei.org>
