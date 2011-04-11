Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1DKFIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 01:08:53 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51381 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab1DKFIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 01:08:50 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Apr 2011 01:08:50 EDT
X-Originating-IP: 217.70.178.34
X-Originating-IP: 50.43.35.130
Date: Sun, 10 Apr 2011 22:01:59 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] uts: Set default hostname to "localhost", rather than
 "(none)"
Message-ID: <20110411050155.GA2507@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "hostname" tool falls back to setting the hostname to "localhost" if
/etc/hostname does not exist.  Distribution init scripts have the same
fallback.  However, if userspace never calls sethostname, such as when
booting with init=/bin/sh, or otherwise booting a minimal system without
the usual init scripts, the default hostname of "(none)" remains,
unhelpfully appearing in various places such as prompts
("root@(none):~#") and logs.  Furthrmore, "(none)" doesn't typically
resolve to anything useful, while "localhost" does.

Change the default hostname to "localhost".  This removes the need for
the standard fallback, provides a useful default for systems that never
call sethostname, and makes minimal systems that much more useful with
less configuration.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Looked at "(none)" one too many times, and figured I ought to do
something about it.

Resending, and adding CCs for networking and UTS.

 include/linux/uts.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/uts.h b/include/linux/uts.h
index 73eb1ed..610bec2 100644
--- a/include/linux/uts.h
+++ b/include/linux/uts.h
@@ -9,7 +9,7 @@
 #endif
 
 #ifndef UTS_NODENAME
-#define UTS_NODENAME "(none)"	/* set by sethostname() */
+#define UTS_NODENAME "localhost"	/* set by sethostname() */
 #endif
 
 #ifndef UTS_DOMAINNAME
-- 
1.7.4.1

