Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894Ab0HVCC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 22:02:29 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:33705 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab0HVCC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 22:02:27 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>, Neil Brown <neilb@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        adilger@sun.com, corbet@lwn.net, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
In-Reply-To: <m3zkwgqp3c.fsf@linux.vnet.ibm.com>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100820083057.GA10039@infradead.org> <20100820195303.20b17210@notabene> <20100820115135.GQ31363@ZenIV.linux.org.uk> <20100821100900.4b15fe08@notabene> <20100821083024.GB3448@amd> <m3zkwgqp3c.fsf@linux.vnet.ibm.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Sun, 22 Aug 2010 07:32:15 +0530
Message-ID: <m339u7l80o.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Aug 2010 15:12:15 +0530, "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Sat, 21 Aug 2010 18:30:24 +1000, Nick Piggin <npiggin@kernel.dk> wrote:
> > Thanks, I had both of the same concerns as Christoph with API
> > change and exposing symlink fds last time I looked at the patces,
> > actually.
> > 
> > But they can probably be worked around or avoided. I think the more
> > important thing is whether it is worth supporting. This is
> > all restricted to root (or CAP_DAC_READ_SEARCH) only, right, and
> > what exact semantics they want. I would like to see more discussion
> > of what this enables and some results.
> > 
> > For the case of avoiding expensive network revalidations in path name
> > lookup, do we even need to open symlinks? Could the security issues be
> > avoided by always having handle attached to an open fd?
> > 
> 
> For implementing a userspace file server that use handle for
> representing files (like NFS) we would require to have the ability to do
> different file system operations that can operate on symlink to work on
> handle too. 
> 

linkat change to take NULL path name is needed for regular files
also. The file server will get a request to create a link with handle
of oldpath and directory handle of new path and new name.

The changes would also help in the implementation of 9P server in Qemu
for implementing a fast virtualization passthrough file system (aka
VirtFS)

http://thread.gmane.org/gmane.comp.emulators.qemu/68992

-aneesh
