Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935586Ab2JaRj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:39:58 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:31370 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932935Ab2JaRjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:39:55 -0400
Date: Wed, 31 Oct 2012 17:39:54 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: jesse@nicira.com, dev@openvswitch.org, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/9] net: openvswitch: use this_cpu_ptr per-cpu helper
In-Reply-To: <50910A04.5000003@gmail.com>
Message-ID: <0000013ab7e86f8a-4adb8b81-19be-4264-96f1-924aaf3819f2-000000@email.amazonses.com>
References: <50910A04.5000003@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -208,7 +208,7 @@ void ovs_dp_process_received_packet(struct vport *p, struct sk_buff *skb)
>  	int error;
>  	int key_len;
>
> -	stats = per_cpu_ptr(dp->stats_percpu, smp_processor_id());
> +	stats = this_cpu_ptr(dp->stats_percpu);

Well this is an improvement and may be ok if the preemption is disabled at
this point. There is another possibility here to use this_cpu_read/add/inc
instead of determining the pointer to the local cpu first and then
performing operations on the fields. The pointer relocation with
this_cpu_xxx ops is implicit in the instructions and safe against changing
of processors. It would also save us the determination of a pointer to the
current cpus stats structure.

