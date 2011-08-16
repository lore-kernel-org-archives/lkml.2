Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1HPCvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:51:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab1HPCve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:51:34 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Mon Aug 15 19:44:55 2011
Message-Id: <20110816024455.414027266@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 15 Aug 2011 19:43:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [22/26] lguest: allow booting guest with CONFIG_RELOCATABLE=y
In-Reply-To: <20110816024553.GA5631@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit e22a539824e8ddb82c87b4f415165ede82e6ab56 upstream.

The CONFIG_RELOCATABLE code tries to align the unpack destination to
the value of 'kernel_alignment' in the setup_hdr.  If that's 0, it
tries to unpack to address 0, which in fact causes the gunzip code
to call 'error("Out of memory while allocating output buffer")'.

The bootloader (ie. the lguest Launcher in this case) should be doing
setting this field; the normal bzImage is 16M, we can use the same.

Reported-by: Stefanos Geraggelos <sgerag@cslab.ece.ntua.gr>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/virtual/lguest/lguest.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/virtual/lguest/lguest.c
+++ b/Documentation/virtual/lguest/lguest.c
@@ -2008,6 +2008,9 @@ int main(int argc, char *argv[])
 	/* We use a simple helper to copy the arguments separated by spaces. */
 	concat((char *)(boot + 1), argv+optind+2);
 
+	/* Set kernel alignment to 16M (CONFIG_PHYSICAL_ALIGN) */
+	boot->hdr.kernel_alignment = 0x1000000;
+
 	/* Boot protocol version: 2.07 supports the fields for lguest. */
 	boot->hdr.version = 0x207;
 


