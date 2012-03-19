Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032234Ab2CSRKG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 13:10:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51080 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030261Ab2CSRKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 13:10:04 -0400
Message-ID: <1332176969.18960.351.camel@twins>
Subject: Re: [RFC][PATCH 10/26] mm, mpol: Make mempolicy home-node aware
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <cl@linux.com>
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
Date: Mon, 19 Mar 2012 18:09:29 +0100
In-Reply-To: <alpine.DEB.2.00.1203191029090.19189@router.home>
References: <20120316144028.036474157@chello.nl>
	 <20120316144240.763518310@chello.nl>
	 <alpine.DEB.2.00.1203161333370.10211@router.home>
	 <1331932375.18960.237.camel@twins>
	 <alpine.DEB.2.00.1203190852380.16879@router.home>
	 <1332165959.18960.340.camel@twins>
	 <alpine.DEB.2.00.1203191012530.17008@router.home>
	 <1332170628.18960.349.camel@twins>
	 <alpine.DEB.2.00.1203191029090.19189@router.home>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 10:31 -0500, Christoph Lameter wrote:

> MPOL_DEFAULT is a certain type of behavior right now that applications
> rely on. If you change that then these applications will no longer work as
> expected.
> 
> MPOL_DEFAULT is currently set to be the default policy on bootup. You can
> change that of course and allow setting MPOL_DEFAULT manually for
> applications that rely on old behavor. Instead set the default behavior on
> bootup for MPOL_HOME_NODE.
> 
> So the default system behavior would be MPOL_HOME_NODE but it could be
> overriding by numactl to allow old apps to run as they are used to run.

Ah, OK. Although that's a mightily confusing usage of the word DEFAULT.
How about instead we make MPOL_LOCAL a real policy and allow explicitly
setting that?
