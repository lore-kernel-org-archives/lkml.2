Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0JMUqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:46:52 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41673 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0JMUqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=waExhGMA+V+ghdtG7dsO+ImH05h8JhLDTFj8+Z7fDX19Tz+nY7QCkFMfTi1Z7c/hr+
         errzRYZy9Td0siAqalVp9dbVRXSU2+Zxa6hY7Ezje2iZDBqRF41L87L6/Cr6uX86cT9v
         ovTdZH15S9QbYfBcwcrik2lrWH4uiV5Hy3eho=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org
Subject: [patch 1/2] vfs: fix overflow in direct-io subsystem
Date: Wed, 13 Oct 2010 22:45:57 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
Cc: Eric Sandeen <sandeen@redhat.com>, lmcilroy@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010132245.57467.edward.shishkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up overflow (ssize_t->int) in the direct-io subsystem.

Signed-off-by: Edward Shishkin <edward@redhat.com>
---
 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.36-rc7.orig/fs/direct-io.c
+++ linux-2.6.36-rc7/fs/direct-io.c
@@ -218,7 +218,7 @@ static struct page *dio_get_page(struct 
  * filesystems can use it to hold additional state between get_block calls and
  * dio_complete.
  */
-static int dio_complete(struct dio *dio, loff_t offset, int ret, bool is_async)
+static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret, bool is_async)
 {
 	ssize_t transferred = 0;
 
