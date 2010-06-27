Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab0F0Gr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 02:47:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58213 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0F0Grl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 02:47:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dnixcBc9skCYcUwrZlJ0kcl+LHTNAGZX5Zyuph/rD59PNqZczarQRDsfUgDR0CoC71
         +mbyHjINX1uRYKIEli4g35RXm2gg7f7XNLpdT/fec8/oE8ejLuVZz3W+NF6NDlThVhde
         mkrY1sCnhGls3C1WIbEBGQ8z0jMflhuHOq+8U=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/5]security:key.c Fix warning: variable 'key' set but not used 
Date: Sat, 26 Jun 2010 23:47:22 -0700
Message-Id: <1277621246-10960-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
References: <1277621246-10960-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

building with gcc 4.6 I'm getting a warning message:
 CC      security/keys/keyctl.o
security/keys/keyctl.c: In function 'keyctl_describe_key':
security/keys/keyctl.c:472:14: warning: variable 'key' set but not used

After reading key.h I noticed it says this:
NOTE! key_ref_t is a typedef'd pointer to a type that is not actually
defined. This is because we abuse the bottom bit of the reference to carry a
flag to indicate whether the calling process possesses that key in one of
its keyrings.

In this case the safest approach(in my mind) would be to just
mark the integer __unused. Keep in mind though Im not certain 
if this is the right place for this value i.e. will this effect
*instkey or not(please check).

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 security/keys/keyctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 13074b4..d7bb74f 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -469,7 +469,7 @@ long keyctl_describe_key(key_serial_t keyid,
 			 char __user *buffer,
 			 size_t buflen)
 {
-	struct key *key, *instkey;
+	struct key *key __attribute__((unused)), *instkey;
 	key_ref_t key_ref;
 	char *tmpbuf;
 	long ret;
-- 
1.7.1.rc1.21.gf3bd6

