Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1JVPQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 11:16:39 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:54318 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab1JVPQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 11:16:38 -0400
Date: Sat, 22 Oct 2011 11:12:29 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mmarek@suse.cz
Subject: [PATCH RFC] try to create KBUILD_OUTPUT automatically
Message-id: <alpine.LNX.2.00.1110221049460.59156@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to execute make O=work instead of
mkdir work
make O=work

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 2652089..a4769ac 100644
--- a/Makefile
+++ b/Makefile
@@ -117,7 +117,7 @@ ifneq ($(KBUILD_OUTPUT),)
 # Invoke a second make in the output directory, passing relevant variables
 # check that the output directory actually exists
 saved-output := $(KBUILD_OUTPUT)
-KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
+KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && /bin/pwd)
 $(if $(KBUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))
 
-- 
1.7.7

