Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2GWJDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 05:03:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52842 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2GWJDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 05:03:09 -0400
Date: Mon, 23 Jul 2012 10:03:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [git pull] vfs.git; pile 1
Message-ID: <20120723090304.GF31729@ZenIV.linux.org.uk>
References: <20120722100920.GZ31729@ZenIV.linux.org.uk>
 <CA+55aFzG9gzWRLvZMb6RnKua0=RHxBFisYSCVDNhjHBq7oq2yw@mail.gmail.com>
 <20120722202030.GB31729@ZenIV.linux.org.uk>
 <500D0949.9040301@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D0949.9040301@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 11:20:25AM +0300, Boaz Harrosh wrote:
> On 07/22/2012 11:20 PM, Al Viro wrote:
> 
> > I think the least painful solution is this: I've created a new branch
> > (for-linus-2) in there, growing off the parent of merge in nfs.git.
> > I've put the fixup to kern_path_locked() there as a separate commit
> > + stuff that went in for-linus after that point.
> > 
> 
> 
> Does this means that between "kern_path_locked() patch" and it's fixup
> the tree is not bisectable? or is it just an enhancement/simplification?
> 
> Not having any opinion, just wants to know

It is bisectable, all right; lookup_one_len() is OK there (note that
places converted to kern_path_locked() used to use it before the
conversion.  It's just that lookup_one_len() is an overkill - we
have already checked exec permissions on parent and we'd already
calculated the full qstr for last component - both length and hash.
All that is left to do is actual __lookup_hash()...
