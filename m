Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1C3Pz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:55:28 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:59598 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab1C3Pz1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 30 Mar 2011 11:55:27 -0400
Message-Id: <4D936EC40200007800039291@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 30 Mar 2011 16:56:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix interaction of kasprintf() and vsnprintf() when
	 using %pV
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the warning at the top of vsnprintf() gets triggered by
kvasprintf()'s first invocation (with NULL buffer and zero size) of
vsnprintf().

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.39-rc1/lib/vsprintf.c
+++ 2.6.39-rc1-kasprintf-no-warn/lib/vsprintf.c
@@ -898,7 +898,7 @@ char *pointer(const char *fmt, char *buf
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
 	case 'V':
-		return buf + vsnprintf(buf, end - buf,
+		return buf + vsnprintf(buf, end > buf ? end - buf : 0,
 				       ((struct va_format *)ptr)->fmt,
 				       *(((struct va_format *)ptr)->va));
 	case 'K':



