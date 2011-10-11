Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab1JKHiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 03:38:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:38420 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab1JKHiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 03:38:54 -0400
Subject: Re: Oprofile Regression Caused by commit
 e5d1367f17ba6a6fed5fd8b74e4d5720923e0c25 on PPC
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric B Munson <emunson@mgebm.net>
Cc: eranian@google.com, mingo@elte.hu, anton@samba.org,
        linux-kernel@vger.kernel.org, paulus@samba.org, hbabu@us.ibm.com
In-Reply-To: <20111010233842.GC24583@mgebm.net>
References: <20111007204247.GA5444@mgebm.net>
	 <20111010233842.GC24583@mgebm.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 09:44:55 +0200
Message-ID: <1318319095.14400.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 19:38 -0400, Eric B Munson wrote:
> On Fri, 07 Oct 2011, Eric B Munson wrote:
> 
> > This commit seems to have caused a regression with oprofile.  It is fairly easy
> > to trigger, simply run oprofile monitoring an event that will fire (something
> > frequent like CPU cycles) causes oprofile to fail saying that the PMU is in use.
> > If I disable CONFIG_CGROUP_PERF, everything goes back to working.  I suspect the
> > problem is that the PMU is being initialized without being reserved for perf.  I
> > am not yet sure of the right fix yet so if you have any suggestions I would
> > appreciate them.
> > 
> > Eric
> 
> This isn't the best description of the behavior we see, what happens is at some
> point in the profiling session the MMCR register is clobbered by
> perf_cgroup_switch() which calls perf_pmu_enable() without reserving the PMC
> hardware.  When this happens oprofile stops counting.  It doesn't happen each
> time so some runs show event counts that are reasonable, but it can also lead to
> event counts that are smaller than expected, or completely missing.

What kernel are you testing?

