Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1JYV4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 17:56:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56003 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab1JYV4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 17:56:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=gtx2ixpEnMPMTx5inPKY3giu57QTCq7W4ib8Ja+4S8goS+O5E6shkcDHLczATAGYC
	W5NEEv5fbpyYlBiceEoHA==
Date: Tue, 25 Oct 2011 14:50:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B3@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110251446340.26017@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <20111011125419.2702b5dc.akpm@linux-foundation.org> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com> <20111011135445.f580749b.akpm@linux-foundation.org> <4E95917D.3080507@redhat.com>
 <20111012122018.690bdf28.akpm@linux-foundation.org>,<4E95F167.5050709@redhat.com> <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B1@USINDEVS02.corp.hds.com>,<alpine.DEB.2.00.1110231419070.17218@chino.kir.corp.google.com>
 <65795E11DBF1E645A09CEC7EAEE94B9CB4F747B3@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011, Satoru Moriya wrote:

> >> We do.
> >> Basically we need this kind of feature for almost all our latency
> >> sensitive applications to avoid latency issue in memory allocation.
> >>
> > 
> > These are all realtime?
> 
> Do you mean that these are all realtime process?
> 
> If so, answer is depending on the situation. In the some situations,
> we can set these applications as rt-task. But the other situation,
> e.g. using some middlewares, package softwares etc, we can't set them
> as rt-task because they are not built for running as rt-task. And also
> it is difficult to rebuilt them for working as rt-task because they
> usually have huge code base.
> 

If this problem affects processes that aren't realtime, then your only 
option is to increase /proc/sys/vm/min_free_kbytes.  It's unreasonable to 
believe that the VM should be able to reclaim in the background at the 
same rate that an application is allocating huge amounts of memory without 
allowing there to be a buffer.  Adding another tunable isn't going to 
address that situation better than min_free_kbytes.

> As I reported another mail, changing kswapd priority does not mitigate
> even my simple testcase very much. Of course, reclaiming above the high
> wmark may solve the issue on some workloads but if an application can
> allocate memory more than high wmark - min wmark which is extended and
> fast enough, latency issue will happen.
> Unless this latency concern is fixed, customers doesn't use vanilla
> kernel.
> 

And you have yet to provide an expression that shows what a sane setting 
for this tunable will be.  In fact, it seems like you're just doing trial 
and error and finding where it works pretty well for a certain VM 
implementation in a certain kernel.  That's simply not a maintainable 
userspace interface!
