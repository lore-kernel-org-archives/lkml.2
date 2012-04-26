Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab2DZSgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 14:36:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10240 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab2DZSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 14:35:11 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=eUR6Df7o69oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=gbyrPOSFo3780JuteBIA:9 a=wpCKxvRrDsfzSBIELxQA:7 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120426183116.857877522@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 26 Apr 2012 14:31:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 0/3][RFC] powerpc/ftrace: Removal of stop machine (and other goodies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Benjamin,

You once told me on IRC that powerpc has no problem with modifying
code on one CPU that may be executing on another CPU. With the tests I
made on my PPC64 (2 CPUs) box, it seems to be the case.

The first patch removes stop_machine from powerpc. The other patches
add some error handling if ftrace detects an update didn't occur
with 'patch_instruction'.

This is just an RFC, but if it's fine, feel free to pull them into
your tree.

-- Steve

Steven Rostedt (3):
      ftrace/ppc: Have PPC skip updating with stop_machine()
      powerpc: Have patch_instruction detect faults
      ftrace/ppc: Use patch_instruction instead of probe_kernel_write()

----
 arch/powerpc/include/asm/code-patching.h |    4 +-
 arch/powerpc/kernel/ftrace.c             |   69 ++++++++++++++++++++++++------
 arch/powerpc/lib/code-patching.c         |   14 ++++--
 3 files changed, 68 insertions(+), 19 deletions(-)
