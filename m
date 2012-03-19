Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162343Ab2CSU3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:29:40 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:40822 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033006Ab2CSU3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:29:36 -0400
Message-ID: <1332188909.143015.46.camel@zaphod.localdomain>
Subject: Re: [RFC][PATCH 10/26] mm, mpol: Make mempolicy home-node aware
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Mon, 19 Mar 2012 16:28:29 -0400
In-Reply-To: <1332176969.18960.351.camel@twins>
References: <20120316144028.036474157@chello.nl>
	 <20120316144240.763518310@chello.nl>
	 <alpine.DEB.2.00.1203161333370.10211@router.home>
	 <1331932375.18960.237.camel@twins>
	 <alpine.DEB.2.00.1203190852380.16879@router.home>
	 <1332165959.18960.340.camel@twins>
	 <alpine.DEB.2.00.1203191012530.17008@router.home>
	 <1332170628.18960.349.camel@twins>
	 <alpine.DEB.2.00.1203191029090.19189@router.home>
	 <1332176969.18960.351.camel@twins>
Organization: HP/LKTT
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 18:09 +0100, Peter Zijlstra wrote:
> On Mon, 2012-03-19 at 10:31 -0500, Christoph Lameter wrote:
> 
> > MPOL_DEFAULT is a certain type of behavior right now that applications
> > rely on. If you change that then these applications will no longer work as
> > expected.
> > 
> > MPOL_DEFAULT is currently set to be the default policy on bootup. You can
> > change that of course and allow setting MPOL_DEFAULT manually for
> > applications that rely on old behavor. Instead set the default behavior on
> > bootup for MPOL_HOME_NODE.
> > 
> > So the default system behavior would be MPOL_HOME_NODE but it could be
> > overriding by numactl to allow old apps to run as they are used to run.
> 
> Ah, OK. Although that's a mightily confusing usage of the word DEFAULT.
> How about instead we make MPOL_LOCAL a real policy and allow explicitly
> setting that?
> 

Maybe less confusing if you don't think of MPOL_DEFAULT as a real
mempolicy.  As the value of the mode parameter to mbind(2) and
internally, it indicates that "default behavior" is requested or being
used.   It's not stored in the mode member of a mempolicy structure like
MPOL_BIND and others.  Nor is it used in the page allocation path.  The
actual implementation is the absence of a non-default mempolicy -- i.e.,
a NULL task or vma/shared policy pointer.

Because default behavior for task policy is local allocation,
MPOL_DEFAULT does sometimes get confused with local allocation. The
NOTES section and the description of MPOL_DEFAULT in the mbind(2) man
page attempt to clarify this.




