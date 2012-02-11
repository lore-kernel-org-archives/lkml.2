Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2BKL4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 06:56:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:52641 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2BKL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 06:56:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 11 Feb 2012 12:56:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] firewire-sbp2: Ignore SBP-2 targets on the local
 node
Message-ID: <20120211125619.249c6884@stein>
In-Reply-To: <1328881314-26544-3-git-send-email-bootc@bootc.net>
References: <EE1CAC85-DF0C-4C21-B2BD-446C481C938F@bootc.net>
	<1328881314-26544-1-git-send-email-bootc@bootc.net>
	<1328881314-26544-3-git-send-email-bootc@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 10 Chris Boot wrote:
> --- a/drivers/firewire/sbp2.c
> +++ b/drivers/firewire/sbp2.c
> @@ -1138,6 +1138,12 @@ static int sbp2_probe(struct device *dev)
>  	struct Scsi_Host *shost;
>  	u32 model, firmware_revision;
>  
> +	/* ignore targets on the local node */
> +	if (device->node == device->card->local_node) {
> +		dev_set_drvdata(&unit->device, NULL);
> +		return 0;
> +	}

I forgot:  This test can yield false negatives because card->local_node
may change anytime.  Check device->is_local instead.
-- 
Stefan Richter
-=====-===-- --=- -=-==
http://arcgraph.de/sr/
