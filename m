Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0CaAhx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:37:53 -0400
Received: from kroah.org ([198.145.64.141]:48531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab0C3XJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:10 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:58 2010
Message-Id: <20100330224958.030460178@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sesterhenn <eric.sesterhenn@lsexperts.de>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [27/45] ext4: Avoid null pointer dereference when decoding EROFS w/o a journal
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 78f1ddbb498283c2445c11b0dfa666424c301803 upstream.

We need to check to make sure a journal is present before checking the
journal flags in ext4_decode_error().

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -254,7 +254,8 @@ static const char *ext4_decode_error(str
 		errstr = "Out of memory";
 		break;
 	case -EROFS:
-		if (!sb || EXT4_SB(sb)->s_journal->j_flags & JBD2_ABORT)
+		if (!sb || (EXT4_SB(sb)->s_journal &&
+			    EXT4_SB(sb)->s_journal->j_flags & JBD2_ABORT))
 			errstr = "Journal has aborted";
 		else
 			errstr = "Readonly filesystem";


