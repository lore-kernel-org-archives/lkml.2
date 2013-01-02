Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab3ABVyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 16:54:54 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:57709 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab3ABVyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 16:54:51 -0500
Message-ID: <1357163686.3652.46.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@googlers.com>
CC: <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 2 Jan 2013 21:54:46 +0000
In-Reply-To: <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
References: <cover.1357163124.git.decot@googlers.com>
	 <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19504.001
X-TM-AS-Result: No--5.654300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 13:52 -0800, David Decotigny wrote:
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
[...]

Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

