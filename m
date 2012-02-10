Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962Ab2BJTNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:13:24 -0500
Received: from mail-1.atlantis.sk ([80.94.52.57]:60995 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759930Ab2BJTNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:13:23 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] fix broken isapnp handling in file2alias
Date: Fri, 10 Feb 2012 20:12:27 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202102012.40943.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling of isapnp module aliases was broken by commit
626596e295d477c0fefa08cd5daa7dd011b1bb2c by changing "isapnp" string to "isa".
The code was then modified by commit
e49ce14150c64b29a8dd211df785576fa19a9858 but this bug remained.

Change the string back to "isapnp".

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -942,7 +942,7 @@ static int do_isapnp_entry(const char *filename,
 		(id->function >> 12) & 0x0f, (id->function >> 8) & 0x0f);
 	return 1;
 }
-ADD_TO_DEVTABLE("isa", struct isapnp_device_id, do_isapnp_entry);
+ADD_TO_DEVTABLE("isapnp", struct isapnp_device_id, do_isapnp_entry);
 
 /*
  * Append a match expression for a single masked hex digit.


-- 
Ondrej Zary
