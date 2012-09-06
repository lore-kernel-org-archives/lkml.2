Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab2IFSWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:22:16 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42879 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab2IFSWP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:22:15 -0400
Message-ID: <1346955710.18408.58.camel@twins>
Subject: Re: [PATCH RFC tip/core/rcu] Add callback-free CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 20:21:50 +0200
In-Reply-To: <20120906174652.GM2448@linux.vnet.ibm.com>
References: <20120905213945.GA15216@linux.vnet.ibm.com>
	 <1346881720.2600.48.camel@twins> <20120905234443.GY3308@linux.vnet.ibm.com>
	 <1346926417.2600.73.camel@twins> <20120906164745.GF2448@linux.vnet.ibm.com>
	 <1346950736.18408.43.camel@twins>
	 <20120906174652.GM2448@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 10:46 -0700, Paul E. McKenney wrote:
> Getting these
> CPUs into adaptive-tick mode more quickly reduces OS jitter, which is
> one big expected benefit of adaptive-tick mode. 

I'm not sure I agree with that statement. Its a transition thing and
therefore statistically irrelevant on the whole -- assuming we
transition rarely.

And for those who cannot deal with the transition effects, a barrier was
proposed which would wait until the system hit this state -- although
the specific implementation of this isn't clear yet afaik.

I very much think we should focus on getting adaptive tick working as
simple as possible and worry about transition effects later, if at all.
