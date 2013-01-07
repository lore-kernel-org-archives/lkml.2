Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab3AGNAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 08:00:14 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:42917 "HELO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753961Ab3AGNAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 08:00:12 -0500
Message-ID: <50EAC6DA.1040601@mellanox.com>
Date: Mon, 7 Jan 2013 15:00:10 +0200
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Decotigny <decot@googlers.com>
CC: <linux-kernel@vger.kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Josh Triplett" <josh@joshtriplett.org>,
        David Howells <dhowells@redhat.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v4] lib: cpu_rmap: avoid flushing all workqueues
References: <cover.1357163124.git.decot@googlers.com> <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
In-Reply-To: <bb2493cb7d0b36f35282d77c1f07727601f9c751.1357163124.git.decot@googlers.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.222.66.109]
X-TM-AS-Product-Ver: SMEX-10.0.0.4211-7.000.1014-19514.002
X-TM-AS-Result: No--0.464400-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2013 23:52, David Decotigny wrote:
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
> Signed-off-by: David Decotigny<decot@googlers.com>
> ---
>   include/linux/cpu_rmap.h  |   13 +++-------
>   include/linux/interrupt.h |    5 ----
>   lib/cpu_rmap.c            |   63 +++++++++++++++++++++++++++++++++++++++++----
>   3 files changed, 62 insertions(+), 19 deletions(-)
>

Acked-by: Amir Vadai <amirv@mellano.com>
