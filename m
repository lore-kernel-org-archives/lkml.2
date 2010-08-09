Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab0HILV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 07:21:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49504 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756101Ab0HILVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 07:21:53 -0400
From: Dave Martin <dave.martin@linaro.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Martin <dave.martin@linaro.org>
Subject: [PATCH 0/1] perf symbols: ignore mapping symbols on ARM
Date: Mon,  9 Aug 2010 12:21:17 +0100
Message-Id: <1281352878-8735-1-git-send-email-dave.martin@linaro.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to linux-2.6-tip/master or acme/perf-core

ARM ELF files use symbols with special names $a, $t, $d to
identify regions of ARM code, Thumb code and data within code
sections.  This can cause confusing output from the perf tools,
especially for partially stripped binaries, or binaries
containing user-added zero-sized symbols (which may occur in
hand-written assembler which hasn't been fully annotated with
.size directives).

This patch filters out these symbols at load time.

Addressing architecture-specific cases in this way could get
quite messy-- if one architecture-specific hack is needed in
the symbol loading loop, more might be needed over time.
Adding a generic per-architecture symbol filtering hook might
help to mitigate this if more cases need to be supported.

Switching to libbfd as a generic image-handling backend for all
architectures might be a better long-term solution, since
libelf seems to be essentially a low-level parsing library only
at this stage, and doesn't deal with all the architecture
specifics.  There's a generic bfd_is_target_special_symbol()
function which is used by binutils to filter out architecture-
specific symbols which are not "normal" symbols, which could
help us for this case.

Dave Martin (1):
  perf symbols: ignore mapping symbols on ARM

 tools/perf/util/symbol.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

