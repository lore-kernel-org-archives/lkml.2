Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab1CLBoE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:44:04 -0500
Received: from smtp-out.google.com ([74.125.121.67]:30585 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1CLBoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:44:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=jeK/nZawLV0OKMY4pk3tLKrL5BST3kGCOQskKTGTMKn3OdcsiN7K0GjJCABS8XdHh
	CeMQHxUlFD7jrljYLUzBw==
Subject: [PATCH v2 09/12] x86: Better comments for get_bios_ebda()
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 11 Mar 2011 17:43:42 -0800
Message-ID: <20110312014342.6133.61993.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the comments a bit clearer for get_bios_ebda so that it actually
tells us what it is returning.

Signed-off-by: Mike Waychison <mikew@google.com>
---
 arch/x86/include/asm/bios_ebda.h |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/bios_ebda.h b/arch/x86/include/asm/bios_ebda.h
index 5174cf0..aa6a317 100644
--- a/arch/x86/include/asm/bios_ebda.h
+++ b/arch/x86/include/asm/bios_ebda.h
@@ -4,11 +4,14 @@
 #include <asm/io.h>
 
 /*
- * there is a real-mode segmented pointer pointing to the
- * 4K EBDA area at 0x40E.
+ * Returns physical address of EBDA.  Returns 0 if there is no EBDA.
  */
 static inline unsigned int get_bios_ebda(void)
 {
+	/*
+	 * There is a real-mode segmented pointer pointing to the
+	 * 4K EBDA area at 0x40E.
+	 */
 	unsigned int address = *(unsigned short *)phys_to_virt(0x40E);
 	address <<= 4;
 	return address;	/* 0 means none */

