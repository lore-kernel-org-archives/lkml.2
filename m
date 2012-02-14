Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864Ab2BNOuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:50:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab2BNOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:50:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] KEYS: Enable the compat keyctl wrapper on s390x
To: keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        dan@danny.cz, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 14 Feb 2012 14:50:22 +0000
Message-ID: <20120214145022.12531.16731.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the compat keyctl wrapper on s390x so that 32-bit s390 userspace can
call the keyctl() syscall.

There's an s390x assembly wrapper that truncates all the register values to
32-bits and this then calls compat_sys_keyctl() - but the latter only exists if
CONFIG_KEYS_COMPAT is enabled, and the s390 Kconfig doesn't enable it.

Without this patch, 32-bit calls to the keyctl() syscall are given an ENOSYS
error:

	[root@devel4 ~]# keyctl show
	Session Keyring
	-3: key inaccessible (Function not implemented)

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: dan@danny.cz
cc: Carsten Otte <cotte@de.ibm.com>
cc: Christian Borntraeger <borntraeger@de.ibm.com>
cc: linux-s390@vger.kernel.org
cc: stable@vger.kernel.org
---

 arch/s390/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index d172758..6d99a5f 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -227,6 +227,9 @@ config COMPAT
 config SYSVIPC_COMPAT
 	def_bool y if COMPAT && SYSVIPC
 
+config KEYS_COMPAT
+	def_bool y if COMPAT && KEYS
+
 config AUDIT_ARCH
 	def_bool y
 

