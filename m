Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab1FQNhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:37:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:33604
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753254Ab1FQNhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:37:11 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz4015Lzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMXSHO-02-52Q-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [PATCH 0/5] perf support for amd guest/host-only bits v2
Date: Fri, 17 Jun 2011 15:37:29 +0200
Message-ID: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second version of the patch-set to support the AMD
guest-/host only bits in the performance counter MSRs. Due to lack of
time I havn't looked into emulating support for this feature on Intel or
other architectures, but the other comments should be worked in. The
changes to v1 include:

	* Rebased patches to v3.0-rc3
	* Allow exclude_guest and exclude_host set at the same time
	* Reworked event-parse logic for the new exclude-bits
	* Only count guest-events per default from perf-kvm

Thats it, unless I forgot something. Any feedback appreciated :-)

Thanks,

	Joerg

Diffstat:

 arch/x86/include/asm/perf_event.h    |    3 +++
 arch/x86/kernel/cpu/perf_event_amd.c |   13 +++++++++++++
 include/linux/perf_event.h           |    5 ++++-
 tools/perf/builtin-kvm.c             |    5 +++--
 tools/perf/util/event.c              |    8 ++++++++
 tools/perf/util/event.h              |    2 ++
 tools/perf/util/evlist.c             |    5 ++++-
 tools/perf/util/parse-events.c       |   15 +++++++++++++--
 8 files changed, 50 insertions(+), 6 deletions(-)

Shortlog:

Joerg Roedel (5):
      perf, core: Introduce attrs to count in either host or guest mode
      perf, amd: Use GO/HO bits in perf-ctr
      perf, tools: Add support for guest/host-only profiling
      perf, tools: Fix copy&paste error in perf-kvm option description
      perf, tools: Do guest-only counting in perf-kvm by default


