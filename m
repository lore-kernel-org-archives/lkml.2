Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab0IWA33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 20:29:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33991 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0IWA31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 20:29:27 -0400
Date: Thu, 23 Sep 2010 10:29:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sage Weil <sage@newdream.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the ceph tree with Linus' tree
Message-Id: <20100923102924.25db6970.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sage,

Today's linux-next merge of the ceph tree got a conflict in
fs/ceph/Kconfig between commit be4f104dfd3b5e3ae262bff607965cfc38027dec
("ceph: select CRYPTO") from Linus' tree and commit
49dde0c8bee346a349862c4a3eddcd58e0d0ae90 ("ceph: factor out libceph from
Ceph file system") from the ceph tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.  (though the adding of "default n" is, I think,
redundant as that is the default anyway).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ceph/Kconfig
index 0fcd264,73a7b31..0000000
--- a/fs/ceph/Kconfig
+++ b/fs/ceph/Kconfig
@@@ -1,9 -1,10 +1,11 @@@
  config CEPH_FS
          tristate "Ceph distributed file system (EXPERIMENTAL)"
  	depends on INET && EXPERIMENTAL
+ 	select CEPH_LIB
  	select LIBCRC32C
  	select CRYPTO_AES
 +	select CRYPTO
+ 	default n
  	help
  	  Choose Y or M here to include support for mounting the
  	  experimental Ceph distributed file system.  Ceph is an extremely
