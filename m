Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2C0Qr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:47:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:54052 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2C0Qr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:47:27 -0400
Message-ID: <1332866823.16159.246.camel@twins>
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>,
        Dimitri Sivanich <sivanich@sgi.com>
Date: Tue, 27 Mar 2012 18:47:03 +0200
In-Reply-To: <alpine.DEB.2.00.1203271106130.1170@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <1332338318-5958-10-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1203210950500.20482@router.home>
	 <20120327105034.GA13196@somewhere>
	 <alpine.DEB.2.00.1203271106130.1170@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 11:08 -0500, Christoph Lameter wrote:
> 
> I wish you would disentangle the nohz work from the cpusets. Cpusets is
> aged and being replaced by cgroups. And the cgroup work is something that
> is not suitable for many loads given the VM overhead added. 

What VM overhead? Are you talking about the memcg nonsense? That's
entirely optional, you don't need to either build that or enable it.

And if we ever get rid of that multiple hierarchy nonsense I don't see a
reason to get rid of cpuset at all. The only reason to want to replace
it is to avoid the dis-joint-ness it has with the cpu controller (and
possible the memcg one).


