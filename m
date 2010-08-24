Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0HXKek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:34:40 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54935 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab0HXKej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:34:39 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Nick Piggin <npiggin@kernel.dk>, Neil Brown <neilb@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, adilger@sun.com, corbet@lwn.net,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
In-Reply-To: <20100824072155.GA3948@amd>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083057.GA10039@infradead.org> <20100820195303.20b17210@notabene> <20100820115135.GQ31363@ZenIV.linux.org.uk> <20100821100900.4b15fe08@notabene> <20100821083024.GB3448@amd> <m3zkwgqp3c.fsf@linux.vnet.ibm.com> <20100824072155.GA3948@amd>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 24 Aug 2010 16:04:32 +0530
Message-ID: <m3lj7wjo3r.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 17:21:55 +1000, Nick Piggin <npiggin@kernel.dk> wrote:
> On Sat, Aug 21, 2010 at 03:12:15PM +0530, Aneesh Kumar K. V wrote:
> > On Sat, 21 Aug 2010 18:30:24 +1000, Nick Piggin <npiggin@kernel.dk> wrote:
> > > Thanks, I had both of the same concerns as Christoph with API
> > > change and exposing symlink fds last time I looked at the patces,
> > > actually.
> > > 
> > > But they can probably be worked around or avoided. I think the more
> > > important thing is whether it is worth supporting. This is
> > > all restricted to root (or CAP_DAC_READ_SEARCH) only, right, and
> > > what exact semantics they want. I would like to see more discussion
> > > of what this enables and some results.
> > > 
> > > For the case of avoiding expensive network revalidations in path name
> > > lookup, do we even need to open symlinks? Could the security issues be
> > > avoided by always having handle attached to an open fd?
> > > 
> > 
> > For implementing a userspace file server that use handle for
> > representing files (like NFS) we would require to have the ability to do
> > different file system operations that can operate on symlink to work on
> > handle too. 
> 
> Right. Is this a really important goal, I'm wondering? Is it realistic
> (ie. to be able to remove the nfs server from the kernel)?
> 

The feature is also needed to implement a 9p virtio pass through file
system in Qemu http://thread.gmane.org/gmane.comp.emulators.qemu/68992

-aneesh

