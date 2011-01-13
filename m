Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1AMK53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:57:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51620 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756310Ab1AMK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:57:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hc2B5eYNHHrBxEQjdfNFaRbr700137zKdlyZThyDw6huy4D7YlAE+3kv7ceyzq6+LT
         6WwoXTO0JX/kmqPaeqsoqklaHG2+sOS4KZgoo+/PGBF+WCFq1ujc2RR4R/Q9ElQS9k00
         gYpeEhHbGqltPhYU9uWIz8LWAMH5kT9Eakh/4=
Date: Thu, 13 Jan 2011 11:57:17 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 05/16] x86: Always use x86_cpu_to_logical_apicid for
 cpu -> logical apic id
Message-ID: <20110113105717.GB30719@htj.dyndns.org>
References: <1293731369-10851-1-git-send-email-tj@kernel.org>
 <1293731369-10851-6-git-send-email-tj@kernel.org>
 <alpine.DEB.2.00.1101121831001.8631@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101121831001.8631@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 06:40:09PM -0800, David Rientjes wrote:
> On Thu, 30 Dec 2010, Tejun Heo wrote:
> 
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index ba78b1e..8ad231c 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -1252,6 +1252,14 @@ void __cpuinit setup_local_APIC(void)
> >  	 */
> >  	apic->init_apic_ldr();
> >  
> > +#ifdef CONFIG_X86_32
> > +	/*
> > +	 * APIC LDR is initialized.  Fetch and store logical_apic_id.
> > +	 */
> > +	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
> > +		logical_smp_processor_id();
> > +#endif
> > +
> >  	/*
> >  	 * Set Task Priority to 'accept all'. We never change this
> >  	 * later on.
> 
> You can remove the initialization of x86_cpu_to_logical_apicid in the 
> ->init_apic_ldr() callback in x2apic_cluster.c now too?

Believe it or not, that's a different variable.  And yeah we probably
should clean that up too.

Thanks.

-- 
tejun
