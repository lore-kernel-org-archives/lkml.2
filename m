Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315Ab2CVPGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 11:06:10 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:44975 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932105Ab2CVPGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 11:06:06 -0400
Date: Thu, 22 Mar 2012 11:06:02 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Message-ID: <20120322150602.GD25897@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322133521.GA25897@thunk.org>
 <1332424585.18717.34.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332424585.18717.34.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 03:56:25PM +0200, Artem Bityutskiy wrote:
> 
> But I wonder, since this is cross-FS story, where I need to first do
> small VFS change (export the variable), then change all file-systems,
> and then remove whole 's_dirt'/'write_supers()' stuff from VFS, how this
> would be handled?

What I'm thinking about doing is pulling the first five patches into
my tree, which includes the VFS change to export the
dirty_writeback_interval variable.  Those patches should be very low
risk, and acceptable at this point (although I'm still going to test
them really hard).

Assuming there are no objections with this, then you'd be able to send
the rest of the patches for each file system to get rid of the super
writeback thread separately; those really should go via each file
system maintainer's separate trees, though.  Ext2 and ext3 changes I'm
willing to carry in the ext4 tree (although Jan does have his own ext3
tree).  However, it would really be inappropriate for me to carry
patches against jfs, xfs, or other non-ext 2/3/4 file systems in my
tree.  It will go much faster if you negotiate with each of the file
system maintainers/development teams directly, instead of trying to
use my tree and me as a middleman.

The one thing that will require some coordination is the patch to
completely remove the super writeback thread altogether, which
obviously can't be applied until we know all of the file systems have
removed their dependency on s_dirt.  That's a pretty trivial patch
that could go in late in the next merge window, or even in -rc2 (with
prior warning given to Linus), once you're sure all of the file
systems have gotten their s_dirt removal patches merged in.

Does that seem reasonable to you?

Best regards,

					- Ted
