Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab0HXHWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:22:04 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:56159 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555Ab0HXHWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:22:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANsNc0x5Ld90/2dsb2JhbACgPHK5XoU3BA
Date: Tue, 24 Aug 2010 17:21:55 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Neil Brown <neilb@suse.de>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, adilger@sun.com, corbet@lwn.net,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100824072155.GA3948@amd>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100820083057.GA10039@infradead.org>
 <20100820195303.20b17210@notabene>
 <20100820115135.GQ31363@ZenIV.linux.org.uk>
 <20100821100900.4b15fe08@notabene>
 <20100821083024.GB3448@amd>
 <m3zkwgqp3c.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3zkwgqp3c.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 03:12:15PM +0530, Aneesh Kumar K. V wrote:
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

Right. Is this a really important goal, I'm wondering? Is it realistic
(ie. to be able to remove the nfs server from the kernel)?

