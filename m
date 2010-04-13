Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0DMUyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:54:40 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:45619 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0DMUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=hZZzPCPDiPZcwr4/JtR8fEvDBtp9Md8DypiPhhZBYt8op1XMTxBPaxyOZrOVFgoLdE
         txir5vyQF16tEpVwpCz+6pxJu7w8TJnnJs7VA6g5EE/4OZQ/K0Dx0bR/8Qz/aZxs4gxU
         L7rfy9DXSNdNx21z1mItbo8nncDBbNTMxj2T4=
Date: Tue, 13 Apr 2010 22:54:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sunrpc: Include missing smp_lock.h
Message-ID: <20100413205433.GD5602@nowhere>
References: <20100413152741.4d56be0c.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100413152741.4d56be0c.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 03:27:41PM +1000, Stephen Rothwell wrote:
> Hi "Frédéric,
> 
> After merging the bkl-procfs tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> net/sunrpc/cache.c: In function 'cache_ioctl_procfs':
> net/sunrpc/cache.c:1355: error: implicit declaration of function 'lock_kernel'
> net/sunrpc/cache.c:1359: error: implicit declaration of function 'unlock_kernel'
> 
> Caused by commit 64ef834551d7696f54553d7608eba80a5a800e77 ("procfs: Push
> down the bkl from ioctl").  Forgot to include linux/smp_lock.h?  See
> Documentation/SubmitChecklist Rule #1.
> 
> I have dropped the bkl-procfs tree for today.


Sorry about this.

I have pushed the following fix in the bkl/procfs branch.

Thanks.

---
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Tue Apr 13 22:46:36 2010 +0200

    sunrpc: Include missing smp_lock.h
    
    Now that cache_ioctl_procfs() calls the bkl explicitly, we need to
    include the relevant header as well.
    
    This fixes the following build error:
    
    	net/sunrpc/cache.c: In function 'cache_ioctl_procfs':
    	net/sunrpc/cache.c:1355: error: implicit declaration of function 'lock_kernel'
    	net/sunrpc/cache.c:1359: error: implicit declaration of function 'unlock_kernel'
    
    Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 3212357..59ef938 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -28,6 +28,7 @@
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
+#include <linux/smp_lock.h>
 #include <asm/ioctls.h>
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/cache.h>


