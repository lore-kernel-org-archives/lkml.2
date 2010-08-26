Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0HZQpY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:45:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0HZQpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:45:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Alpha: Fix a missing comma in sys_osf_statfs()
To: hch@lst.de, torvalds@osdl.org, akpm@linux-foundation.com
Cc: viro@zeniv.linux.org.uk, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Aug 2010 17:44:35 +0100
Message-ID: <20100826164435.28668.25355.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a comma that got accidentally deleted from sys_osf_statfs() leading to the
following warning:

	arch/alpha/kernel/osf_sys.c: In function 'SYSC_osf_statfs':
	arch/alpha/kernel/osf_sys.c:255: error: syntax error before 'buffer'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/kernel/osf_sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index fb58150..5d1e6d6 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -252,7 +252,7 @@ SYSCALL_DEFINE3(osf_statfs, const char __user *, pathname,
 
 	retval = user_path(pathname, &path);
 	if (!retval) {
-		retval = do_osf_statfs(&path buffer, bufsiz);
+		retval = do_osf_statfs(&path, buffer, bufsiz);
 		path_put(&path);
 	}
 	return retval;

