Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab1GSDzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 23:55:24 -0400
Received: from mail.perches.com ([173.55.12.10]:4160 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1GSDzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 23:55:24 -0400
Subject: Re: [PATCH 1/2 v2] Staging: comedi: fix printk() issue in
 adv_pci1710.c
From: Joe Perches <joe@perches.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
In-Reply-To: <1311047521-4113-1-git-send-email-ravishankarkm32@gmail.com>
References: <[PATCH]Staging: comedi: fix printk() issue in adv_pci1710.c>
	 <1311047521-4113-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 20:55:21 -0700
Message-ID: <1311047721.2286.134.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 09:22 +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> This is a patch to the adv_pci1710.c file that fixes up a printk() warning found by the checkpatch.pl tool
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  KERN_INFO is replaced by KERN_ERR.
>  drivers/staging/comedi/drivers/adv_pci1710.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
> index fd71cc6..093b9e6 100644
> --- a/drivers/staging/comedi/drivers/adv_pci1710.c
> +++ b/drivers/staging/comedi/drivers/adv_pci1710.c
> @@ -1396,14 +1396,14 @@ static int pci1710_attach(struct comedi_device *dev,\
[]
> -	printk("comedi%d: adv_pci1710: ", dev->minor);
> +	printk(KERN_INFO "comedi%d: adv_pci1710: ", dev->minor);
[]
>  	if (ret < 0) {
> -		printk(" - Allocation failed!\n");
> +		printk(KERN_ERR " - Allocation failed!\n");
>  		return -ENOMEM;
>  	}

Ravi, (may I call you Ravi?)
you've done this several times now.

Please understand that a printk without a "\n" termination
can be continued by subsequent printks.

When that happens, you should use printk(KERN_CONT... or
pr_cont(... to continue the previous message, not give a
new error level to the continuation.

cheers, Joe


