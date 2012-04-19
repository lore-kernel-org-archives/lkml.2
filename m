Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965343Ab2DSVSZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:18:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965301Ab2DSVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:18:15 -0400
Message-Id: <20120419210823.420962871@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:09:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonghwan Choi <jhbird.choi@samsung.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>
Subject: [ 56/68] security: fix compile error in commoncap.c
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonghwan Choi <jhbird.choi@samsung.com>

commit 51b79bee627d526199b2f6a6bef8ee0c0739b6d1 upstream.

Add missing "personality.h"
security/commoncap.c: In function 'cap_bprm_set_creds':
security/commoncap.c:510: error: 'PER_CLEAR_ON_SETID' undeclared (first use in this function)
security/commoncap.c:510: error: (Each undeclared identifier is reported only once
security/commoncap.c:510: error: for each function it appears in.)

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/commoncap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -28,6 +28,7 @@
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 #include <linux/user_namespace.h>
+#include <linux/personality.h>
 
 /*
  * If a non-root user executes a setuid-root binary in


