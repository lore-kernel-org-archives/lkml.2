Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab2IFTJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:09:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:50708 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2IFTJo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:09:44 -0400
Message-ID: <1346958541.18408.67.camel@twins>
Subject: Re: [PATCH tip/core/rcu 06/23] rcu: Break up rcu_gp_kthread() into
 subfunctions
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, patches@linaro.org
Date: Thu, 06 Sep 2012 21:09:01 +0200
In-Reply-To: <20120906184921.GA5738@jtriplet-mobl1>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
	 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1346938791.18408.7.camel@twins> <20120906173207.GK2448@linux.vnet.ibm.com>
	 <20120906184921.GA5738@jtriplet-mobl1>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 11:49 -0700, Josh Triplett wrote:
> 
> Huh, I thought GCC knew to not emit that warning unless it actually
> found control flow reaching the end of the function; since the
> infinite
> loop has no break in it, you shouldn't need the return.  Annoying. 

tag the function with __noreturn
