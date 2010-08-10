Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0HJMox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:44:53 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35422 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab0HJMos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:44:48 -0400
Date: Tue, 10 Aug 2010 14:44:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Miller <davem@davemloft.net>, willy@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: perf build broke by list_head changes...
Message-ID: <20100810124445.GA14843@merkur.ravnborg.org>
References: <20100809.235746.115919762.davem@davemloft.net> <4C6147DE.9050608@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6147DE.9050608@tilera.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 08:36:46AM -0400, Chris Metcalf wrote:
> On 8/10/2010 2:57 AM, David Miller wrote:
> > Commit:
> >
> > commit de5d9bf6541736dc7ad264d2b5cc99bc1b2ad958
> > Author: Chris Metcalf <cmetcalf@tilera.com>
> > Date:   Fri Jul 2 13:41:14 2010 -0400
> >
> >     Move list types from <linux/list.h> to <linux/types.h>.
> >
> > broke the build of 'perf'.
> >
> > If you move "struct list_head" into types.h, this means perf stops
> > building because it depends upon being able to include linux/list.h
> > from a userland application and at the same time be able to get the
> > basic data types without defining __KERNEL__ or similar.
> >   
> 
> If necessary, it certainly would be easy to move the list.h types to
> follow struct ustat, then bump the #endif up above them with a comment
> about the perf system's use of them.
> 
> I'm confused, though, since <linux/list.h> isn't installed by
> headers_install, so how was perf finding that definition before anyway?

kernel devs usually tell people not to use kernel
headers direct.
But perf does so a lot.

$ cd tools/perf/util; git grep '../../..'
header.h:#include "../../../include/linux/perf_event.h"
include/asm/byteorder.h:#include "../../../../include/linux/swab.h"
include/linux/hash.h:#include "../../../../include/linux/hash.h"
include/linux/list.h:#include "../../../../include/linux/list.h"
include/linux/poison.h:#include "../../../../include/linux/poison.h"
include/linux/rbtree.h:#include "../../../../include/linux/rbtree.h"
parse-events.c:#include "../../../include/linux/hw_breakpoint.h"
parse-events.c: snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
parse-events.c: snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
session.h:#include "../../../include/linux/perf_event.h"
util.h:#include "../../../include/linux/magic.h"
util.h:#include "../../../include/linux/stringify.h"

IMO the patch that moves list_head to types.h is fine.
And perf needs to learn good manner with respect to
kernel headers.

	Sam
