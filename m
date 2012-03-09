Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031517Ab2CITvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:51:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57662 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031498Ab2CITvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:51:36 -0500
Message-Id: <20120309190216.036348196@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Howells <dhowells@redhat.com>,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 13/68] S390: KEYS: Enable the compat keyctl wrapper on s390x
In-Reply-To: <20120309194409.GA2069@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 1d057720609ed052a6371fe1d53300e5e6328e94 upstream.

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
Cc: Carsten Otte <cotte@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -228,6 +228,9 @@ config COMPAT
 config SYSVIPC_COMPAT
 	def_bool y if COMPAT && SYSVIPC
 
+config KEYS_COMPAT
+	def_bool y if COMPAT && KEYS
+
 config AUDIT_ARCH
 	def_bool y
 


