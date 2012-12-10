Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab2LJPQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:16:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17117 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2LJPQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:16:11 -0500
Date: Mon, 10 Dec 2012 10:15:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen-blkfront: implement safe version of
 llist_for_each_entry
Message-ID: <20121210151533.GE6955@localhost.localdomain>
References: <1354630913-17287-1-git-send-email-roger.pau@citrix.com>
 <1354630913-17287-2-git-send-email-roger.pau@citrix.com>
 <20121207202003.GA9462@phenom.dumpdata.com>
 <50C5D276.6090009@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50C5D276.6090009@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 01:15:50PM +0100, Roger Pau Monné wrote:
> On 07/12/12 21:20, Konrad Rzeszutek Wilk wrote:
> > On Tue, Dec 04, 2012 at 03:21:53PM +0100, Roger Pau Monne wrote:
> >> Implement a safe version of llist_for_each_entry, and use it in
> >> blkif_free. Previously grants where freed while iterating the list,
> >> which lead to dereferences when trying to fetch the next item.
> > 
> > Looks like xen-blkfront is the only user of this llist_for_each_entry.
> > 
> > Would it be more prudent to put the macro in the llist.h file?
> 
> I'm not able to find out who is the maintainer of llist, should I just
> CC it's author?

Sure. I CC-ed akpm here to solicit his input as well. Either way I am
OK wit this being in xen-blkfront but it just seems that it could
be useful in the llist file since that is where the non-safe version
resides.
> 
