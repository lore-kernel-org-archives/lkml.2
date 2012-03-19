Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030473Ab2CSNyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:54:06 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25956 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754090Ab2CSNyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:54:04 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IbGsImMVM1lfEkDimj.2BnXR1mH9oiPl1XBtbiV1lALYFlj
 uKbrB7ZViKxil4vLnD4Z2IsmBkG3cmQsNlOz1zL7npEFW7hShdy_IidX78hZ
 jvEGCgf4y32PJuvF3YjwBPce8JUJXWSeTIEbjfwt3K5wGBpKo4ZIaG_XBoF.
 dzWF9z2cfQsl65mnWYErMLgRc6q4.8KlzjVmQatKWmjfpF5zoOWSGhREnJml
 Ni4fqb2g1fgAoByYuoetSs8Dy4k4eZwbJSVFuxKseoi2dCuHmmDryGB8buBE
 7AZRgx9NCJNZABmTjaQfijAfih0wglnTSpxGzna6G0f6M2GHj56cAoieu_x6
 gioRh6n0TUMBR0ld1XVuOZziz7GKl1f.sQ93xMES.g7yoS4i3QN8DN2jLuJt
 A08S_X3fR6.nGp4sgdH.Kw80UPN2nQzCI7yvS
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 08:53:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [RFC][PATCH 10/26] mm, mpol: Make mempolicy home-node aware
In-Reply-To: <1331932375.18960.237.camel@twins>
Message-ID: <alpine.DEB.2.00.1203190852380.16879@router.home>
References: <20120316144028.036474157@chello.nl> <20120316144240.763518310@chello.nl> <alpine.DEB.2.00.1203161333370.10211@router.home> <1331932375.18960.237.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Peter Zijlstra wrote:

> > > Note that the tsk_home_node() policy has Migrate-on-Fault enabled to
> > > facilitate efficient on-demand memory migration.
> >
> > The numa hierachy is already complex. Could we avoid adding another layer
> > by adding a MPOL_HOME_NODE and make that the default?
>
> Not sure that's really a win, the behaviour would be the same we just
> have to implement another policy, which is likely more code.

A HOME_NODE policy would also help to ensure that existing applications
continue to work as expected. Given that people in the HPC industry and
elsewhere have been fine tuning around the scheduler for years this is a
desirable goal and ensures backward compatibility.


