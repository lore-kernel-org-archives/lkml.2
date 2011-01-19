Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1ASOIo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 09:08:44 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37554 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1ASOIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 09:08:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=c4JhkB6S5oDIdo3TWzbgLeQYuvki20c1ovhBuPl7Plb0BWoeSArcbfE6QEUC1IOg8Q
         MPgBltbjhJEtNZ3psXUiN+8mdr47Joz/yJLkBwWBc01hEh1I+ilo690yKj8qxctc9CuE
         mMCjBLCfMMemwi6choFyJ5C7Uy4TU7u/zPJ+s=
Message-ID: <4D36F04D.70505@gmail.com>
Date: Wed, 19 Jan 2011 22:08:13 +0800
From: Liuwenyi <qingshenlwy@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: strongzgy@gmail.com, onlyflyer@gmail.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, ak@linux.intel.com,
        akpm@linux-foundation.org, miaox@cn.fujitsu.com, josef@redhat.com,
        chris.mason@oracle.com, Yang Ruirui <ruirui.r.yang@tieto.com>,
        meego-kernel@meego.com, qingshenlwy@gmail.com
Subject: [PATCH] Avoid a NULL pointer in btrfs
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Yang Ruirui's mail, the btrfs will create a oops. This is caused by a
null pointer in test_range_bit() while lock the spinlock.

So, It is necessary to add a pointer check into test_range_bit()

---
Signed-off-by: Liu Wenyi <qingshenlwy@gmail.com>

---
fs/btrfs/extent_io.c | 3 +++
1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 5e7a94d..0da42b5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1553,6 +1553,9 @@ int test_range_bit(struct extent_io_tree *tree,
u64 start, u64 end,
struct rb_node *node;
int bitset = 0;

+ if (tree == NULL)
+ return bitset;
+
spin_lock(&tree->lock);
if (cached && cached->tree && cached->start == start)
node = &cached->rb_node;
-- 
1.7.3.3



---
Best Regards,
Liu Wenyi
