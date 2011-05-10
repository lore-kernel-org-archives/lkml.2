Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1EJOfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 10:35:45 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:12539
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756255Ab1EJOfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 10:35:41 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZHVA-01-4AE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: [RFC][PATCH 0/3] perf support for amd guest/host-only bits
Date: Tue, 10 May 2011 16:35:29 +0200
Message-ID: <1305038132-5080-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this small set of patches implement support for the amd guest/host-only
bits into perf. The counting for either host or guest-mode can be
enabled using two additional attribute-bits.

The patches are RFC for now for several reasons. First of all, these are
my first patches for perf, so I likely don't implemented everything the
perf-way. Another reason is, that when one of these two bits is set, the
counters will only count when SVM is enabled (with KVM this is only the
case when a guest runs). So even when host-only is configured (which
needs to be done explicitly, so no regression, default is still to set
none of these two bits) the counter will not count at all as long as no
kvm guest is running. The question is whether this is ok or whether this
situation needs to be handled (say, count when host-only is specified by
userspace and svm is disabled). Or we just don't care because specifing
guest/host-only counting only makes sense with guests anyway. I am open
for both.

So any feedback is greatly appreciated :-)

Regards,

	Joerg

Diffstat:

 arch/x86/include/asm/perf_event.h    |    3 +++
 arch/x86/kernel/cpu/perf_event_amd.c |    6 ++++++
 include/linux/perf_event.h           |    5 ++++-
 kernel/perf_event.c                  |    4 ++++
 tools/perf/util/parse-events.c       |   10 +++++++++-
 5 files changed, 26 insertions(+), 2 deletions(-)

Shortlog:

Joerg Roedel (3):
      perf, core: Introduce attrs to count in either host or guest mode
      perf, x86: Use GO/HO bits in perf-ctr
      perf, tools: Add support for guest/host-only profiling


