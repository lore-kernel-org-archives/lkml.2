Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3ABUdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 15:33:15 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:28915 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3ABUdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 15:33:13 -0500
Message-ID: <1357158788.3652.45.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v2] lib: cpu_rmap: avoid flushing all workqueues
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Decotigny <decot@googlers.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 2 Jan 2013 20:33:08 +0000
In-Reply-To: <1356729284.21409.889.camel@edumazet-glaptop>
References: <cover.1356721114.git.decot@googlers.com>
	 <d1d3f42dff1837cd43e67f954c51eb9d1f91b4ba.1356721114.git.decot@googlers.com>
	 <1356729284.21409.889.camel@edumazet-glaptop>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19504.001
X-TM-AS-Result: No--21.548700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-28 at 13:14 -0800, Eric Dumazet wrote:
[...]
> > +/**
> > + * reclaim_cpu_rmap - internal reclaiming helper called from kref_put
> > + * @ref: kref to struct cpu_rmap
> > + */
> > +static void reclaim_cpu_rmap(struct kref *ref)
> 
> Could be named cpu_rmap_free()
> 
> (and alloc_cpu_rmap() should be renamed as cpu_rmap_alloc()
[...]

There are many other APIs that include alloc_foo() and free_foo().  I'm
not aware of any convention that this should be avoided in new APIs (not
that this is new any more).

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

