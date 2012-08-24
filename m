Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab2HXRZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:25:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46481 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758445Ab2HXRYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:24:55 -0400
Date: Fri, 24 Aug 2012 13:24:43 -0400
From: Benjamin Poirier <bpoirier@suse.de>
To: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Sacren <sakiwit@gmail.com>, Arnaud Lacombe <lacombar@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Davidlohr Bueso <dave@gnu.org>, Wang YanQing <udknight@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Cheng Renquan <crquan@gmail.com>
Subject: Re: [PATCH v2 0/6] menuconfig: jump to search results
Message-ID: <20120824172443.GA30057@d2.synalogic.ca>
References: <1345748108-12206-1-git-send-email-bpoirier@suse.de>
 <20120824154957.GA5738@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824154957.GA5738@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/08/24 17:49, Borislav Petkov wrote:
> On Thu, Aug 23, 2012 at 02:55:02PM -0400, Benjamin Poirier wrote:
> > This patch series adds "jump to" keys (similar to the cscope interface) to the
> > search results of "make menuconfig" so that we can go directly to the menu
> > entry for a config option after searching for it.
> > 
> > Patches 1-4 implement the basic functionality.
> > Patches 5-6 are an optional improvement.
> > 
> > Changes v1-v2:
> > * add a short description to patches 2 & 3
> > * correct checkpatch style warnings on patch 6
> > 
> > It should be targeted for v3.7
> 
> Ok, did a quick test on -rc3 here. Is it a feature that if I do a
> search, go to the result, then do a search again and go to another
> result from the second search... and do that a couple of times, clicking
> on Exit at the lower part of the menu returns me back to all the
> searches I had done? Much like a stack.
> 
> I mean, I don't mind it that way, it is workable - I'm just asking :).

That's how it's meant, yes. As stated in the log for patch 4:
	menuconfig: Add jump keys to search results
	[...] After exiting this menu, the user is returned to the
	search results where he may jump further in or elsewhere.
... and after exiting the search results the user is returned to the
menu where he was before performing the search. That's the current
behavior.

A likely alternative would be that jumping to a menu entry would exit
the search results, forget the current position in the menus and go to
the new one as if the user had navigated to it from the root menu.

The current mconf.c code structure lends itself much better to the
"stacked" way of doing things. Each navigation to a deeper menu
corresponds to a nested conf() call. To do it the second way we'd have
to add logic to exit these nested conf() calls and redo new ones without
user intervention or change how it's handled altogether.

It seemed to me that choosing one approach over the other was debatable
UI-wise but that the first approach was definitely simpler code-wise.
