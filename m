Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab2LQNwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:52:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961Ab2LQNw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:52:29 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 1/2] keys: Fix unreachable code
To: torvalds@linux-foundation.com
From: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        jmorris@namei.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Dec 2012 13:15:23 +0000
Message-ID: <20121217131523.2974.74337.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

We set ret to NULL then test it. Remove the bogus test

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/keys/process_keys.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index 58dfe08..20e4bf5 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -367,8 +367,6 @@ key_ref_t search_my_process_keyrings(struct key_type *type,
 
 		switch (PTR_ERR(key_ref)) {
 		case -EAGAIN: /* no key */
-			if (ret)
-				break;
 		case -ENOKEY: /* negative key */
 			ret = key_ref;
 			break;

