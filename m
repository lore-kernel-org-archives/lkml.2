Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab0ICMbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 08:31:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54809 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757939Ab0ICMba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 08:31:30 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
In-reply-to: <20100902214215.GB16004@shell> (message from Valerie Aurora on
	Thu, 2 Sep 2010 17:42:15 -0400)
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu> <20100826183507.402136609@szeredi.hu> <20100902214215.GB16004@shell>
Message-Id: <E1OrVQR-0007Ds-MY@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Sep 2010 14:31:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Valerie Aurora wrote:
> > Missing:
> > 
> >  - upgrade credentials for copy-up
> >  - ensure that filesystems part of the union are not modified outside
> >    the union
> 
> Just a note that the infrastructure I wrote to do this last bullet
> point for union mounts (hard read-only count plus mount checks) is
> completely compatible with hybrid union fs.

Thanks.

I've used some infrastructure (like parts of the copy up code) from
union mounts.

One way to generalize the read-only counts infrastructure is not to
require MS_RDONLY on the superblock, but count the number of
read-write mounts of the sb.  If it's zero then that's equivalent to
MS_RDONLY.

For the writable layer the same can be used, except the overlay
filesystem can get a single private read-write mount.  This means that
the upper layer can also be mounted multiple times, but cannot be part
of other unions and cannot be mounted read write to userspace.

Thanks,
Miklos
