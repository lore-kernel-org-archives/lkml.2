Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab0KOGmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:42:35 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:54373 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab0KOGmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:42:31 -0500
Date: Mon, 15 Nov 2010 15:41:59 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [v2,2/8] NUMA Hotplug emulator
Message-ID: <20101115064159.GF8489@linux-sh.org>
References: <20101113061445.GL32501@shaohui>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113061445.GL32501@shaohui>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 02:14:45PM +0800, Shaohui Zheng wrote:
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index dba35e4..ba0f82d 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -371,6 +371,10 @@ static inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *origp,
>   */
>  enum node_states {
>  	N_POSSIBLE,		/* The node could become online at some point */
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +	N_HIDDEN,		/* The node is hidden at booting time, could be
> +				 * onlined in run time */
> +#endif
>  	N_ONLINE,		/* The node is online */
>  	N_NORMAL_MEMORY,	/* The node has regular memory */
>  #ifdef CONFIG_HIGHMEM
> @@ -470,6 +474,13 @@ static inline int num_node_state(enum node_states state)
>  #define node_online(node)	node_state((node), N_ONLINE)
>  #define node_possible(node)	node_state((node), N_POSSIBLE)
>  
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +#define node_set_hidden(node)	   node_set_state((node), N_HIDDEN)
> +#define node_clear_hidden(node)	   node_clear_state((node), N_HIDDEN)
> +#define node_hidden(node)	node_state((node), N_HIDDEN)
> +extern int hotadd_hidden_nodes(int nid);
> +#endif
> +
>  #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
>  #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
>  
None of these really need to be under ifdef. Secondly, the description
you have provided is pretty ambiguous in comparison to N_POSSIBLE. Is
there some reason you can't just use N_POSSIBLE for this instead?
