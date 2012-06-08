Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab2FHNdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:33:20 -0400
Received: from 8bytes.org ([85.214.48.195]:57363 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2FHNdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:33:19 -0400
Date: Fri, 8 Jun 2012 15:33:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: NFS regression in v3.5-rc1: mount.nfs yells about incorrect
 mount option
Message-ID: <20120608133317.GW12795@8bytes.org>
References: <20120607150456.GO12795@8bytes.org>
 <4FD0C4C2.8020605@netapp.com>
 <20120607155006.GR12795@8bytes.org>
 <4FD0CEB0.9040804@netapp.com>
 <20120608130352.GU12795@8bytes.org>
 <4FD1FC02.2000608@netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD1FC02.2000608@netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jun  8 15:33:17 2012
X-DSPAM-Confidence: 0.9971
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fd1ff1d28381953096197
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 09:20:02AM -0400, Bryan Schumaker wrote:
> On 06/08/2012 09:03 AM, Joerg Roedel wrote:
> > On Thu, Jun 07, 2012 at 11:54:24AM -0400, Bryan Schumaker wrote:
> >> On 06/07/2012 11:50 AM, Joerg Roedel wrote:
> >>> mount -o nfsvers=3 ...
> >>
> >> What about `mount -o vers=4 ...`?  I'm compiling a kernel right now to
> >> see if I can reproduce this, what NFS .config options do you have set?
> >> (`cat .config | grep CONFIG_NFS_` should be good enough).
> > 
> > Okay, I tracked it down somewhat. The problem is that the nfs-version
> > is not set in my case so that data->version in nfs_init_server is 0. The
> > function returns -EPROTONOSUPPORT in this case which causes the mount
> > to fail. The evil commit is db8333519 and reverting it fixes the issue
> > for me. Patch attached.
> 
> Thanks!  I wasn't able to reproduce this on Ubuntu 12.04, so now I'm
> setting up 10.04 to see if that makes a difference.  I'd like to
> understand what's going on (and why my other patch didn't fix this
> problem) before reverting.

Your other patch only touched the nfs4 path, but in my setup nfs3 was in
use. Therefore the patch didn't help. I just figured out that
nfs_fs_mount is shared between nfs23 and nfs4, so the first patch
probably breaks nfs4. I send another one which takes this into account.

Regards,

	Joerg


