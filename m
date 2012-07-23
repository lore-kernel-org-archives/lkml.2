Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab2GWBm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54021 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934Ab2GWBmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:19 -0400
Message-Id: <20120723010652.893346611@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        WANG Cong <amwang@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [ 009/108] kbuild: do not check for ancient modutils tools
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@profusion.mobi>

commit 620c231c7a7f48745094727bb612f6321cfc8844 upstream.

scripts/depmod.sh checks for the output of '-V' expecting that it has
module-init-tools in it. It's a hack to prevent users from using
modutils instead of module-init-tools, that only works with 2.4.x
kernels. This however prints an annoying warning for kmod tool, that is
currently replacing module-init-tools.

Rather than putting another check for kmod's version, just remove it
since users of 2.4.x kernel are unlikely to upgrade to 3.x, and if they
do, let depmod fail in that case because they should know what they are
doing.

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Acked-by: WANG Cong <amwang@redhat.com>
Acked-By: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 scripts/depmod.sh |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/scripts/depmod.sh b/scripts/depmod.sh
index a272356..2ae4817 100755
--- a/scripts/depmod.sh
+++ b/scripts/depmod.sh
@@ -9,12 +9,6 @@ fi
 DEPMOD=$1
 KERNELRELEASE=$2
 
-if ! "$DEPMOD" -V 2>/dev/null | grep -q module-init-tools; then
-	echo "Warning: you may need to install module-init-tools" >&2
-	echo "See http://www.codemonkey.org.uk/docs/post-halloween-2.6.txt" >&2
-	sleep 1
-fi
-
 if ! test -r System.map -a -x "$DEPMOD"; then
 	exit 0
 fi


