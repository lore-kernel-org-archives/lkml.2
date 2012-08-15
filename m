Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2HOWG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:06:27 -0400
Received: from fieldses.org ([174.143.236.118]:37835 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2HOWGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:06:25 -0400
Date: Wed, 15 Aug 2012 18:06:23 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>
Subject: Re: [patch 4/8] fs, exportfs: Add export_encode_inode_fh helper
Message-ID: <20120815220622.GA28054@fieldses.org>
References: <20120815092116.700948346@openvz.org>
 <20120815092409.591460800@openvz.org>
 <20120815204546.GC25062@fieldses.org>
 <20120815210237.GF25421@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815210237.GF25421@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 01:02:37AM +0400, Cyrill Gorcunov wrote:
> On Wed, Aug 15, 2012 at 04:45:46PM -0400, J. Bruce Fields wrote:
> > On Wed, Aug 15, 2012 at 01:21:20PM +0400, Cyrill Gorcunov wrote:
> > > To provide fsnotify object inodes being watched without
> > > binding to alphabetical path we need to encode them with
> > > exportfs help. This patch adds a helper which operates
> > > with plain inodes directly.
> > 
> > I don't get it--this seems like a really roundabout way to get inode and
> > generation number, if that's all you want.
> 
> We can re-open the targets via filehandle on restore, this was the idea.
> All this series aimed to achieve the way to restore objects after checkpoit,
> thus we need to provide additional information which would be enough.

For this to work it'll need to be something you can pass to
open_by_handle_at, won't it?

> > On the other hand, if you want a real filehandle then wouldn't you want
> > to e.g. call the filesystem's ->encode_fh() if necessary, as
> > exportfs_encode_fh() does?
> 
> Well, one of the problem I hit when I've been trying to use encode_fh
> is that every new implementation of encode_fh will require some size
> (even unknown) in buffer where encoded data pushed. Correct me please
> if I'm wrong. But with export_encode_inode_fh there is a small buffer
> with pretty known size needed on stack needed for printing data in
> fdinfo.

You can just give encode_fh a too-small data and let it fail if it's not
big enough.

(In practice I think everyone supports NFSv3 filehandles which have a
maximum size of 64 bytes.)

--b.
