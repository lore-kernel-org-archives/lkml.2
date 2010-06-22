Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab0FVJgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:36:24 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:53480 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754366Ab0FVJgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:36:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABshIEzCTtAn/2dsb2JhbACfEnHAXYUbBA
Date: Tue, 22 Jun 2010 11:36:18 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] firewire: core: no need to track irq flags in
	bm_work
Message-ID: <20100622093618.GC26304@frolo.macqel>
References: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tkrat.96072b90a5c06bb3@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:23:52PM +0200, Stefan Richter wrote:
> This is a workqueue job and always entered with IRQs enabled.

did you mean 'disabled' ?

Philippe

> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> ---
>  drivers/firewire/core-card.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> Index: b/drivers/firewire/core-card.c
> ===================================================================
> --- a/drivers/firewire/core-card.c
> +++ b/drivers/firewire/core-card.c
> @@ -239,7 +239,6 @@ static void fw_card_bm_work(struct work_
>  	struct fw_card *card = container_of(work, struct fw_card, work.work);
>  	struct fw_device *root_device, *irm_device;
>  	struct fw_node *root_node;
> -	unsigned long flags;
>  	int root_id, new_root_id, irm_id, local_id;
>  	int gap_count, generation, grace, rcode;
>  	bool do_reset = false;
> @@ -247,10 +246,10 @@ static void fw_card_bm_work(struct work_
>  	bool root_device_is_cmc;
>  	bool irm_is_1394_1995_only;
>  
> -	spin_lock_irqsave(&card->lock, flags);
> +	spin_lock_irq(&card->lock);

