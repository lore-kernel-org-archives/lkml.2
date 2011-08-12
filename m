Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1HNQHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:07:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab1HNQH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:29 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:55 2011
Message-Id: <20110812210555.035700004@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [33/90] CIFS: Fix missing a decrement of inFlight value
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Shilovsky <piastryyy@gmail.com>

commit 0193e072268fe62c4b19ad4b05cd0d4b23c43bb9 upstream.

if we failed on getting mid entry in cifs_call_async.

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/transport.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -362,6 +362,8 @@ cifs_call_async(struct TCP_Server_Info *
 	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
+		atomic_dec(&server->inFlight);
+		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
 


