Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab2E1Dfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:35:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52146 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754121Ab2E1D3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:47 -0400
Message-Id: <20120528031219.003946705@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@zytor.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [ 117/117] x86, relocs: Add jiffies and jiffies_64 to the relative whitelist
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@zytor.com>

commit ea17e7414bc62e8d3bde8d08e3df1d921c518c17 upstream.

The symbol jiffies is created in the linker script as an alias to
jiffies_64.  Unfortunately this is done outside any section, and
apparently GNU ld 2.21 doesn't carry the section with it, so we end up
with an absolute symbol and therefore a broken kernel.

Add jiffies and jiffies_64 to the whitelist.

The most disturbing bit with this discovery is that it shows that we
have had multiple linker bugs in this area crossing multiple
generations, and have been silently building bad kernels for some time.

Link: http://lkml.kernel.org/r/20120524171604.0d98284f3affc643e9714470@canb.auug.org.au
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/tools/relocs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index b8f7c65..b685296 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -71,6 +71,7 @@ static const char * const sym_regex_kernel[S_NSYMTYPES] = {
 	"__(start|stop)_notes|"
 	"__end_rodata|"
 	"__initramfs_start|"
+	"(jiffies|jiffies_64)|"
 	"_end)$"
 };
 


