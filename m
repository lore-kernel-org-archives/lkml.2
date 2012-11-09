Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab2KIUIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:08:47 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:43617 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454Ab2KIUIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:08:44 -0500
Date: Fri, 9 Nov 2012 20:08:42 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: David Miller <davem@davemloft.net>, timo.teras@iki.fi,
        steffen.klassert@secunet.com, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/9] net: core: use this_cpu_ptr per-cpu helper
In-Reply-To: <509C686F.20400@gmail.com>
Message-ID: <0000013ae6c9e81a-eabe295b-72a5-4ebd-85c5-231bec1a70c5-000000@email.amazonses.com>
References: <509C686F.20400@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Shan Wei wrote:

> diff --git a/net/core/flow.c b/net/core/flow.c
> index e318c7e..b0901ee 100644
> --- a/net/core/flow.c
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
> +	tasklet = this_cpu_ptr(&info->cache->percpu->flush_tasklet);
>  	tasklet->data = (unsigned long)info;

this_cpu_write(info->cache->percpu->flush_tasklet->data, (unsigned
	long)info);

should also do the trick in less instructions and get rid of all temporary
variables as well.


