Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab1HCXbs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:31:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34179 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab1HCXaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:53 2011
Message-Id: <20110803221253.019499416@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [089/102] powerpc/pseries/hvconsole: Fix dropped console output
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 51d33021425e1f905beb4208823146f2fb6517da upstream.

Return -EAGAIN when we get H_BUSY back from the hypervisor. This
makes the hvc console driver retry, avoiding dropped printks.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/hvconsole.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/hvconsole.c
+++ b/arch/powerpc/platforms/pseries/hvconsole.c
@@ -73,7 +73,7 @@ int hvc_put_chars(uint32_t vtermno, cons
 	if (ret == H_SUCCESS)
 		return count;
 	if (ret == H_BUSY)
-		return 0;
+		return -EAGAIN;
 	return -EIO;
 }
 


