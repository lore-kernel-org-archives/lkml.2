Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab2HWMoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 08:44:37 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33038 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab2HWMoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 08:44:32 -0400
Date: Thu, 23 Aug 2012 16:44:27 +0400
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
Message-ID: <20120823124427.GD1992@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823122318.GD29943@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120823122318.GD29943@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 08:23:18AM -0400, J. Bruce Fields wrote:
> On Thu, Aug 23, 2012 at 02:43:23PM +0400, Cyrill Gorcunov wrote:
> > Hi guys,
> > 
> > here is updated version of the fdinfo via procfs series,
> > the changes from previous one are the following
> > 
> >  - fhandle is carried inside inotify mark but this feature
> >    is CONFIG dependent to not bloat the kernel for users
> >    who don't need it
> 
> As Al points out, this doesn't help much: if this feature is something a
> distro will want to provide, then in practice all their users are
> eventually going to end up with it turned on.
> 

Yes, I remember what Al has said, the problem is that this data attached
to inotify mark is not just a couple of bytes but rather about 136 bytes
per mark, and encoding this fhandle will take some cycles on mark creation
as well. Thus when in a sake of c/r we simply have no other way and are
to pay some trade off cost for c/r functionality, i don't think the
regular users (and note that CONFIG_CHECKPOINT_RESTORE is off by default)
should pay same cost for nothing. That's why I made it config dependant.
Again if you still think that making it config-option is a bad idea I'll
rip this symbols off, it's not a problem.

> Could you quantify the cost somehow?
> 

About 136 bytes per inotify mark.

> I wonder if you could get away with something less than MAX_HANDLE_SIZE?
> 128 bytes is the maximum allowable by NFSv4.  In practice I don't think
> any of our filesystems need more than 40 or so right now.

Look, Bruce, I would like to follow the limits we have #define'd in kernel,
because it makes code easier to support. I can #define some limit for
inotify fhandle but what should I print in fdinfo if say there is no
space left in buffer?

	Cyrill
