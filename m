Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954Ab2JaRb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:31:57 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:22892 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753278Ab2JaRby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:31:54 -0400
Date: Wed, 31 Oct 2012 17:31:52 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: David Miller <davem@davemloft.net>, timo.teras@iki.fi,
        steffen.klassert@secunet.com, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] net: core: use this_cpu_ptr per-cpu helper
In-Reply-To: <509109E1.6040607@gmail.com>
Message-ID: <0000013ab7e116c8-fac51ac3-c4a4-46b8-9d55-fb4df4019e30-000000@email.amazonses.com>
References: <509109E1.6040607@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> +++ b/net/core/flow.c
> @@ -327,11 +327,9 @@ static void flow_cache_flush_tasklet(unsigned long data)
>  static void flow_cache_flush_per_cpu(void *data)
>  {
>  	struct flow_flush_info *info = data;
> -	int cpu;
>  	struct tasklet_struct *tasklet;
>
> -	cpu = smp_processor_id();
> -	tasklet = &per_cpu_ptr(info->cache->percpu, cpu)->flush_tasklet;
> +	tasklet = &this_cpu_ptr(info->cache->percpu)->flush_tasklet;
>  	tasklet->data = (unsigned long)info;
>  	tasklet_schedule(tasklet);
>  }
>

Reviewed-by: Christoph Lameter <cl@linux.com>

