Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab1H2OqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:46:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:52482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab1H2OqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:46:00 -0400
Subject: Re: [PATCH 08/32] nohz: Move nohz load balancer selection into idle
 logic
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Mon, 29 Aug 2011 16:45:17 +0200
In-Reply-To: <1313423549-27093-9-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-9-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314629117.2816.79.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 17:52 +0200, Frederic Weisbecker wrote:
> We want the nohz load balancer to be an idle CPU, thus
> move that selection to strict dyntick idle logic.

Again, the important part is missing, why is this correct?

I'm not at all convinced this is correct, suppose all your cpus (except
the system CPU, which we'll assume has many tasks) are busy running 1
task. Then two of them get an extra task, now if those two happen to be
SMT siblings you want the load-balancer to pull on task out from the SMT
pair, however nobody is pulling since nobody is idle.

AFAICT this breaks stuff and the ILB needs some serious attention in
order to fix this.
