Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610Ab2CTLH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 07:07:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:58572 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab2CTLH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 07:07:57 -0400
Message-ID: <1332241633.18960.406.camel@twins>
Subject: Re: [RFC][PATCH 00/26] sched/numa
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Avi Kivity <avi@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Tue, 20 Mar 2012 12:07:13 +0100
In-Reply-To: <4F686163.40509@redhat.com>
References: <20120316144028.036474157@chello.nl>
	     <4F670325.7080700@redhat.com> <1332155527.18960.292.camel@twins>
	    <4F671B90.3010209@redhat.com> <1332158992.18960.316.camel@twins>
	   <4F672384.1030601@redhat.com> <1332187387.18960.389.camel@twins>
	  <4F685960.4080904@redhat.com> <1332240525.18960.403.camel@twins>
	 <4F686163.40509@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 12:52 +0200, Avi Kivity wrote:

> You use the dma engine for eager copying, not on demand.

Sure, but during that time no access to that entire vma is allowed, so
you have to unmap it, and any fault in there will have to wait for the
entire copy to complete.

Or am I misunderstanding how things would work?
