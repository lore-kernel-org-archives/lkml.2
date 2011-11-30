Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1K3FUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:20:14 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:17169
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751017Ab1K3FUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:20:12 -0500
X-SpamScore: -4
X-BigFish: VS-4(zz4015Lzz1202hzz8275dhz2dh87h2a8h668h839h8e2h8e3h944h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:160.36.179.135;KIP:(null);UIP:(null);IPV:NLI;H:kedge3.utk.tennessee.edu;RD:kedge3.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 30 Nov 2011 00:20:04 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>
Subject: perf_event self-monitoring overhead regression
Message-ID: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've been tracking a performance regression with self-monitoring and 
perf_event.

For a simple start/stop/read test, the overhead has increased about 10%
from the 2.6.32 kernel to 3.1.  (this has been measured on a variety
of x86_64 machines).

This is as measured with the POSIX clock_gettime(CLOCK_REALTIME,&time)
calls.  Potentially the issue is with this and not with perf_events.
As you can imagine it is hard to measure the performance of the perf_event
interface since you can't invoke perf_event on it.

In any case, I was trying to bisect some of these performance issues.  
There was another jump in overhead between 3.0 and 3.1, so I tried there.
I had a bisectable test case, but after a tedious day-long bisect run the 
problem bisected down to

   commit 2d86a3f04e345b03d5e429bfe14985ce26bff4dc
   Merge: 3960ef3 5ddac6b
   Author: Linus Torvalds <torvalds@linux-foundation.org>
   Date:   Tue Jul 26 17:13:04 2011 -0700

    Merge branch 'next/board' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/l
    
Which seems unlikely.  My git skills really aren't enough to try to figure
out why an ARM board merge would affect the overhead of the perf_event
syscalls on x86_64.

Is there a better way for trying to track down performance regressions 
like this?

Thanks,

Vince
vweaver1@eecs.utk.edu

