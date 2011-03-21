Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1CUXPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:50 -0400
Received: from kroah.org ([198.145.64.141]:49348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1CUXP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:12 2011
Message-Id: <20110321230712.269067867@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [30/87] Increase OSF partition limit from 8 to 18
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 34d211a2d5df4984a35b18d8ccacbe1d10abb067 upstream.

It turns out that while a maximum of 8 partitions may be what people
"should" have had, you can actually fit up to 18 entries(*) in a sector.

And some people clearly were taking advantage of that, like Michael
Cree, who had ten partitions on one of his OSF disks.

(*) The OSF partition data starts at byte offset 64 in the first sector,
    and the array of 16-byte partition entries start at offset 148 in
    the on-disk partition structure.

Reported-by: Michael Cree <mcree@orcon.net.nz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/partitions/osf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/partitions/osf.c
+++ b/fs/partitions/osf.c
@@ -10,7 +10,7 @@
 #include "check.h"
 #include "osf.h"
 
-#define MAX_OSF_PARTITIONS 8
+#define MAX_OSF_PARTITIONS 18
 
 int osf_partition(struct parsed_partitions *state)
 {


