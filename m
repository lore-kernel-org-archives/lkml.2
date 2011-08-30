Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1H3LTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:19:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54751 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1H3LTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:19:38 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
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
Date: Tue, 30 Aug 2011 13:19:18 +0200
In-Reply-To: <20110829233521.GK9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-6-git-send-email-fweisbec@gmail.com>
	 <1314627922.2816.65.camel@twins>
	 <20110829171155.GD9748@somewhere.redhat.com>
	 <1314640155.2816.117.camel@twins>
	 <20110829175954.GF9748@somewhere.redhat.com>
	 <1314641160.2816.128.camel@twins>
	 <20110829233521.GK9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314703158.2799.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 01:35 +0200, Frederic Weisbecker wrote:
> 
> OTOH it is needed to find non-critical sections when asked to cooperate
> in a grace period completion. But if no callback have been enqueued on
> the whole system we are fine. 

Its that 'whole system' clause that I have a problem with. It would be
perfectly fine to have a number of cpus very busy generating rcu
callbacks, however this should not mean our adaptive nohz cpu should be
bothered to complete grace periods.

Requiring it to participate in the grace period state machine is a fail,
plain and simple.
