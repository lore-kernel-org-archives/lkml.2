Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1ADJwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:52:36 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:53059 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750781Ab1ADJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:52:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAV6Ik15Ldpx/2dsb2JhbACkNXS7e4VKBJAt
Date: Tue, 4 Jan 2011 20:52:31 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 8/8] fs: add i_op->sync_inode
Message-ID: <20110104095231.GB4812@amd>
References: <20101218014634.943276411@kernel.dk>
 <20101218015117.759480620@kernel.dk>
 <20101229151246.GA22033@infradead.org>
 <20110104062725.GD3402@amd>
 <20110104065736.GA8013@infradead.org>
 <20110104080323.GC4090@amd>
 <20110104083132.GA4485@amd>
 <20110104092541.GC2760@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110104092541.GC2760@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:25:41AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 04, 2011 at 07:31:32PM +1100, Nick Piggin wrote:
> > And actually I think it is much better to have sync_inode, which means
> > we'll be able to get rid of commit_metadata (which should be an inode
> > operation anyway, not an export operation which really should deal with
> > exporting filesystems to a non-vfs namespace, not nfsd hacks).
> > 
> > commit_metadata would just be sync_inode with a null range or no data
> > sync flag set.
> 
> As explained in the previous mail it's not just not writing data, it's
> conceptually quite different from fsync.

OK I missed that part about not requiring dirty metadata to be written,
just currently ongoing async operations. But then I don't understand how
it would be used by nfsd, how does nfsd start some async operation on
the inode metadata such that ->commit_metadata would do anything useful
for it?

