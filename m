Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030618Ab2HWR25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:28:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54720 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2HWR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:28:53 -0400
Date: Thu, 23 Aug 2012 21:28:49 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 0/9] extended fdinfo via procfs series, v7
Message-ID: <20120823172849.GA15362@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823122318.GD29943@fieldses.org>
 <20120823124427.GD1992@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823124427.GD1992@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 04:44:27PM +0400, Cyrill Gorcunov wrote:
> On Thu, Aug 23, 2012 at 08:23:18AM -0400, J. Bruce Fields wrote:
> > On Thu, Aug 23, 2012 at 02:43:23PM +0400, Cyrill Gorcunov wrote:
> > > Hi guys,
> > > 
> > > here is updated version of the fdinfo via procfs series,
> > > the changes from previous one are the following
> > > 
> > >  - fhandle is carried inside inotify mark but this feature
> > >    is CONFIG dependent to not bloat the kernel for users
> > >    who don't need it
> > 
> > As Al points out, this doesn't help much: if this feature is something a
> > distro will want to provide, then in practice all their users are
> > eventually going to end up with it turned on.
> > 
> 
> Yes, I remember what Al has said, the problem is that this data attached
> to inotify mark is not just a couple of bytes but rather about 136 bytes
> per mark, and encoding this fhandle will take some cycles on mark creation
> as well. Thus when in a sake of c/r we simply have no other way and are
> to pay some trade off cost for c/r functionality, i don't think the
> regular users (and note that CONFIG_CHECKPOINT_RESTORE is off by default)
> should pay same cost for nothing. That's why I made it config dependant.
> Again if you still think that making it config-option is a bad idea I'll
> rip this symbols off, it's not a problem.

Btw, Bruce, I forgot to mention that Linus and Andrew asked us to wrap
all code related to c/r we bring in with CONFIG_CHECKPOINT_RESTORE symbol.
So while wrapping show_fdinfo member in file_operations with CONFIG might
be an overhead (as Al and Pavel pointed me) the fhandle in mark is reverse,
a good candidate for CONFIG wrapping I think.

	Cyrill
