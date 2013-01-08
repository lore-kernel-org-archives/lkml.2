Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3AHXYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:24:34 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35158 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737Ab3AHXYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:24:32 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] Add decoder for GFP masks to tools.
Date: Tue,  8 Jan 2013 15:24:13 -0800
Message-Id: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010823-5806-0000-0000-00001DF81818
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I needed to decode some gfp_masks to debug an oom-killer invocation, and wrote
this tool to avoid doing the decoding manually.

Bad things about this: slightly hacky use of code intended for use with ftrace,
splitting linux/gfp.h into 2 parts.

Good things: No additional places need modification to keep the decoder up to
date, no mistakes from manual gfp_mask decoding.

 include/linux/gfp-flags.h     | 143 +++++++++++++++++++++++++++++++++++++++++
 include/linux/gfp.h           | 144 +-----------------------------------------
 tools/gfp-decode/.gitignore   |   1 +
 tools/gfp-decode/Makefile     |  11 ++++
 tools/gfp-decode/gfp-decode.c |  89 ++++++++++++++++++++++++++
 5 files changed, 245 insertions(+), 143 deletions(-)

---

On the topic of writing Makefiles for tools/*, it would be extremely
convienient if a system was setup which allowed simple specification of final
executable(s) and the objects to compose them rather than having each tool
write a custom Makefile.

For example (potentially):

	TARGETS = gfp-decode
	obj-gfp-decode = gfp-decode.o
	include ../scripts/Makefile.magic

