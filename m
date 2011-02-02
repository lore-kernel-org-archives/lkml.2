Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1BBQrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:47:00 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:49466
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597Ab1BBQqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:46:53 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG019U-01-OB6-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] perf, x86: perf, x86: Add support for AMD family 15h core counters
Date: Wed, 2 Feb 2011 17:40:55 +0100
Message-ID: <1296664860-10886-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds support for AMD family 15h core counters. Major
changes compared to family 10h counters are:

* Now there are separate northbridge and core counters that resides in
  different MSR ranges (core: MSRC001_02[0B:00], nb:
  MSRC001_02[47:40]).

* The MSR addresses of perfctr and evntsel registers are now located
  side-by-side, we can not calculate the address with (base + index)
  anymore.

* There are 4 northbridge counters and 6 core counters.

* There are legacy aliases to old MSR counter addresses
  (MSRC001_00[03:00] -> MSRC001_02[07:00] respectively).

* There are restrictions now that not all performance monitor events
  can be counted on all counters.

We need to change MSR address handling of the x86 perf_event
implementation and also add more AMD event constraints to schedule
events.

This patch set only adds core counters.

-Robert



