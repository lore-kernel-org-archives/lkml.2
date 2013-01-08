Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3AHQFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:05:25 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:47811 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3AHQFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:05:24 -0500
Message-ID: <1357661117.2750.1.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Decotigny <decot@googlers.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 8 Jan 2013 16:05:17 +0000
In-Reply-To: <20130103135851.8cc58899.akpm@linux-foundation.org>
References: <cover.1357163124.git.decot@googlers.com>
	 <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
	 <20130102151242.fc6f1bee.akpm@linux-foundation.org>
	 <1357170406.3652.66.camel@bwh-desktop.uk.solarflarecom.com>
	 <20130103135851.8cc58899.akpm@linux-foundation.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19518.000
X-TM-AS-Result: No--25.613400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-03 at 13:58 -0800, Andrew Morton wrote:
> On Wed, 2 Jan 2013 23:46:46 +0000
> Ben Hutchings <bhutchings@solarflare.com> wrote:
[...]
> > >   drivers/net/ethernet/mellanox/mlx4/ appears to be using
> > >   msix_ctl.pool_lock for exclusion, but I didn't check for coverage.
> > >
> > >   drivers/net/ethernet/sfc/efx.c seems to not need locking because
> > >   all its cpu_rmap operations are at module_init() time.
> > >
> > >   The cpu_rmap code would be less of a hand grenade if each of its
> > >   interface functions documented the caller's locking requirements.
> > 
> > This particular 'hand grenade' *was* documented.  So I don't think
> > documentation is the problem.
> 
> Dunno what you're referring to here.  There is no cpu_rmap() locking
> documentation.
[...]

/**
 * free_irq_cpu_rmap - free a CPU affinity reverse-map used for IRQs
 * @rmap: Reverse-map allocated with alloc_irq_cpu_map(), or %NULL
 *
 * Must be called in process context, before freeing the IRQs, and
 * without holding any locks required by global workqueue items.
 */

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

