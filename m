Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523Ab2EDTZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 15:25:23 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59495 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2EDTZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 15:25:22 -0400
Message-ID: <1336159496.6509.51.camel@twins>
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mingo@kernel.org, pjt@google.com, paul@paulmenage.org,
        akpm@linux-foundation.org, rjw@sisk.pl, nacc@us.ibm.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, rob@landley.net, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-pm@vger.kernel.org
Date: Fri, 04 May 2012 21:24:56 +0200
In-Reply-To: <20120504191535.4603.83236.stgit@srivatsabhat>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   Documentation/cgroups/cpusets.txt |   43 +++--
>  include/linux/cpuset.h            |    4 
>  kernel/cpuset.c                   |  317 ++++++++++++++++++++++++++++---------
>  kernel/sched/core.c               |    4 
>  4 files changed, 274 insertions(+), 94 deletions(-)

Bah, I really hate this complexity you've created for a problem that
really doesn't exist.

So why not fix the active mask crap?
