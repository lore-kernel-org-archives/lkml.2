Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab2KBRq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:46:59 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:7112 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933369Ab2KBRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:46:50 -0400
Date: Fri, 2 Nov 2012 17:46:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <5093EE6B.3070906@gmail.com>
Message-ID: <0000013ac23b7ba3-d0a82d30-2929-4cd1-bdca-1b008ee9bd3d-000000@email.amazonses.com>
References: <5093EE6B.3070906@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012, Shan Wei wrote:

>
>  	/* Funnel through hierarchy to reduce memory contention. */
> -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> +	rnp = __this_cpu_read(rsp->rda->mynode);
>  	for (; rnp != NULL; rnp = rnp->parent) {

Reviewed-by: Christoph Lameter <cl@linux.com>

