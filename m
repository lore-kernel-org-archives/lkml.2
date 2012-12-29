Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2L2Ug4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 15:36:56 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:58164 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab2L2Ugx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 15:36:53 -0500
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.39.152
Date: Sat, 29 Dec 2012 12:36:44 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: David Decotigny <decot@googlers.com>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v3] lib: cpu_rmap: avoid flushing all workqueues
Message-ID: <20121229203644.GA31014@leaf>
References: <cover.1356810877.git.decot@googlers.com>
 <796d4768f46d928c68018f44b369df570a0889c4.1356810877.git.decot@googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796d4768f46d928c68018f44b369df570a0889c4.1356810877.git.decot@googlers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 11:57:09AM -0800, David Decotigny wrote:
> In some cases, free_irq_cpu_rmap() is called while holding a lock
> (eg. rtnl). This can lead to deadlocks, because it invokes
> flush_scheduled_work() which ends up waiting for whole system
> workqueue to flush, but some pending works might try to acquire the
> lock we are already holding.
> 
> This commit uses reference-counting to replace
> irq_run_affinity_notifiers(). It also removes
> irq_run_affinity_notifiers() altogether.
> 
> Signed-off-by: David Decotigny <decot@googlers.com>

You might consider adding a cpu_rmap_get to parallel cpu_rmap_put.

Also, why keep free_cpu_rmap around at this point?  As far as I can
tell, it has no callers.

Otherwise, this looks good to me.

- Josh Triplett
