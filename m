Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346Ab2GLWgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34671 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318Ab2GLWf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:35:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 007/187] powerpc: Fix uninitialised error in numa.c
Date: Thu, 12 Jul 2012 15:32:43 -0700
Message-Id: <20120712191522.919684980@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 82b2521d257b5c0efd51821cf5fa306e53bbb6ba upstream.

chroma_defconfig currently gives me this with gcc 4.6:
  arch/powerpc/mm/numa.c:638:13: error: 'dm' may be used uninitialized in this function [-Werror=uninitialized]

It's a bogus warning/error since of_get_drconf_memory() only writes it
anyway.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -635,7 +635,7 @@ static inline int __init read_usm_ranges
  */
 static void __init parse_drconf_memory(struct device_node *memory)
 {
-	const u32 *dm, *usm;
+	const u32 *uninitialized_var(dm), *usm;
 	unsigned int n, rc, ranges, is_kexec_kdump = 0;
 	unsigned long lmb_size, base, size, sz;
 	int nid;


