Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab1GSEwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:52:17 -0400
Received: from mail.perches.com ([173.55.12.10]:4167 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab1GSEwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:52:16 -0400
Subject: Re: [PATCH 1/2 v3] Staging: comedi: fix printk() issue in
 adv_pci1710.c
From: Joe Perches <joe@perches.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
In-Reply-To: <1311051338-9275-1-git-send-email-ravishankarkm32@gmail.com>
References: <[PATCH]Staging: comedi: fix printk() issue in adv_pci1710.c>
	 <1311051338-9275-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jul 2011 21:52:14 -0700
Message-ID: <1311051134.2286.138.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 10:25 +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> This is a patch to the adv_pci1710.c file that fixes up a printk() warning found by the checkpatch.pl tool
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
> KERN_CONT issue is fixed

Nope, still broken, but in a different way.

>  drivers/staging/comedi/drivers/adv_pci1710.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
> index fd71cc6..093b9e6 100644
> --- a/drivers/staging/comedi/drivers/adv_pci1710.c
> +++ b/drivers/staging/comedi/drivers/adv_pci1710.c
> @@ -1396,14 +1396,14 @@ static int pci1710_attach(struct comedi_device *dev,
>  	int i;
>  	int board_index;
>  
> -	printk("comedi%d: adv_pci1710: ", dev->minor);
> +	printk(KERN_CONT "comedi%d: adv_pci1710: ", dev->minor);

This should be KERN_INFO.

_All_ initial printks should have some appropriate KERN_<level>
that is not KERN_CONT (which stands for continuation, btw)
 
>  	opt_bus = it->options[0];
>  	opt_slot = it->options[1];
>  
>  	ret = alloc_private(dev, sizeof(struct pci1710_private));
>  	if (ret < 0) {
> -		printk(" - Allocation failed!\n");
> +		printk(KERN_CONT " - Allocation failed!\n");

This could be:

		printk(KERN_CONT "\n");
		printk(KERN_ERR "Comedi%d: adv_pci1710: Allocation failed\n",
		       dev->minor);


