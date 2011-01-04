Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1ADVXm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:23:42 -0500
Received: from mail.solarflare.com ([216.237.3.220]:28965 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1ADVXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:23:40 -0500
Subject: Re: [PATCH 2/2] lib: cpu_rmap: CPU affinity reverse-mapping
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, David Miller <davem@davemloft.net>,
        Tom Herbert <therbert@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-net-drivers@solarflare.com
In-Reply-To: <1294175823.3420.7.camel@edumazet-laptop>
References: <1294169842.3636.31.camel@bwh-desktop>
	 <1294169967.3636.34.camel@bwh-desktop>
	 <1294175823.3420.7.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Tue, 04 Jan 2011 21:23:36 +0000
Message-ID: <1294176216.3636.38.camel@bwh-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 Jan 2011 21:23:40.0239 (UTC) FILETIME=[A815CDF0:01CBAC55]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17872.005
X-TM-AS-Result: No--31.095200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 22:17 +0100, Eric Dumazet wrote:
> Le mardi 04 janvier 2011 à 19:39 +0000, Ben Hutchings a écrit :
> > When initiating I/O on a multiqueue and multi-IRQ device, we may want
> > to select a queue for which the response will be handled on the same
> > or a nearby CPU.  This requires a reverse-map of IRQ affinity.  Add
> > library functions to support a generic reverse-mapping from CPUs to
> > objects with affinity and the specific case where the objects are
> > IRQs.
[...]
> > +/**
> > + * struct cpu_rmap - CPU affinity reverse-map
> > + * @near: For each CPU, the index and distance to the nearest object,
> > + *      based on affinity masks
> > + * @size: Number of objects to be reverse-mapped
> > + * @used: Number of objects added
> > + * @obj: Array of object pointers
> > + */
> > +struct cpu_rmap {
> > +	struct {
> > +		u16     index;
> > +		u16     dist;
> > +	} near[NR_CPUS];
> 
> This [NR_CPUS] is highly suspect.
> 
> Are you sure you cant use a per_cpu allocation here ?

I think that would be a waste of space in shared caches, as this is
read-mostly.

> > +	u16		size, used;
> > +	void		*obj[0];
> > +};
> > +#define CPU_RMAP_DIST_INF 0xffff
> > +
> 
> 
> > +
> > +/**
> > + * alloc_cpu_rmap - allocate CPU affinity reverse-map
> > + * @size: Number of objects to be mapped
> > + * @flags: Allocation flags e.g. %GFP_KERNEL
> > + */
> 
> I really doubt you need other than GFP_KERNEL. (Especially if you switch
> to per_cpu alloc ;) )
[...]

I agree, but this is consistent with ~all other allocation functions.

Ben.


-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

