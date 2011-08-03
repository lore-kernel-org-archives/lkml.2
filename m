Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1HCSDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:03:08 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:45577
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255Ab1HCSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:03:03 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dK1432N98dKzz1202hzzz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LPD5UE-01-1W5-02
X-M-MSG: 
Date: Wed, 3 Aug 2011 19:56:38 +0200
From: Robert Richter <robert.richter@amd.com>
To: Michael Cree <mcree@orcon.net.nz>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>
Subject: Re: [PATCH 6/7] perf, x86: Example code for AMD IBS
Message-ID: <20110803175637.GN11795@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-7-git-send-email-robert.richter@amd.com>
 <1311958729.5890.413.camel@twins>
 <20110801055008.GZ4590@erda.amd.com>
 <1312281474.1147.40.camel@twins>
 <4E39065C.6020801@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E39065C.6020801@orcon.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.08.11 04:27:08, Michael Cree wrote:
> On 02/08/11 22:37, Peter Zijlstra wrote:

> > Possibly, but having just looked at the example again I don't really see
> > it doing anything perf-record doesn't already do, so why does it deserve
> > to live at all?

I also got it running with perf-record with Lin's patch

 perf tool: Parse general/raw events from sysfs

with no other changes using:

 perf record -R -e ibs_fetch:r0 -a -c 10000 <command>

What is missing here is a parser for the IBS sampling data that is
very specific, which would be the perf-ibs-annotate tool you
recommended.

> > Initially I thought it was a record+report like example, some code
> > interpreting the 'mess' that comes out of IBS would be most appreciated
> > and I think we can even ship that as perf-ibs-report/perf-ibs-annotate
> > or so (and if its still remotely similar to its Alpha precursor that
> > might make the Alpha folks happy too).

Yes, the example I wrote could use perf-record as backend. The parser
for IBS could be part of perf-record, if we encode the pmu name
(ibs_op/ibs_fetch) in perf.data. Then we don't neeed a special tool
for IBS anymore.

> Sure would be nice if the infrastructure to support ProfileMe mode
> appeared in the perf. events subsystem.  I am not going to go full out
> to implement all the support needed for it because there are too few
> users on Alpha to justify the effort.  But if we could score an
> implementation of ProfileMe mode with minimal effort on the back of an
> AMD implementation that would make us happy.

ProfileMe looks similar to IBS, so the above would fit there too.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

