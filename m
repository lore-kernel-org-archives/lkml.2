Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab1GZGlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 02:41:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47896 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1GZGlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 02:41:35 -0400
Message-ID: <4E2E6199.5010409@gmail.com>
Date: Tue, 26 Jul 2011 16:41:29 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ravishankar <ravishankarkm32@gmail.com>
CC: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/1 v2] Staging: comedi: fix printk issue in c6xdigio.c
References: <[PATCH]Staging: comedi: fix printk issue in c6xdigio.c> <1311662734-22064-1-git-send-email-ravishankarkm32@gmail.com>
In-Reply-To: <1311662734-22064-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/11 16:45, Ravishankar wrote:
> From: Ravishankar<ravi.shankar@greenturtles.in>
>
> This is a patch to the c6xdigio.c file that fixes up a printk warning found by the checkpatch.pl tool
>
> Signed-off-by: Ravishankr<ravishankarkm32@gmail.com>
> ---
>
>   drivers/staging/comedi/drivers/c6xdigio.c |   12 ++++++------
>   1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
> index e0ac825..b0b578c 100644
> --- a/drivers/staging/comedi/drivers/c6xdigio.c
> +++ b/drivers/staging/comedi/drivers/c6xdigio.c
> @@ -343,7 +343,7 @@ static int c6xdigio_pwmo_insn_read(struct comedi_device *dev,
>   				   struct comedi_subdevice *s,
>   				   struct comedi_insn *insn, unsigned int *data)
>   {
> -	printk("c6xdigio_pwmo_insn_read %x\n", insn->n);
> +	pr_info("%s %x\n", __func__, insn->n);
>   	return insn->n;
>   }
>
> @@ -439,9 +439,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
>   	struct comedi_subdevice *s;
>
>   	iobase = it->options[0];
> -	printk("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
> +	pr_info("comedi%d: c6xdigio: 0x%04lx\n", dev->minor, iobase);
>   	if (!request_region(iobase, C6XDIGIO_SIZE, "c6xdigio")) {
> -		printk("comedi%d: I/O port conflict\n", dev->minor);
> +		pr_err("comedi%d: I/O port conflict\n", dev->minor);
>   		return -EIO;
>   	}
>   	dev->iobase = iobase;
> @@ -456,9 +456,9 @@ static int c6xdigio_attach(struct comedi_device *dev,
>
>   	irq = it->options[1];
>   	if (irq>  0)
> -		printk("comedi%d: irq = %u ignored\n", dev->minor, irq);
> +		pr_debug("%s: %x\n", __func__, insn->n);
>   	else if (irq == 0)
> -		printk("comedi%d: no irq\n", dev->minor);
> +		pr_debug("%s: %x\n", __func__, insn->n);

You are doing this without any thought at all. Not only does this 
replace a useful message with a completely useless one, but it also 
won't even compile if DEBUG is defined. It is not confidence inspiring.

~Ryan

