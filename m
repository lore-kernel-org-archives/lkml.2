Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0ICIwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 04:52:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36296 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0ICIwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 04:52:43 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org
In-reply-to: <20100902213315.GA16004@shell> (message from Valerie Aurora on
	Thu, 2 Sep 2010 17:33:15 -0400)
Subject: Re: [PATCH 5/5] union: hybrid union filesystem prototype
References: <20100826183340.027591901@szeredi.hu> <20100826183507.402136609@szeredi.hu> <20100901214238.GC15849@shell> <E1Or5xN-0001uq-Ob@pomaz-ex.szeredi.hu> <20100902213315.GA16004@shell>
Message-Id: <E1OrS0g-0006Ns-E9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Sep 2010 10:52:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Valerie Aurora wrote:
> Hm, I suspect it's more complicated than this.  I looked at how
> unionfs does it in init_lower_nd() and it requires poking around in
> VFS internal details in the file system implementation.  So unioning
> code is not in the VFS, but VFS code is in the union fs.  Progress?  I
> dunno.

Definitely not progress.

Progress would be if the intents mess would go away.  Which Al's been
working on for what, one, two years?

Until that's cleared up it's pointless to add hacks like that (which
in actual fact don't make much sense anyway, NFS will work fine
without the intents stuff most of the time, only perhaps
suboptimally).

> > "Fortunately" NFS isn't good for a writable layer of a union for other
> > reasons, so this isn't a big concern at the moment.
> 
> It's the long-term effect on the code structure that concerns me more.

Nameidata in any filesystem operation should not be in the long term
design structure (well, in follow_link() it was OK while it was used
recursiveley, now it's flattened out, it would also be cleaner if it
didn't get the nameidata).

Thanks,
Miklos
