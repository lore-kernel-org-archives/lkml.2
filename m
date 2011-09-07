Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1IGQlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:41:05 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:38692
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807Ab1IGQlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:41:03 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LR5VN0-02-27B-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7 -v2] perf, x86: Implement AMD IBS
Date: Wed, 7 Sep 2011 18:36:09 +0200
Message-ID: <1315413376-769-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.6.1
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

Changes for V2:

    * Remove printks in pmu function stubs.
    * Modify perf_event_ibs_init() to use ibs_caps directly.
    * Added bit mask for msr offsets.
    * Added caps field to raw sample format.
    * Added caps check for IBS_OP_CUR_CNT emulation.
    * Updated include header files to fix build errors on some distros.
    * Note: I kept example code for reference, the patch must not be
      applied. I will come up with a sulution that integrates IBS into
      perf-report.

-Robert


