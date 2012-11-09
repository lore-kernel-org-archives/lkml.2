Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab2KIUOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 15:14:06 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:47706 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754633Ab2KIUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 15:14:01 -0500
Date: Fri, 9 Nov 2012 20:14:00 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: dipankar@in.ibm.com, paulmck@linux.vnet.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <509C68AE.9090009@gmail.com>
Message-ID: <0000013ae6cec263-9b578d79-cf83-4f04-abce-dd0b6e893634-000000@email.amazonses.com>
References: <509C68AE.9090009@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Nov 2012, Shan Wei wrote:

>  	/* Funnel through hierarchy to reduce memory contention. */
> -	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;
> +	rnp = __this_cpu_read(rsp->rda->mynode);
>  	for (; rnp != NULL; rnp = rnp->parent) {

Acked-by: Christoph Lameter <cl@linux.com>

