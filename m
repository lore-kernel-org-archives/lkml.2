Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab1HFAIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:08:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39122 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757156Ab1HFAIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:08:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:02:52 2011
Message-Id: <20110806000252.787677814@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:02:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [39/55] powerpc/pseries/hvconsole: Fix dropped console output
In-Reply-To: <20110806000257.GA25498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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
 


