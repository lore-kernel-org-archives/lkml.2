Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0FNJlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:41:15 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53751 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0FNJlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:41:14 -0400
From: Andy Whitcroft <apw@canonical.com>
To: Andy Whitcroft <apw@canonical.com>, Michal Marek <mmarek@suse.cz>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: [PATCH 1/1] kbuild: fix LOCALVERSION handling to match description
Date: Mon, 14 Jun 2010 10:41:10 +0100
Message-Id: <1276508470-21731-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the commit below the version string handling was modified, adding
a '+' where no other version information was supplied:

    commit 85a256d8e0116c8f5ad276730830f5d4d473344d
    Author: David Rientjes <rientjes@google.com>
    Date:   Wed Jan 13 13:01:05 2010 -0800

>From the commit the intent was as below:

     - when CONFIG_LOCALVERSION_AUTO is disabled, a `+' is appended if the
       repository has been revised beyond a tagged commit and LOCALVERSION=
       was not passed to "make".

However if the user supplies an empty LOCALVERSION on the command line
the plus suffix is still added.  This form is useful in the case where
the build environment knows that the version as specified is correct and
complete but does not correspond to a specific tag.

This patch changes the implementation to match the documentation
such that specifying LOCALVERSION= on the build line is sufficient
to suppress any suffix.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index d49d96c..662e820 100644
--- a/Makefile
+++ b/Makefile
@@ -944,7 +944,7 @@ ifdef CONFIG_LOCALVERSION_AUTO
 	localver-extra = $(scm-identifier)
 else
 	ifneq ($(scm-identifier),)
-		ifeq ($(LOCALVERSION),)
+		ifeq ("$(origin LOCALVERSION)", "undefined")
 			localver-extra = +
 		endif
 	endif
-- 
1.7.0.4

