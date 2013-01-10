Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3AJIdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:33:12 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:33096 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3AJIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:33:10 -0500
Date: Thu, 10 Jan 2013 09:32:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: w.sang@pengutronix.de, ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: i2c-nforce2: fix coding style issues
Message-ID: <20130110093255.5353fb31@endymion.delvare>
In-Reply-To: <1357764624-32134-1-git-send-email-laurent.navet@gmail.com>
References: <1357764624-32134-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Thanks for the updated patch.

On Wed,  9 Jan 2013 21:50:24 +0100, Laurent Navet wrote:
> avoid these checkpatch.pl issues :
> - ERROR: "foo * bar" should be "foo *bar"
> - ERROR: switch and case should be at the same indent
> - ERROR: "(foo*)" should be "(foo *)"
> - ERROR: do not use assignment in if condition
> - ERROR: space required before the open parenthesis '('
> - WARNING: suspect code indent for conditional statements
> - WARNING: quoted string split across lines
> - WARNING: space prohibited between function name and open parenthesis '('

Unfortunately your patch also add one new checkpatch.pl warning:

WARNING: line over 80 characters
#245: FILE: drivers/i2c/busses/i2c-nforce2.c:272:
+		data->word = inb_p(NVIDIA_SMB_DATA) | (inb_p(NVIDIA_SMB_DATA + 1) << 8);

Please fix.

> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/i2c/busses/i2c-nforce2.c |  153 +++++++++++++++++++-------------------
>  1 file changed, 76 insertions(+), 77 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-nforce2.c b/drivers/i2c/busses/i2c-nforce2.c
> index 392303b..90357a2 100644
> --- a/drivers/i2c/busses/i2c-nforce2.c
> +++ b/drivers/i2c/busses/i2c-nforce2.c
> (...)
> @@ -327,10 +324,10 @@ static DEFINE_PCI_DEVICE_TABLE(nforce2_ids) = {
>  	{ 0 }
>  };
>  
> -MODULE_DEVICE_TABLE (pci, nforce2_ids);
> +MODULE_DEVICE_TABLE(pci, nforce2_ids);
>  
>  
> -static int __devinit nforce2_probe_smb (struct pci_dev *dev, int bar,
> +static int __devinit nforce2_probe_smb(struct pci_dev *dev, int bar,
>  	int alt_reg, struct nforce2_smbus *smbus, const char *name)
>  {
>  	int error;

As mentioned previously, __devinit has been dropped meanwhile, so this
change doesn't apply cleanly. Please rebase your patch on top of kernel
3.8-rc3 (or Wolfram's i2c tree) so that Wolfram can apply it.

All the rest looks very good now, thanks for the good work.

-- 
Jean Delvare
