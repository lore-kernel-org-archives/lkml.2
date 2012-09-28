Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031512Ab2I1Tke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:40:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965311Ab2I1TAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Salter <msalter@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 129/262] c/r: prctl: fix build error for no-MMU case
Date: Fri, 28 Sep 2012 11:50:58 -0700
Message-Id: <20120928183013.267216695@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Salter <msalter@redhat.com>

commit be8cfc4af15cf611dfeb66a1fb5df43d5f1e280a upstream.

Commit 1ad75b9e1628 ("c/r: prctl: add minimal address test to
PR_SET_MM") added some address checking to prctl_set_mm() used by
checkpoint-restore.  This causes a build error for no-MMU systems:

   kernel/sys.c: In function 'prctl_set_mm':
   kernel/sys.c:1868:34: error: 'mmap_min_addr' undeclared (first use in this function)

The test for mmap_min_addr doesn't make a lot of sense for no-MMU code
as noted in commit 6e1415467614 ("NOMMU: Optimise away the
{dac_,}mmap_min_addr tests").

This patch defines mmap_min_addr as 0UL in the no-MMU case so that the
compiler will optimize away tests for "addr < mmap_min_addr".

Signed-off-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/security.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -118,6 +118,7 @@ void reset_security_ops(void);
 extern unsigned long mmap_min_addr;
 extern unsigned long dac_mmap_min_addr;
 #else
+#define mmap_min_addr		0UL
 #define dac_mmap_min_addr	0UL
 #endif
 


