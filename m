Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935534Ab1KJEtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:49:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43064 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935494Ab1KJDcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:32:43 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:24 2011
Message-Id: <20111109212724.044617228@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:29:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [233/262] powerpc/eeh: Fix /proc/ppc64/eeh creation
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>

commit 8feaa43494cee5e938fd5a57b9e9bf1c827e6ccd upstream.

Since commit 188917e183cf9ad0374b571006d0fc6d48a7f447, /proc/ppc64 is a
symlink to /proc/powerpc/. That means that creating /proc/ppc64/eeh will
end up with a unaccessible file, that is not listed under /proc/powerpc/
and, then, not listed under /proc/ppc64/.

Creating /proc/powerpc/eeh fixes that problem and maintain the
compatibility intended with the ppc64 symlink.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/eeh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -1338,7 +1338,7 @@ static const struct file_operations proc
 static int __init eeh_init_proc(void)
 {
 	if (machine_is(pseries))
-		proc_create("ppc64/eeh", 0, NULL, &proc_eeh_operations);
+		proc_create("powerpc/eeh", 0, NULL, &proc_eeh_operations);
 	return 0;
 }
 __initcall(eeh_init_proc);


