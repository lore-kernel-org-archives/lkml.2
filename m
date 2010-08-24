Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab0HXHaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:30:10 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:21412 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab0HXHaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:30:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG4Rc0x5Ld90/2dsb2JhbACgPHK5UoU3BA
Date: Tue, 24 Aug 2010 17:29:58 +1000
From: Nick Piggin <npiggin@kernel.dk>
To: Neil Brown <neilb@suse.de>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, adilger@sun.com,
        corbet@lwn.net, hooanon05@yahoo.co.jp, bfields@fieldses.org,
        miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100824072958.GB3948@amd>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100820083057.GA10039@infradead.org>
 <20100820195303.20b17210@notabene>
 <20100820115135.GQ31363@ZenIV.linux.org.uk>
 <20100821100900.4b15fe08@notabene>
 <20100821083024.GB3448@amd>
 <20100823091708.6f03c42b@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823091708.6f03c42b@notabene>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 09:17:08AM +1000, Neil Brown wrote:
> On Sat, 21 Aug 2010 18:30:24 +1000
> Nick Piggin <npiggin@kernel.dk> wrote:
> 
> > Thanks, I had both of the same concerns as Christoph with API
> > change and exposing symlink fds last time I looked at the patces,
> > actually.
> > 
> > But they can probably be worked around or avoided. I think the more
> > important thing is whether it is worth supporting. This is
> > all restricted to root (or CAP_DAC_READ_SEARCH) only, right, and
> > what exact semantics they want. I would like to see more discussion
> > of what this enables and some results.
> 
> They allow a credible user-space implementation of the server for some
> network filesystem protocols such as NFS and apparently 9P.
> 
> > 
> > For the case of avoiding expensive network revalidations in path name
> > lookup, do we even need to open symlinks? Could the security issues be
> > avoided by always having handle attached to an open fd?
> 
> I don't see what you are getting at here... which particular security isses,
> and what fd would you use?

Well the issue that you need escalated privilges to use it. The other
use case for it I understand is Andreas's file-handle-server which
avoids a lot of path lookup costs on non-local filesystems. I'm
wondering is that really useful if it's not availale to unprivileged
users?

> 
> As I understand it there are only two security issues that have been noted.
> 1/ lookup-by-filehandle can bypass any 'search' permission tests on ancestor
>    directories.  I cannot see any way to avoid this except require
>    CAP_DAC_READ_SEARCH
> 2/ Creating a hardlink to an 'fd'  allows a process that was given an 'fd'
>    that it could not have opened itself to prevent that file from being
>    removed (and space reclaimed) by creating a private hardlink.
>    This could be avoided by requiring CAP_DAC_READ_SEARCH for that particular
>    operation (and probably requiring i_nlink > 0 anyway) but that feels like
>    a very special-case restriction.

Just so long as the process could have created a hardlink to the file
otherwise via traditional operations, I think it's OK.

> 
> Was it one of these that you were referring to?

Just the general problem of security and inherent restrictions to using
the syscalls.

