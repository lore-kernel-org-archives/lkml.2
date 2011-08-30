Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1H3Mol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 08:44:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52321 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab1H3Moj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:44:39 -0400
Subject: Re: [PATCH 13/32] nohz: Adaptive tick stop and restart on nohz
 cpuset
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Date: Tue, 30 Aug 2011 14:44:10 +0200
In-Reply-To: <20110829182836.GI9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-14-git-send-email-fweisbec@gmail.com>
	 <1314631689.2816.91.camel@twins>
	 <20110829180222.GG9748@somewhere.redhat.com>
	 <1314641230.2816.129.camel@twins>
	 <20110829182836.GI9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314708250.5812.0.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 20:28 +0200, Frederic Weisbecker wrote:
> tick_nohz_stop_sched_tick() checks that
> with {rcu,printk,arch}_needs_cpu() and restores a periodic behaviour
> until nobody else needs the CPU. 

tick_nohz_stop_sched_tick() should not restore stuff, it should at worst
fail to stop but never enable that's just weird.
