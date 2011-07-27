Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1G0VrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:47:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab1G0VrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:47:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=XlsMu96FmRbc/DGzuGhb7IoKB4DdPArMf6uqUKIOnPL+/1BjKrD+tjpRfQlaPgtrT
	Xnx2hon0Cc1xKuJgEVrrA==
Date: Wed, 27 Jul 2011 14:47:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: James.Bottomley@hansenpartnership.com, penberg@kernel.org,
        James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] [12/98] slub: fix panic with DISCONTIGMEM
In-Reply-To: <20110727003504.30F242403FF@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.00.1107271444040.13279@chino.kir.corp.google.com>
References: <20110726534.972201586@firstfloor.org> <20110727003504.30F242403FF@tassilo.jf.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011, Andi Kleen wrote:

> Index: linux-2.6.35.y/init/Kconfig
> ===================================================================
> --- linux-2.6.35.y.orig/init/Kconfig
> +++ linux-2.6.35.y/init/Kconfig
> @@ -1087,6 +1087,7 @@ config SLAB
>  	  per cpu and per node queues.
>  
>  config SLUB
> +	depends on BROKEN || NUMA || !DISCONTIGMEM
>  	bool "SLUB (Unqueued Allocator)"
>  	help
>  	   SLUB is a slab allocator that minimizes cache line usage
> 

NACK, this got reverted by 21a43e397e7f ("slub: Revert '[PARISC] slub: fix 
panic with DISCONTIGMEM'").  Merging d9b41e0b54fd ("[PARISC] set memory 
ranges in N_NORMAL_MEMORY when onlined") does not require this change.
