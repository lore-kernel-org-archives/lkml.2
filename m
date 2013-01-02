Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3ABWFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:05:14 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:52586 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABWFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:05:12 -0500
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Decotigny <decot@googlers.com>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
In-Reply-To: <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
References: <cover.1357163124.git.decot@googlers.com>
	 <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jan 2013 14:05:09 -0800
Message-ID: <1357164309.21409.18464.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
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
> ---

Acked-by: Eric Dumazet <edumazet@google.com>


