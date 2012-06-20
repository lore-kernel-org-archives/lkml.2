Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab2FTSXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:23:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53819 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375Ab2FTSXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:23:31 -0400
Message-Id: <20120620173025.310860244@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:31:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [ 51/61] 9p: BUG before corrupting memory
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit 5fcb08befaf57faa1b00e514915c1660252b8c26 upstream.

The BUG_ON() in pack_sg_list() would get triggered only one time after we've
corrupted some memory by sg_set_buf() into an invalid sg buffer.

I'm still working on figuring out why I manage to trigger that bug...

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/9p/trans_virtio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -192,10 +192,10 @@ static int pack_sg_list(struct scatterli
 		s = rest_of_page(data);
 		if (s > count)
 			s = count;
+		BUG_ON(index > limit);
 		sg_set_buf(&sg[index++], data, s);
 		count -= s;
 		data += s;
-		BUG_ON(index > limit);
 	}
 
 	return index-start;


