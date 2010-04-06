Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab0DFNtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 09:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab0DFNtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 09:49:36 -0400
Message-ID: <4BBB3BB1.4070501@redhat.com>
Date: Tue, 06 Apr 2010 09:48:33 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: yinghai@kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: REPOST cleanup debug message in init_kstat_irqs()
References: <20100406134001.22289.47490.sendpatchset@prarit.bos.redhat.com>
In-Reply-To: <20100406134001.22289.47490.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops... Subject should have been REPOST cleanup debug message in 
irq_to_desc_alloc_node()

Sorry 'bout that.

P.

Prarit Bhargava wrote:
> [Sending to a wider audience this time, cc'ing Andrew and Ingo directly]
>
> Clean up debug messages in irq_to_desc_alloc_node().
>
> This debug message can result in valid output like
>
> 	alloc irq_desc for 73 on node -1
>
> which looks like alot like an error message.
>
> This debug statement has been in the kernel for about a year, so I think it is
> safe to remove it and report the irq and node in the error case instead.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 17c71bb..5c3e38e 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -224,9 +224,10 @@ struct irq_desc * __ref irq_to_desc_alloc_node(unsigned int irq, int node)
>  	else
>  		desc = alloc_bootmem_node(NODE_DATA(node), sizeof(*desc));
>  
> -	printk(KERN_DEBUG "  alloc irq_desc for %d on node %d\n", irq, node);
>  	if (!desc) {
> -		printk(KERN_ERR "can not alloc irq_desc\n");
> +		printk(KERN_ERR
> +		       "can not alloc irq_desc for irq %d on node %d\n",
> +		       irq, node);
>  		BUG_ON(1);
>  	}
>  	init_one_irq_desc(irq, desc, node);
>   
