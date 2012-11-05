Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab2KEQ54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 11:57:56 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:15354
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab2KEQ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 11:57:54 -0500
X-IronPort-AV: E=Sophos;i="4.80,715,1344204000"; 
   d="scan'208";a="161450435"
Date: Mon, 5 Nov 2012 17:57:42 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Arnd Bergmann <arnd@arndb.de>
cc: Julia Lawall <julia.lawall@lip6.fr>, walter harms <wharms@bfs.de>,
        kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/misc/kgdbts.c: remove eprintk
In-Reply-To: <201211051626.29317.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1211051754080.1973@hadrien>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <201211042051.58473.arnd@arndb.de> <alpine.DEB.2.02.1211042202240.1960@localhost6.localdomain6> <201211051626.29317.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Arnd Bergmann wrote:

> On Sunday 04 November 2012, Julia Lawall wrote:
> > >
> > > I don't see yet where that KERN_WARNING gets added. Looking at
> > > warn_slowpath_common, there are two or three lines that get printed at
> > > KERN_WARNING level, followed by the format that got passed into WARN(),
> > > which may or may not include a printk level, but I don't see one getting
> > > added.
> >
> > OK, I agree.  There are lots of KERN_WARNINGs, but not on the string that
> > was passed in.  Still, maybe it is not so good to pass a KERN_XXX for some
> > other XXX to WARN.
>
> Given that most users don't pass anything here, and that those that do pass
> something are somewhat inconsistent, could we make the messages always get
> printed at KERN_WARNING level from WARN(), and kill off the instances
> that already pass a level?

OK, I could try proposing that, and if someone doesn't think it is the
right thing to do, they can ignore the patch.

Concretely, KERN_WARNING should be added in the printk called from WARN,
and all KERN information should be removed from the calls?

thanks,
julia
