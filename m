Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab1FFSbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:31:47 -0400
Received: from mail.perches.com ([173.55.12.10]:2536 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab1FFSbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:31:46 -0400
Subject: Re: [PATCH v2 7/7] staging: et131x: Removing '_t' from ce_stats_t
 struct
From: Joe Perches <joe@perches.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, o.hartmann@telovital.com
In-Reply-To: <1307383624-8740-8-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
	 <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
	 <1307383624-8740-8-git-send-email-mark.einon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 11:31:45 -0700
Message-ID: <1307385105.4994.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 19:07 +0100, Mark Einon wrote:
> Removing '_t' from ce_stats_t struct name and renaming et131x_adapter ce_stats member from
>  'Stats' to 'stats'
[]
> diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
[]
> @@ -452,7 +452,7 @@ void ConfigFlowControl(struct et131x_adapter *etdev)
>   */
>  void UpdateMacStatHostCounters(struct et131x_adapter *etdev)
>  {
> -	struct ce_stats_t *stats = &etdev->Stats;
> +	struct ce_stats *stats = &etdev->stats;
>  	struct macstat_regs __iomem *macstat =
>  		&etdev->regs->macstat;
>  
> @@ -503,33 +503,33 @@ void HandleMacStatInterrupt(struct et131x_adapter *etdev)

Might as well copy from UpdateMacStatHostCounters and add

	struct ce_stats *stats = &etdev->stats;

>  	 * block indicates that one of the counters has wrapped.
>  	 */
>  	if (Carry1 & (1 << 14))
> -		etdev->Stats.code_violations += COUNTER_WRAP_16_BIT;
> +		etdev->stats.code_violations += COUNTER_WRAP_16_BIT;

and change these to
		stats->foo += bar...

>  	if (Carry1 & (1 << 8))
> -		etdev->Stats.alignment_err += COUNTER_WRAP_12_BIT;
> +		etdev->stats.alignment_err += COUNTER_WRAP_12_BIT;
>  	if (Carry1 & (1 << 7))
> -		etdev->Stats.length_err += COUNTER_WRAP_16_BIT;
> +		etdev->stats.length_err += COUNTER_WRAP_16_BIT;
>  	if (Carry1 & (1 << 2))
> -		etdev->Stats.other_errors += COUNTER_WRAP_16_BIT;
> +		etdev->stats.other_errors += COUNTER_WRAP_16_BIT;
>  	if (Carry1 & (1 << 6))
> -		etdev->Stats.crc_err += COUNTER_WRAP_16_BIT;
> +		etdev->stats.crc_err += COUNTER_WRAP_16_BIT;
>  	if (Carry1 & (1 << 3))
> -		etdev->Stats.rx_ov_flow += COUNTER_WRAP_16_BIT;
> +		etdev->stats.rx_ov_flow += COUNTER_WRAP_16_BIT;
>  	if (Carry1 & (1 << 0))
> -		etdev->Stats.norcvbuf += COUNTER_WRAP_16_BIT;
> +		etdev->stats.norcvbuf += COUNTER_WRAP_16_BIT;
>  	if (Carry2 & (1 << 16))
> -		etdev->Stats.max_pkt_error += COUNTER_WRAP_12_BIT;
> +		etdev->stats.max_pkt_error += COUNTER_WRAP_12_BIT;
>  	if (Carry2 & (1 << 15))
> -		etdev->Stats.tx_uflo += COUNTER_WRAP_12_BIT;
> +		etdev->stats.tx_uflo += COUNTER_WRAP_12_BIT;
>  	if (Carry2 & (1 << 6))
> -		etdev->Stats.first_collision += COUNTER_WRAP_12_BIT;
> +		etdev->stats.first_collision += COUNTER_WRAP_12_BIT;
>  	if (Carry2 & (1 << 8))
> -		etdev->Stats.tx_deferred += COUNTER_WRAP_12_BIT;
> +		etdev->stats.tx_deferred += COUNTER_WRAP_12_BIT;
>  	if (Carry2 & (1 << 5))
> -		etdev->Stats.excessive_collisions += COUNTER_WRAP_12_BIT;
> +		etdev->stats.excessive_collisions += COUNTER_WRAP_12_BIT;
>  	if (Carry2 & (1 << 4))
> -		etdev->Stats.late_collisions += COUNTER_WRAP_12_BIT;
> +		etdev->stats.late_collisions += COUNTER_WRAP_12_BIT;
>  	if (Carry2 & (1 << 2))
> -		etdev->Stats.collisions += COUNTER_WRAP_12_BIT;
> +		etdev->stats.collisions += COUNTER_WRAP_12_BIT;
>  }


