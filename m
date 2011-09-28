Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab1I1WlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:41:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab1I1WlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:33 2011
Message-Id: <20110928220133.850996827@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Venkateswararao=20Jujjuri=20@suse.de,
        "?= <jvrao@linux.vnet.ibm.com>, Eric Van Hensbergen <ericvh@gmail.com>"@suse.de
Subject: [081/244] Fix the size of receive buffer packing onto VirtIO ring.
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: jvrao <jvrao@linux.vnet.ibm.com>

commit 114e6f3a5ede73d5b56e145f04680c61c3dd67c4 upstream.

Signed-off-by: Venkateswararao Jujjuri "<jvrao@linux.vnet.ibm.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/9p/trans_virtio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -367,7 +367,7 @@ req_retry_pinned:
 		in += inp;
 	} else {
 		in = pack_sg_list(chan->sg, out, VIRTQUEUE_NUM, rdata,
-				client->msize);
+				req->rc->capacity);
 	}
 
 	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc);


