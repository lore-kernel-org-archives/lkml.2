Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0LHBIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:08:01 -0500
Received: from kroah.org ([198.145.64.141]:33896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932893Ab0LHBEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:06 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:48 2010
Message-Id: <20101208005748.850592793@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>, Thomas Meyer <thomas@m3y3r.de>
Subject: [274/289] ext4: fix NULL pointer dereference in print_daily_error_info()
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

commit a1c6c5698d53db4c47a25c3a8d11731a4d7b8370 upstream.

Fix NULL pointer dereference in print_daily_error_info, when
called on unmounted fs (EXT4_SB(sb) returns NULL), by removing error
reporting timer in ext4_put_super.

Google-Bug-Id: 3017663

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -719,6 +719,7 @@ static void ext4_put_super(struct super_
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
+	del_timer(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);


