Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab2JBNLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 09:11:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:57562 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2JBNLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:11:01 -0400
Message-ID: <1349183446.7780.32.camel@twins>
Subject: Re: [PATCH] perf cgroups: Fix perf_cgroup_switch schedule in warning
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 02 Oct 2012 15:10:46 +0200
In-Reply-To: <CABPqkBQvhUk=3OU4brv0LefZnRn2xSALA2-cVmE3A1wazDT=XA@mail.gmail.com>
References: <20121002114218.GA5891@krava.brq.redhat.com>
	 <1349178781.7780.29.camel@twins>
	 <20121002123921.GB6379@krava.brq.redhat.com>
	 <CABPqkBQvhUk=3OU4brv0LefZnRn2xSALA2-cVmE3A1wazDT=XA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 14:48 +0200, Stephane Eranian wrote:
> Not sure, I understand what active_pmu represents.

Its a 'random' pmu of those that share the cpuctx, exactly so you can
limit pmu iterations to those with unique cpuctx instances.

Its assigned when we create a cpuctx to the pmu creating it, its
re-assigned on pmu destruction (if that ever were to happen).

I realize the name isn't really helping but at the time I couldn't come
up with anything better :/

If you've got a good suggestion I'd be glad to rename it.
