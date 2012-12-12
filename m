Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2LLVBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:01:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55657 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2LLVBy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:01:54 -0500
Date: Wed, 12 Dec 2012 13:01:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roger Pau =?ISO-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen-blkfront: implement safe version of
 llist_for_each_entry
Message-Id: <20121212130152.daf9cf2d.akpm@linux-foundation.org>
In-Reply-To: <50C61653.70107@citrix.com>
References: <1354630913-17287-1-git-send-email-roger.pau@citrix.com>
	<1354630913-17287-2-git-send-email-roger.pau@citrix.com>
	<20121207202003.GA9462@phenom.dumpdata.com>
	<50C5D276.6090009@citrix.com>
	<20121210151533.GE6955@localhost.localdomain>
	<50C61653.70107@citrix.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 18:05:23 +0100
Roger Pau Monné <roger.pau@citrix.com> wrote:

> On 10/12/12 16:15, Konrad Rzeszutek Wilk wrote:
> > On Mon, Dec 10, 2012 at 01:15:50PM +0100, Roger Pau Monné wrote:
> >> On 07/12/12 21:20, Konrad Rzeszutek Wilk wrote:
> >>> On Tue, Dec 04, 2012 at 03:21:53PM +0100, Roger Pau Monne wrote:
> >>>> Implement a safe version of llist_for_each_entry, and use it in
> >>>> blkif_free. Previously grants where freed while iterating the list,
> >>>> which lead to dereferences when trying to fetch the next item.
> >>>
> >>> Looks like xen-blkfront is the only user of this llist_for_each_entry.
> >>>
> >>> Would it be more prudent to put the macro in the llist.h file?
> >>
> >> I'm not able to find out who is the maintainer of llist, should I just
> >> CC it's author?
> > 
> > Sure. I CC-ed akpm here to solicit his input as well. Either way I am
> > OK wit this being in xen-blkfront but it just seems that it could
> > be useful in the llist file since that is where the non-safe version
> > resides.
> 
> I'm going to resend this series with llist_for_each_entry_safe added to
> llist.h in a separated patch. I wouldn't like to delay this series
> because we cannot get llist_for_each_entry_safe added to llist.h, that's
> why I've added it to blkfront in the first place.

Please include that llist.h patch within the xen merge.  It's just a single
hunk and won't cause any disruption.
