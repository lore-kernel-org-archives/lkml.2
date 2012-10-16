Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2JPBUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 21:20:19 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59349 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074Ab2JPBUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 21:20:17 -0400
Date: Mon, 15 Oct 2012 18:17:24 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Colin Cross <ccross@google.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 0/7] KDB: Kiosk (reduced capabilities) mode
Message-ID: <20121016011724.GB23146@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

Just as promised, I'm resending the series after the merge window.

This patchset implements "kiosk" mode for KDB debugger. The mode reduces
kdb features, so that it is no longer possible to leak sensitive data via
the debugger, and not possible to change program flow in a predefined
manner by an ordinary user. Root can control the capability.

There are a few patches, some are just cleanups, some are churn-ish
cleanups, but inevitable. And the rest implements the mode -- after all
the preparations, everything is pretty straightforward.

Thanks!
Anton.

--
 include/linux/kdb.h            |  20 ++--
 kernel/debug/kdb/kdb_bp.c      |  24 ++---
 kernel/debug/kdb/kdb_main.c    | 189 ++++++++++++++++++----------------
 kernel/debug/kdb/kdb_private.h |   3 +-
 kernel/trace/trace_kdb.c       |   4 +-
 5 files changed, 125 insertions(+), 115 deletions(-)
