Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710Ab1COM71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:59:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59375 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab1COM7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:59:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the bkl-config tree
Date: Tue, 15 Mar 2011 13:59:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Adamson <andros@netapp.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Dean Hildebrand <dhildeb@us.ibm.com>,
        Fred Isaman <iisaman@citi.umich.edu>, Mike Sager <sager@netapp.com>,
        Fred Isaman <iisaman@netapp.com>,
        Mingyang Guo <guomingyang@nrchpc.ac.cn>,
        Ricardo Labiaga <Ricardo.Labiaga@netapp.com>,
        Tao Guo <guotao@nrchpc.ac.cn>, Benny Halevy <bhalevy@panasas.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
References: <20110315184845.1a411e67.sfr@canb.auug.org.au>
In-Reply-To: <20110315184845.1a411e67.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151359.12569.arnd@arndb.de>
X-Provags-ID: V02:K0:2pebED79HSuBa73il7Z8dVa45ilnkfW/giG1gexSEe2
 Hlma/Wj610s4libbQB/cL0pxX3xyE6nYcKOfT0Dn9KeUXIC6Qx
 oDjhQ7ma4f2FmiY1ZVzUtfGAa1KRZMzXeex0ga/aADAqCj5eYC
 2ygxi8BJbRiZF11YeQoKsX1Dvglwm5/Ao9fgT8+TQaqSY4vBk/
 tJV2wpiQOV/VJtRHZPTVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011, Stephen Rothwell wrote:
> After merging the bkl-config tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/nfs/read.c:21:28: error: linux/smp_lock.h: No such file or directory
> 
> Caused by commit 64419a9b2093 ("NFSv4.1: generic read") from the nfs tree
> interacting with commit 4ba8216cd905 ("BKL: That's all, folks") from the
> bkl-config tree.
> 
> I couldn't see that this include file was needed, so I applied the patch
> below (which Trond could apply to his tree, I am pretty sure).  (I am not
> sure why module.h is included either.)
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 15 Mar 2011 18:37:09 +1100
> Subject: [PATCH] nfs: BKL is no longer needed, so remove the include
> 

The fix is good. I have one patch in bkl-config that removes all instances
of #include <linux/smp_lock.h> treewide. Obviously that doesn't
help where new ones creep in, so we have to eliminate them one
by one.

	Arnd
