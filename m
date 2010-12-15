Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0LOVoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:44:10 -0500
Received: from mail.vyatta.com ([76.74.103.46]:35785 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab0LOVoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:44:08 -0500
Date: Wed, 15 Dec 2010 13:44:06 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] msm: rmnet: msm rmnet smd virtual ethernet driver
Message-ID: <20101215134406.3a634aa8@nehalam>
In-Reply-To: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
References: <1292437866-11652-1-git-send-email-nvishwan@codeaurora.org>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 10:31:06 -0800
Niranjana Vishwanathapura <nvishwan@codeaurora.org> wrote:

> +
> +static DECLARE_TASKLET(smd_net_data_tasklet, smd_net_data_handler, 0);
> +
> +static void smd_net_notify(void *_dev, unsigned event)
> +{
> +	if (event != SMD_EVENT_DATA)
> +		return;
> +
> +	smd_net_data_tasklet.data = (unsigned long) _dev;
> +
> +	tasklet_schedule(&smd_net_data_tasklet);
> +}
> +

Rather than having private tasklet, maybe using NAPI
would be better?

Also since you are already in tasklet, no need to call netif_rx()
when receiving packet; instead use netif_receive_skb directly.

-- 
