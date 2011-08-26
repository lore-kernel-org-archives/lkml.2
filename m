Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1HZWst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 18:48:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34473 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1HZWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 18:48:48 -0400
Subject: Re: [PATCH 2/3] broadcast-tick: Move oneshot broadcast mask to per
 cpu variables
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        tim.c.chen@linux.intel.com, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1314397924-10236-2-git-send-email-andi@firstfloor.org>
References: <1314397924-10236-1-git-send-email-andi@firstfloor.org>
	 <1314397924-10236-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Aug 2011 00:48:42 +0200
Message-ID: <1314398922.3036.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 août 2011 à 15:32 -0700, Andi Kleen a écrit :
> From: Andi Kleen <ak@linux.intel.com>
> 
> Avoid a global cache line hotspot in the oneshot cpu mask. Maintain
> this information in per cpu variables instead.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

>  
> -/* FIXME: use cpumask_var_t. */
> -static DECLARE_BITMAP(tick_broadcast_oneshot_mask, NR_CPUS);
> +struct broadcast_cpu_state {
> +	int need_oneshot;
> +} ____cacheline_aligned;
> +static DEFINE_PER_CPU(struct broadcast_cpu_state, state);

static DEFINE_PER_CPU_ALIGNED(...)

It avoids adding an alignment requirement on .data..percpu



