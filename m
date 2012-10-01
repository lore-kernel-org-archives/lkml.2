Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2JABpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 21:45:08 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:35357 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751496Ab2JABpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 21:45:06 -0400
Message-ID: <5068F597.9020403@xenotime.net>
Date: Sun, 30 Sep 2012 18:44:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH -next] bluetooth: fix printk format warnings
References: <20120928165112.6b0f5328b72428799c3f995d@canb.auug.org.au>
In-Reply-To: <20120928165112.6b0f5328b72428799c3f995d@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warnings in net/bluetooth/:

net/bluetooth/hci_event.c:886:3: warning: format '%ld' expects type 'long int', but argument 2 has type 'size_t'
net/bluetooth/hci_event.c:886:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'size_t'
net/bluetooth/a2mp.c:386:2: warning: format '%lu' expects type 'long unsigned int', but argument 4 has type 'unsigned int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
M:	Marcel Holtmann <marcel@holtmann.org>
M:	Gustavo Padovan <gustavo@padovan.org>
M:	Johan Hedberg <johan.hedberg@gmail.com>
L:	linux-bluetooth@vger.kernel.org
---
 net/bluetooth/a2mp.c      |    2 +-
 net/bluetooth/hci_event.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20120928.orig/net/bluetooth/a2mp.c
+++ linux-next-20120928/net/bluetooth/a2mp.c
@@ -383,7 +383,7 @@ static int a2mp_getampassoc_rsp(struct a
 	if (len < sizeof(*rsp))
 		return -EINVAL;
 
-	BT_DBG("id %d status 0x%2.2x assoc len %lu", rsp->id, rsp->status,
+	BT_DBG("id %d status 0x%2.2x assoc len %zu", rsp->id, rsp->status,
 	       len - sizeof(*rsp));
 
 	if (rsp->status)
--- linux-next-20120928.orig/net/bluetooth/hci_event.c
+++ linux-next-20120928/net/bluetooth/hci_event.c
@@ -883,7 +883,7 @@ static void hci_cc_read_local_amp_assoc(
 	rem_len = __le16_to_cpu(rp->rem_len);
 
 	if (rem_len > frag_len) {
-		BT_DBG("frag_len %ld rem_len %ld", frag_len, rem_len);
+		BT_DBG("frag_len %zu rem_len %zu", frag_len, rem_len);
 
 		memcpy(assoc->data + assoc->offset, rp->frag, frag_len);
 		assoc->offset += frag_len;
