Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab0DMU2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:28:41 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:53448 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab0DMU0x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:26:53 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zzzz1202hzz5eeePz32i87h2a8h6bh467h43h64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L0U0SH-02-H0N-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/12] perf: introduce model specific events and AMD IBS
Date: Tue, 13 Apr 2010 22:23:09 +0200
Message-ID: <1271190201-25705-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Apr 2010 20:26:35.0355 (UTC) FILETIME=[9CD07AB0:01CADB47]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series introduces model specific events and impments AMD
IBS (Instruction Based Sampling) for perf_events.

IBS is documented here:

 BIOS and Kernel Developer’s Guide (BKDG) For AMD Family 10h Processors
 http://support.amd.com/us/Processor_TechDocs/31116.pdf 

 AMD64 Architecture Programmer’s Manual Volume 2: System Programming
 http://support.amd.com/us/Processor_TechDocs/24593.pdf

The general approach is to introduce a flag to mark an event as model
specific. With that flag set a model specific ibs (raw) config value
can be passed to the pmu for setup. When there are ibs samples
available, it is sent back as a raw data sample to the userland. So we
have a raw config value and raw sampling data. This requires the
userland to setup ibs and further extract and process sampling data.

Patches 1-8 rework and refactor the code to prepare the ibs
implementation. This is done in patches 9-12.

I will add ibs example code to libpfm4.

-Robert


