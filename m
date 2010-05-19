Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab0ESUbI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:31:08 -0400
Received: from bamako.nerim.net ([62.4.17.28]:55465 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab0ESUbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:31:05 -0400
Date: Wed, 19 May 2010 22:31:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-nforce2: Remove redundant error messages on ACPI
 conflict
Message-ID: <20100519223100.1634e789@hyperion.delvare>
In-Reply-To: <1274127379-5433-1-git-send-email-chase.douglas@canonical.com>
References: <1274127379-5433-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chase,

On Mon, 17 May 2010 16:16:19 -0400, Chase Douglas wrote:
> The ACPI subsystem strictly checks for resource conflicts. When there's
> a conflict, it outputs a warning message with all the details needed to
> properly diagnose the underlying issue. However, the i2c-nforce2 driver
> also prints its own message. Not only is the message redundant, it is at
> the KERN_ERR level, which overrides some bootsplash screens for no good
> reason. This change removes the two lines that print out the error
> messages.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> ---
>  drivers/i2c/busses/i2c-nforce2.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
> index 4a48dd4..2da9a23 100644
> --- a/drivers/i2c/busses/i2c-nforce2.c
> +++ b/drivers/i2c/busses/i2c-nforce2.c
> @@ -405,7 +405,6 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
>  	/* SMBus adapter 1 */
>  	res1 = nforce2_probe_smb(dev, 4, NFORCE_PCI_SMB1, &smbuses[0], "SMB1");
>  	if (res1 < 0) {
> -		dev_err(&dev->dev, "Error probing SMB1.\n");
>  		smbuses[0].base = 0;	/* to have a check value */
>  	}
>  	/* SMBus adapter 2 */
> @@ -417,7 +416,6 @@ static int __devinit nforce2_probe(struct pci_dev *dev, const struct pci_device_
>  		res2 = nforce2_probe_smb(dev, 5, NFORCE_PCI_SMB2, &smbuses[1],
>  					 "SMB2");
>  		if (res2 < 0) {
> -			dev_err(&dev->dev, "Error probing SMB2.\n");
>  			smbuses[1].base = 0;	/* to have a check value */
>  		}
>  	}

I agree that these messages are essentially redundant, as
nforce2_probe_smb() never fails without printing an message. Patch
applied, thanks.

-- 
Jean Delvare
