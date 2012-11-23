Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab2KWA43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:56:29 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:54834 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2KWA42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:56:28 -0500
Date: Thu, 22 Nov 2012 16:53:15 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH resend 0/7] KDB: Kiosk (reduced capabilities) mode
Message-ID: <20121123005315.GA12690@lizard.mcd25758.sjc.wayport.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew, Jason,

And yet another set that folks seem to be too busy to look into. :)

The rationale for the series is this:

This patchset implements "kiosk" mode for KDB debugger. The mode reduces
kdb features, so that it is no longer possible to leak sensitive data via
the debugger, and not possible to change program flow in a predefined
manner by an ordinary user. The root can control the capability.

It is useful on phones with an easy access to a debugger console (e.g.
thru a headphone mini-jack), or on a public PCs (but we still want to let
the user somewhat diagnose the problem via KDB-via-KMS).

Later we might want to implement password-protected "unlock" command (with
the hash of the password passed via some sysfs attribute).

There are a few patches, some are just cleanups, some are churn-ish
cleanups, but inevitable. And the rest implements the mode -- after all
the preparations, everything is pretty straightforward.

Thanks!
Anton.

--
 include/linux/kdb.h            |  20 ++--
 kernel/debug/kdb/kdb_bp.c      |  24 ++---
 kernel/debug/kdb/kdb_main.c    | 189 +++++++++++++++++----------------
 kernel/debug/kdb/kdb_private.h |   3 +-
 kernel/trace/trace_kdb.c       |   4 +-
 5 files changed, 125 insertions(+), 115 deletions(-)
