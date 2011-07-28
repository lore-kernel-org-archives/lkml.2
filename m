Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1G1NwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:52:12 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:54850
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084Ab1G1Nuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:50:40 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP1QGA-02-3SM-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] perf, x86: Implement AMD IBS
Date: Thu, 28 Jul 2011 15:46:45 +0200
Message-ID: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.5.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for AMD IBS to perf. It is a new
implementation and unrelated to my previous postings last year. The
main differences are:

* separate and independent from x86 perfctrs, IBS could be used
  without the x86 pmu,
* using dynamic pmu allocation, userspace uses sysfs to select the pmu,
* support for 64 bit counters,
* libperf based example code,
* shared IBS initialziation code for perf and oprofile.

The approach is still to collect raw sample data which should be the
most important use case for application developers. The data format is
the same as described in the IBS register specification.

Future work could be:

* better integration into the perf tool, use IBS for generic events
  where possible,
* support of the precise event sampling perf i/f,
* implementation of extended IBS features (e.g. ext. counter width),
* support of counting (perf stat),
* in-kernel IBS event parsing,
* IBS tracepoint support.

-Robert


