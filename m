Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030560Ab2HXVCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:02:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030231Ab2HXVCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:02:30 -0400
Date: Fri, 24 Aug 2012 14:02:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>
Subject: Re: [PATCH] rapidio/tsi721: modify mport name assignment
Message-Id: <20120824140229.20e6a46c.akpm@linux-foundation.org>
In-Reply-To: <1345559035-25879-1-git-send-email-alexandre.bounine@idt.com>
References: <1345559035-25879-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012 10:23:54 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Modify mport device name assignment to provide clear reference to devices
> in systems with multiple Tsi721 bridges.
> 
> This patch is applicable to kernel versions starting from v3.2.

This seems to imply that you think the patch should be backported into
earlier kernels.  But no reason for doing this was provided.

> --- a/drivers/rapidio/devices/tsi721.c
> +++ b/drivers/rapidio/devices/tsi721.c
> @@ -2165,7 +2165,8 @@ static int __devinit tsi721_setup_mport(struct tsi721_device *priv)
>  	rio_init_dbell_res(&mport->riores[RIO_DOORBELL_RESOURCE], 0, 0xffff);
>  	rio_init_mbox_res(&mport->riores[RIO_INB_MBOX_RESOURCE], 0, 3);
>  	rio_init_mbox_res(&mport->riores[RIO_OUTB_MBOX_RESOURCE], 0, 3);
> -	strcpy(mport->name, "Tsi721 mport");
> +	snprintf(mport->name, RIO_MAX_MPORT_NAME, "%s(%s)",
> +		 dev_driver_string(&pdev->dev), dev_name(&pdev->dev));

And it's a non-back-compatible change to a userspace-visible interface!
As such we'd need extraordinary justification to merge it into
*future* kernels, let alone backport it.

Please, do provide much better changelogging than this.

