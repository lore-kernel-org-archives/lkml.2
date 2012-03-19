Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2CSPby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:31:54 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:28332 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759093Ab2CSPbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:31:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bQMsEaAVM1lnnJyY8_FpmstvxYXL1tr7I_p6wKrgmKcb.Cf
 mPP6TFVH7F6CJH0gKUKdqJQw6LSjIHwXzm81l3JdE8KAc.hPffQFoOFEzkHg
 4g5J.UB84iaq6uEyAKueDtIrSKKOOaKCf.nmavHWoet8Dad513IJeE12DpuC
 6V7RNqYbUMFf.G7uL5NrB5cZ63xfK0BLNXN.4WuJ.n70VyFRL0Tvx75EOcov
 h_2A2Y1L8IVnDIB6BqM3q9mpxgRy8vja0HtD7MMbesRtfvG7MaQlDGIdAguq
 gRY0CMKyx0m1PKYMtv3sYtY.wJ1xpAeRzALVaiXQ8_b36tF6qsAJgDBtV8MA
 pwMNDPxDQnuga2wpkPaCSUAFTSH4_6T.K8iFW3w9BkL5QYtZLZHSg62k9JC4
 N
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 19 Mar 2012 10:31:47 -0500 (CDT)
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
In-Reply-To: <1332170628.18960.349.camel@twins>
Message-ID: <alpine.DEB.2.00.1203191029090.19189@router.home>
References: <20120316144028.036474157@chello.nl> <20120316144240.763518310@chello.nl> <alpine.DEB.2.00.1203161333370.10211@router.home> <1331932375.18960.237.camel@twins> <alpine.DEB.2.00.1203190852380.16879@router.home> <1332165959.18960.340.camel@twins>
 <alpine.DEB.2.00.1203191012530.17008@router.home> <1332170628.18960.349.camel@twins>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Peter Zijlstra wrote:

> > No they wont work the same way as before. Applications may be relying on
> > MPOL_DEFAULT behavior now expecting node local allocations. The home-node
> > functionality would cause a difference in behavior because it would
> > perform remote node allocs when a thread has been moved to a different
> > socket. The changes also cause migrations that may cause additional
> > latencies as well as change the location of memory in surprising ways for
> > the applications
>
> Still not sure what you're suggesting though, you argue to keep the
> default what it is, this is in direct conflict with making the default
> do something saner for most of the time.

MPOL_DEFAULT is a certain type of behavior right now that applications
rely on. If you change that then these applications will no longer work as
expected.

MPOL_DEFAULT is currently set to be the default policy on bootup. You can
change that of course and allow setting MPOL_DEFAULT manually for
applications that rely on old behavor. Instead set the default behavior on
bootup for MPOL_HOME_NODE.

So the default system behavior would be MPOL_HOME_NODE but it could be
overriding by numactl to allow old apps to run as they are used to run.

