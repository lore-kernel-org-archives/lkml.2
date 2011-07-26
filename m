Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1GZF1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 01:27:20 -0400
Received: from mail.perches.com ([173.55.12.10]:4279 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab1GZF1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 01:27:15 -0400
Subject: Re: [PATCH 1/1] Staging: comedi: fix printk issue in c6xdigio.c
From: Joe Perches <joe@perches.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
In-Reply-To: <1311658020-16057-1-git-send-email-ravishankarkm32@gmail.com>
References: <[PATCH]Staging: comedi: fix printk issue in c6xdigio.c>
	 <1311658020-16057-1-git-send-email-ravishankarkm32@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 22:27:14 -0700
Message-ID: <1311658034.26957.3.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-26 at 10:57 +0530, Ravishankar wrote:
> This is a patch to the c6xdigio.c file that fixes up a printk warning found by the checkpatch.pl tool
> diff --git a/drivers/staging/comedi/drivers/c6xdigio.c b/drivers/staging/comedi/drivers/c6xdigio.c
[]
> @@ -343,7 +343,7 @@ static int c6xdigio_pwmo_insn_read(struct comedi_device *dev,
[]
> -	printk("c6xdigio_pwmo_insn_read %x\n", insn->n);
> +	pr_info("c6xdigio_pwmo_insn_read %x\n", insn->n);

It would be good if you would convert embedded function names
to "%s", __func__.  Maybe convert the bare printks to appropriate
levels as well.  Perhaps:

	pr_debug("%s: %x\n", __func__, insn->n);


