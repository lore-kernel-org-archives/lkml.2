Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab0FIQIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:08:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:4724 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0FIQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=PGVRGk/JJ5GROnKEb+EvCKUUUtI4FTiiexFRpHI57IQK9Ed5pc16XDhW+fDNXKu82Y
         SWt7bJ2D/xE8890SnbLi69+4pgveHqiO9lgk7S6fYpDwFGX1fUtLheBbff5hKRa1Nn4t
         9cbn2hOyiKKEvtN7RME1RwXj4JYCB2vE4v5wQ=
From: John Kacur <jkacur@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/2] trace-cmd: Makefile - use a substitution reference
Date: Wed,  9 Jun 2010 18:01:28 +0200
Message-Id: <1276099288-3029-3-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1276099288-3029-1-git-send-email-jkacur@redhat.com>
References: <1276099288-3029-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

subst will substitution every occurence of a string with another.
What we want here is just to substitute the last occurence.
That is we want to transform files that end with .1 into .1.install
We do not want to transform every ".1" in a path name into .1.install.

Without this fix you can get errors of this nature.

 make prefix=/home/jkacur/rpmbuild/BUILDROOT/trace-cmd-1.0.1-4.fc12.x86_64/usr install_doc
 make -C /home/jkacur/rpmbuild/BUILD/trace-cmd-1.0.1/Documentation install
 make[1]: *** No rule to make target `/home/jkacur/rpmbuild/BUILD/trace-cmd-1.0.1.install/Documentation/trace-cmd.1', needed by `/home/jkacur/rpmbuild/BUILD/trace-cmd-1.0.1.install/Documentation/trace-cmd.1.install'.  Stop.
 make: *** [install_doc] Error 2

Signed-off-by: John Kacur <jkacur@redhat.com>

Use a "substitution reference" instead of a substitution.
A "subst" will change every occurence of a string
---
 Documentation/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 7ed8877..d161703 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -77,8 +77,8 @@ define do_install
 	$(INSTALL) $1 $2;
 endef
 
-MAN1_INSTALL = $(subst .1,.1.install,$(MAN1))
-MAN5_INSTALL = $(subst .5,.5.install,$(MAN5))
+MAN1_INSTALL = $(MAN1:%.1=%.1.install)
+MAN5_INSTALL = $(MAN5:%.5=%.5.install)
 
 $(MAN1_INSTALL): %.1.install : %.1 force
 	$(Q)$(call do_install, $<, '$(man_dir_SQ)/man1')
@@ -92,4 +92,4 @@ clean:
 	 $(RM) *.xml *.xsl *.1 *.5)
 
 .PHONE: force
-force:
\ No newline at end of file
+force:
-- 
1.6.6.1

