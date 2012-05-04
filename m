Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2EDVog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:44:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60095 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab2EDVoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:44:34 -0400
Message-ID: <1336167852.6509.90.camel@twins>
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Date: Fri, 04 May 2012 23:44:12 +0200
In-Reply-To: <20120504213010.GD3054@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
	 <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com>
	 <1336162456.6509.63.camel@twins>
	 <20120504204627.GB18177@linux.vnet.ibm.com>
	 <1336164981.6509.72.camel@twins> <20120504213010.GD3054@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 14:30 -0700, Nishanth Aravamudan wrote:
> Well, it is the case that libvirt does use it, and libvirt is used
> pretty widely (or so it seems to me). I don't use it (cpusets or libvirt
> :) either, but it seems like we should either tell libvirt directly that
> cpusets are inappropriate for their use-case (once we figure out what
> exactly that is, and why they chose cpusets) or work with them to
> support their use-case? 

Sure, lets start by getting their use-case, then see if cpuset is the
right solution and if so take it from there.

That said, the whole suspend/resume 'problem' does seem worth fixing and
is a very special case where we absolutely know we're going to get back
in the state we are in and userspace isn't actually running. So ideally
we'd go with the bhat's patch that skips the sched_domain rebuilds
entirely +- some bug-fixes ;-).
