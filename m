Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2BFRLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:11:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2BFRLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:11:54 -0500
Date: Mon, 6 Feb 2012 17:11:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Message-ID: <20120206171152.GG23916@ZenIV.linux.org.uk>
References: <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com>
 <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com>
 <20120202012258.GQ23916@ZenIV.linux.org.uk>
 <20120202212400.GR23916@ZenIV.linux.org.uk>
 <CA+55aFzHSv2eHKenVhxnSFMJMXtJCnxD2xu6QjMiMLEGLCZ2uQ@mail.gmail.com>
 <20120203011612.GS23916@ZenIV.linux.org.uk>
 <20120203170825.GX23916@ZenIV.linux.org.uk>
 <1328518244.22240.25.camel@sauron.fi.intel.com>
 <20120206135655.GF23916@ZenIV.linux.org.uk>
 <1328547955.22240.39.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328547955.22240.39.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 07:05:55PM +0200, Artem Bityutskiy wrote:
> On Mon, 2012-02-06 at 13:56 +0000, Al Viro wrote:
> > On Mon, Feb 06, 2012 at 10:50:44AM +0200, Artem Bityutskiy wrote:
> > 
> > > WRT 'sen_nlink()' - I can use it instead of 'drop_nlink()'/'inc_nlink()'
> > > of course. But I do not really see why is this better. E.g.,
> > > 'drop_nlink()' additionally gives me ' WARN_ON()' in case of 'i_nlink'
> > > wrapping.
> > 
> > So does inc_nlink() when you are asking to get from nlink=0 to nlink=1.
> > I.e. on failure exit in your unlink()...
> 
> Indeed! I'll switch to 'clear_nlink(inode)' and 'set_nlink(inode, 1)'
> for those inodes which are being unliked.

Huh?  I thought ubifs allowed link(2)... IOW, i_nlink could've been greater
than 1 when you called ubifs_unlink().
