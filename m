Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab2HMUhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:37:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2HMUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:23:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 43/82] x86, nops: Missing break resulting in incorrect selection on Intel
Date: Mon, 13 Aug 2012 13:19:19 -0700
Message-Id: <20120813201750.223310171@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit d6250a3f12edb3a86db9598ffeca3de8b4a219e9 upstream.

The Intel case falls through into the generic case which then changes
the values.  For cases like the P6 it doesn't do the right thing so
this seems to be a screwup.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-lww2uirad4skzjlmrm0vru8o@git.kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -219,7 +219,7 @@ void __init arch_init_ideal_nops(void)
 			ideal_nops = intel_nops;
 #endif
 		}
-
+		break;
 	default:
 #ifdef CONFIG_X86_64
 		ideal_nops = k8_nops;


