Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2I1GHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:07:24 -0400
Received: from ozlabs.org ([203.10.76.45]:43945 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab2I1GHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:07:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Howells <dhowells@redhat.com>
Cc: dhowells@redhat.com, herbert@gondor.hengli.com.au, pjones@redhat.com,
        jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Subject: [PATCH 2/2] modules: don't call eu-strip if it doesn't exist.
In-Reply-To: <16088.1348736905@warthog.procyon.org.uk>
References: <87bogs492s.fsf@rustcorp.com.au> <87ehlp30pd.fsf@rustcorp.com.au> <5555.1348531649@warthog.procyon.org.uk> <8168.1348650575@warthog.procyon.org.uk> <16088.1348736905@warthog.procyon.org.uk>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 28 Sep 2012 15:29:03 +0930
Message-ID: <87lifu3cyg.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 90b1bb1..2a4d1a1 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -165,11 +165,13 @@ endif
 
 # We strip the module as best we can - note that using both strip and eu-strip
 # results in a smaller module than using either alone.
+EU_STRIP = $(shell which eu-strip || echo true)
+
 quiet_cmd_sign_ko_stripped_ko_unsigned = STRIP [M] $@
       cmd_sign_ko_stripped_ko_unsigned = \
 		cp $< $@ && \
 		strip -x -g $@ && \
-		eu-strip $@
+		$(EU_STRIP) $@
 
 ifeq ($(SIGN_MODULES),1)
 
