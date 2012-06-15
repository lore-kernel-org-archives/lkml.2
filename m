Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab2FOXZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 19:25:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18091 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab2FOXZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 19:25:01 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EwAfToejOIUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=4IMKUPfyF6xLaM3MNq4A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339802699.25903.47.camel@gandalf.stny.rr.com>
Subject: kbuild: Document oldnoconfig to what it really does
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Date: Fri, 15 Jun 2012 19:24:59 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The make target 'oldnoconfig' is a misnomer. It doesn't set new symbols
to 'n', but instead sets it to their default values.

Unfortunately, assuming that it actually did this, broke ktest in some
of its tests. For example, the tests to create a minimum config and even
a config bisect, depends on removing various configs and using
oldnoconfig to get rid of other configs that may have depended on it.

But because some configs that it was trying to disable, were in fact
default enabled, this caused those configs to re-enable and corrupt the
test.

I thought about fixing oldnoconfig, but I'm afraid that people are
already dependent on its current behavior. Instead, I'm just updating
the documentation to state that it sets the new symbols to their default
values and not to 'n'.

Ideally, this would be called, 'olddefconfig' and we have an
'oldnoconfig' that actually disables the new symbols. But it's useless
for me now. If it changed, ktest would need to be consistent between
each version, and that would be to difficult to detect. I'll handle this
issue with ktest with other means.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 7966265..da36bde 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -114,7 +114,7 @@ help:
 	@echo  '  alldefconfig    - New config with all symbols set to default'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  listnewconfig   - List new options'
-	@echo  '  oldnoconfig     - Same as silentoldconfig but set new symbols to n (unset)'
+	@echo  '  oldnoconfig     - Same as silentoldconfig but sets new symbols to their default value'
 
 # lxdialog stuff
 check-lxdialog  := $(srctree)/$(src)/lxdialog/check-lxdialog.sh


