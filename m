Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1FHXYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 19:24:37 -0400
Received: from blu0-omc1-s14.blu0.hotmail.com ([65.55.116.25]:32349 "EHLO
	blu0-omc1-s14.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755011Ab1FHXYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 19:24:36 -0400
X-Originating-IP: [184.145.208.36]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP12157D840AA45B618A39A096620@phx.gbl>
Date: Wed, 8 Jun 2011 19:19:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 10/28] rcu: Fix RCU's NMI documentation
References: <20110608192943.GA13211@linux.vnet.ibm.com> <1307561407-13809-10-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1307561407-13809-10-git-send-email-paulmck@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 19:18:39 up 427 days,  9:08,  5 users,  load average: 0.38, 0.24,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 08 Jun 2011 23:19:03.0538 (UTC) FILETIME=[74B8A520:01CC2632]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> It has long been the case that the architecture must call nmi_enter()
> and nmi_exit() rather than irq_enter() and irq_exit() in order to
> permit RCU read-side critical sections in NMIs.  Catch the documentation
> up with reality.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> ---
>  Documentation/RCU/NMI-RCU.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
> index a8536cb..84e4f9c 100644
> --- a/Documentation/RCU/NMI-RCU.txt
> +++ b/Documentation/RCU/NMI-RCU.txt
> @@ -95,7 +95,7 @@ not to return until all ongoing NMI handlers exit.  It is therefore safe
>  to free up the handler's data as soon as synchronize_sched() returns.
>  
>  Important note: for this to work, the architecture in question must
> -invoke irq_enter() and irq_exit() on NMI entry and exit, respectively.
> +invoke nmi_enter() and nmi_exit() on NMI entry and exit, respectively.
>  
>  
>  Answer to Quick Quiz
> -- 
> 1.7.3.2
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
