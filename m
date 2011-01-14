Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1ANJ6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:58:38 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48561 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab1ANJ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:58:33 -0500
Date: Fri, 14 Jan 2011 11:57:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: error in 2.6.37-git10
Message-ID: <20110114095745.GD2476@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D301CA5.503@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D301CA5.503@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 10:51:33AM +0100, Piotr Hosowicz wrote:
> Hello,
> 
> Build failed here:
> 
>   CC [M]  fs/ecryptfs/main.o
> fs/ecryptfs/main.c:144: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or
> ‘__attribute__’ before ‘*’ token
> fs/ecryptfs/main.c: In function ‘ecryptfs_interpose’:
> fs/ecryptfs/main.c:204: error: implicit declaration of function
> ‘ecryptfs_get_inode’
> fs/ecryptfs/main.c:204: warning: initialization makes pointer from
> integer without a cast
> fs/ecryptfs/main.c:206: error: expected ‘)’ before ‘return’
> fs/ecryptfs/main.c:212: error: expected expression before ‘}’ token
> fs/ecryptfs/main.c: In function ‘ecryptfs_mount’:
> fs/ecryptfs/main.c:569: warning: assignment makes pointer from
> integer without a cast

Could you check whether this is enough?

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d3b28ab..d2e71a2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -34,6 +34,7 @@
 #include <linux/pagemap.h>
 #include <linux/key.h>
 #include <linux/parser.h>
+#include <linux/fs.h>
 #include <linux/fs_stack.h>
 #include <linux/slab.h>
 #include "ecryptfs_kernel.h"

-- 
balbi
