Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0LHAgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:36:41 -0500
Received: from kroah.org ([198.145.64.141]:54913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542Ab0LHAez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:34:55 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:06:43 2010
Message-Id: <20101208000643.623647601@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:04:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [40/44] can-bcm: fix minor heap overflow
In-Reply-To: <20101208003205.GA4286@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 0597d1b99fcfc2c0eada09a698f85ed413d4ba84 upstream.

On 64-bit platforms the ASCII representation of a pointer may be up to 17
bytes long. This patch increases the length of the buffer accordingly.

http://marc.info/?l=linux-netdev&m=128872251418192&w=2

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/can/bcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -121,7 +121,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [9]; /* pointer printed in ASCII with \0 */
+	char procname [20]; /* pointer printed in ASCII with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)


