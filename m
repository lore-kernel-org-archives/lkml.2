Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2GaKdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:33:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab2GaKdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:33:40 -0400
Date: Tue, 31 Jul 2012 11:33:36 +0100
From: Mel Gorman <mgorman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: linux-next: manual merge of the akpm tree with the nfs tree
Message-ID: <20120731103336.GN612@suse.de>
References: <20120731142441.0d01100f9d050ec6e479c923@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120731142441.0d01100f9d050ec6e479c923@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 02:24:41PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> net/sunrpc/xprtsock.c between commit 5cf02d09b50b ("nfs: skip commit in
> releasepage if we're freeing memory for fs-related reasons") from the nfs
> tree and commit "nfs: enable swap on NFS" from the akpm tree.
> 
> Just context changes?  I fixed it up (I think - see below) and can carry
> the fix as necessary.

Functionally it looks fine. As you say, it all looks like context
changes. Arguably code like this

current->flags &= ~PF_FSTRANS

could use tsk_restore_flags instead() even though it should never be
necessary as PF_FSTRANS would not be set on function entry. However,
it would set up a depedency between the patch sets that is undesirable.
If both sets get merged then it might make sense as a cleanup to use
tsk_restore_flags() but not until then.

Thanks Stephen.

-- 
Mel Gorman
SUSE Labs
