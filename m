Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1GUUzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:55:43 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:43662 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752718Ab1GUUzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:55:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=srueAv3r8pWM4SkTjCpghHDv53HryKamHnw31hmMnYZM3Q4pv43pUM/dsFiaZo1svNruesAviOuQYhZjBpPwQG/IFfiPgKCMSnY8pkPDfDL3GoXfHHp0f5NRJmQr6/ti;
Date: Thu, 21 Jul 2011 13:55:37 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Christoph Hellwig <hch@infradead.org>, viro@zeniv.linux.org.uk
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-mm@kvack.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] mm/truncate.c: fix build for CONFIG_BLOCK not enabled
Message-Id: <20110721135537.dbfea947.rdunlap@xenotime.net>
In-Reply-To: <20110718152117.GA8844@infradead.org>
References: <20110718203501.232bd176e83ff65f056366e6@canb.auug.org.au>
	<20110718081816.2106117e.rdunlap@xenotime.net>
	<20110718152117.GA8844@infradead.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error when CONFIG_BLOCK is not enabled by providing a stub
inode_dio_wait() function.

mm/truncate.c:612: error: implicit declaration of function 'inode_dio_wait'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 include/linux/fs.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20110721.orig/include/linux/fs.h
+++ linux-next-20110721/include/linux/fs.h
@@ -2418,6 +2418,10 @@ static inline ssize_t blockdev_direct_IO
 				    offset, nr_segs, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
+#else
+static inline void inode_dio_wait(struct inode *inode)
+{
+}
 #endif
 
 extern const struct file_operations generic_ro_fops;
