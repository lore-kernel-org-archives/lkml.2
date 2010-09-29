Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab0I2MAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:00:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab0I2L76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 07:59:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the bkl-llseek tree with the infiniband tree
Date: Wed, 29 Sep 2010 13:59:47 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org
References: <20100929132035.18e89614.sfr@canb.auug.org.au>
In-Reply-To: <20100929132035.18e89614.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009291359.47476.arnd@arndb.de>
X-Provags-ID: V02:K0:UTtEgf6NEol0rJABae3Gl4YoNUuRLUnoXy79g8EXcBK
 ehAKlQSSywTYlkjqU9Iell+kRMPHketKPe/lr2eToFAGxAAlAO
 s3n6XhHjr1Byrobb6nEF+7p5WQb7hk4Jj7Jl+mA7+7ZvTowbrV
 Lh32Lgs3ZP/ZCD+seU5AcCyjzYSUtyDgpPnN+Qpg5aFjRj3Dot
 oJaWrWEwE3KqtioqxLh7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 September 2010, Stephen Rothwell wrote:
> Today's linux-next merge of the bkl-llseek tree got a conflict in
> drivers/infiniband/hw/cxgb4/device.c between commit
> 9e8d1fa3420f489da8a5da47c026511aa71fa50b ("RDMA/cxgb4: debugfs files for
> dumping active stags") from the infiniband tree and commit
> 9711569d06e7df5f02a943fc4138fb152526e719 ("llseek: automatically
> add .llseek fop") from the bkl-llseek tree.
> 
> The former added a whole new file_operations (and changed some
> context) ... I fixed it up (see below) and can carry the fix as necessary.

Looks fine, thanks!

Steve, Roland:

Would you mind adding an appropriate .llseek method to your file operations
so I can drop the change from my tree?

The default_llseek function is used because the read function can currently
be seeked, but I do not know whether that is intentional. If you don't want
to seek, just make open() call nonseekable_open() and set .llseek to no_llseek.

	Arnd
