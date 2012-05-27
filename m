Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934224Ab2E0BYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:24:08 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934169Ab2E0BUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:20:06 -0400
Message-Id: <20120527002523.810022490@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:24 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Rothwell <sfr@canb.auug.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 78/91] x86, relocs: Add jiffies and jiffies_64 to the relative whitelist
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/tools/relocs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -71,6 +71,7 @@ static const char * const sym_regex_kern
 	"__(start|stop)_notes|"
 	"__end_rodata|"
 	"__initramfs_start|"
+	"(jiffies|jiffies_64)|"
 	"_end)$"
 };
 


