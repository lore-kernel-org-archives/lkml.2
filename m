Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab1JSCAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 22:00:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16072 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1JSCAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 22:00:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=m4vh9+xk8NQvDyX78/9VX1/o9HLCyhd59tMhImonRE5RNSkFgyIXmVM6JPpre8cEW
	3drPwPms3QNRKLMnAuMog==
Date: Tue, 18 Oct 2011 18:59:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 1/2] gpio-pch: Use NUMA_NO_NODE not GFP_KERNEL
In-Reply-To: <1318988260-19462-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
Message-ID: <alpine.DEB.2.00.1110181859090.12850@chino.kir.corp.google.com>
References: <1318988260-19462-1-git-send-email-tomoya-linux@dsn.lapis-semi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Tomoya MORINAGA wrote:

> Currently, GFP_KERNEL is used as parameter of irq_alloc_descs like below.
> 
>           irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
>                                      GFP_KERNEL); 
> 
> This is not true.
> So, this patch uses NUMA_NO_NODE not GFP_KERNEL.
> 

Passing NUMA_NO_NODE means the allocation will be preferred on a node that 
is local to the executing processor.

> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>

Acked-by: David Rientjes <rientjes@google.com>
