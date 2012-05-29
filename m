Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2E2Pxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 11:53:41 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:26964 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754038Ab2E2Pxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 11:53:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eqyztOIVM1mAdNEGryagQM1blqH7lLw3n1rQCBG7GYovFPt
 s00DednNSEGdq8sZ_ppa9aG_LJDQpMsAzi3J0912e8sUMqiOVK4W_xb9hlGV
 ZMgBNRNoDX988aMI8CuPhdTd0ZhkJ1MNNcsPm6yhgMoOYFggZqyk.XZ1pi2T
 da8iOPTGfVzZxscnjHjUIPGBvejjQ8yclmPxn2_FpozM7XOeARBruHrUE_Ht
 5GG9jJ88SHS_R7GbZNs.I_tTAiIENncrx4KDqbWyNSNrcvuco1RANY_NiGix
 HzVYsEIjQEajH7K8kqp0LEueMKNRXpsuAIBlXvCZttwA447ypVovkB8RnVJS
 aVwR4N8X_Tv4ikLGjgGPmCgOVB65KpZa70a0bao.iT.dhXgtVUaLECvEXW5X
 4
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 10:53:32 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/35] AutoNUMA alpha14
In-Reply-To: <CA+55aFxpD+LsE+aNvDJtz9sGsGMvdusisgOY3Csbzyx1mEqW-w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205291033360.6723@router.home>
References: <1337965359-29725-1-git-send-email-aarcange@redhat.com> <4FC112AB.1040605@redhat.com> <CA+55aFxpD+LsE+aNvDJtz9sGsGMvdusisgOY3Csbzyx1mEqW-w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 May 2012, Linus Torvalds wrote:

>
> I'm a *firm* believer that if it cannot be done automatically "well
> enough", the absolute last thing we should ever do is worry about the
> crazy people who think they can tweak it to perfection with complex
> interfaces.
>
> You can't do it, except for trivial loads (often benchmarks), and for
> very specific machines.

NUMA APIs already exist that allow tuning for the NUMA cases by allowing
the application to specify where to get memory from and where to run the
threads of a process. Those require the application to be aware of the
NUMA topology and exploit the capabilities there explicitly. Typically one
would like to reserve processors and memory for a single application that
then does the distribution of the load on its own. NUMA aware applications
like that do not benefit and do not need either of the mechanisms proposed
here.

What these automatic migration schemes (autonuma is really a bad term for
this. These are *migration* schemes where the memory is moved between NUMA
nodes automatically so call it AutoMigration if you like) try to do is to
avoid the tuning bits and automatically distribute generic process loads
in a NUMA aware fashion in order to improve performance. This is no easy
task since the cost of migrating a page is much more expensive that the
additional latency due to access of memory from a distant node. A huge
number of accesses must occur in order to amortize the migration of a
page. Various companies in decades past have tried to implement
automigration schemes without too much success.

I think the proof that we need is that a general mix of applications
actually benefits from an auto migration scheme. I would also like to see
that it does no harm to existing NUMA aware applications.

