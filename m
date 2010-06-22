Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab0FVS62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:58:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0FVS60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:58:26 -0400
Date: Tue, 22 Jun 2010 14:58:12 -0400
From: Don Zickus <dzickus@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH v4] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-ID: <20100622185812.GC5381@redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
 <20100617091322.b7d21473.randy.dunlap@oracle.com>
 <4C1A7D61.8010900@redhat.com>
 <20100621122145.76ebd7ac.akpm@linux-foundation.org>
 <20100621194559.GI3217@redhat.com>
 <20100621130008.d3dc01a8.akpm@linux-foundation.org>
 <20100622153457.GA5381@redhat.com>
 <20100622164835.4ddb9432@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100622164835.4ddb9432@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is similar to Theordore Ts'o's TAINT_USER patch,
linux-2.6 commit 34f5a39899f3f3e815da64f48ddb72942d86c366.

Individual distributions may enable "generic" features such as X86 support,
PPC support, and driver support.

Some of the features that are enabled by these "generic" feature flags may
not be considered supported by the individual distribution.

For example, a distribution may want to support PPC but not the Power5
chipset, or the e1000e driver but not a card with a specific DeviceID because
of known firmware issues.

Typically, one would push a config patch to enable and disable the feature and
patch the distribution.  However, in some cases this is not feasible in order
to preserve kabi and at the same time maintain parity with the upstream kernel.
In some cases the distribution may want to allow booting of these features but
explicitly notify a user that they are not "officially" supported.  It is also
possible that the hardware is fixed via a firmware update at a later date,
making it supported again.

It would be useful for a distribution to notify the installer and
bug reporting applications, and notify users that the hardware they are using
is unsupported during panic, oops, BUG(), and WARN().

This patch reserves taint bits for distributions to use as they seem fit
without the fear of them being stepped up in future kernels.

V4:  just reserve the bits

Signed-off-by: Don Zickus <dzickus@redhat.com>

---

Not sure if this is sufficient for reserving or if there is some other code
I have to add elsewhere too.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index cc5e3ff..c7b9e2c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -347,6 +347,11 @@ extern enum system_states {
 #define TAINT_WARN			9
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
+/* Reserving bits for vendor specific uses */
+#define TAINT_RESERVED28		28
+#define TAINT_RESERVED29		29
+#define TAINT_RESERVED30		30
+#define TAINT_RESERVED31		31
 
 extern void dump_stack(void) __cold;
 
