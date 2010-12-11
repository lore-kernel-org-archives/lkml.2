Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0LKURy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:17:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46296 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab0LKURv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:17:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM / Hibernate: Restore old swap signature to avoid user space breakage
Date: Sat, 11 Dec 2010 21:17:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Karel Zak <kzak@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Pascal Chapperon <pascal.chapperon@wanadoo.fr>
References: <201012052324.30231.rjw@sisk.pl>
In-Reply-To: <201012052324.30231.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012112117.06636.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 05, 2010, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Commit 3624eb0 (PM / Hibernate: Modify signature used to mark swap)
> modified hibernate signature used to mark swap partitions containing
> hibernation images, but that turns out to have caused problems in
> libblkid on recent Ubuntu.  Restore the old signature to avoid those
> problems.

Below is the same patch with modified changelog reflecting the recent findings.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Restore old swap signature to avoid user space breakage

Commit 3624eb0 (PM / Hibernate: Modify signature used to mark swap)
attempted to modify hibernate signature used to mark swap partitions
containing hibernation images, so that old kernels don't try to
handle compressed images.  However, this change broke resume from
hibernation on Fedora 14 that apparently doesn't pass the resume=
argument to the kernel and tries to trigger resume from early user
space.  This doesn't work, because the signature is now different,
so the old signature has to be restored to avoid the problem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Dr. David Alan Gilbert <linux@treblig.org>
Reported-by: Pascal Chapperon <pascal.chapperon@wanadoo.fr>
---
 kernel/power/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -30,7 +30,7 @@
 
 #include "power.h"
 
-#define HIBERNATE_SIG	"LINHIB0001"
+#define HIBERNATE_SIG	"S1SUSPEND"
 
 /*
  *	The swap map is a data structure used for keeping track of each page
