Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1DRQD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:03:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:50938 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1DRQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:03:50 -0400
X-IronPort-AV: E=Sophos;i="4.64,233,1301875200"; 
   d="scan'208";a="5359046"
Subject: RE: [PATCH] xen: cleancache shim to Xen Transcendent Memory
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>, <viro@zeniv.linux.org.uk>,
        <akpm@linux-foundation.org>, <adilger.kernel@dilger.ca>,
        <tytso@mit.edu>, <mfasheh@suse.com>, <jlbec@evilplan.org>,
        <matthew@wil.cx>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>, <ocfs2-devel@oss.oracle.com>,
        <linux-mm@kvack.org>, <hch@infradead.org>, <ngupta@vflare.org>,
        <jeremy@goop.org>, <JBeulich@novell.com>,
        Kurt Hackel <kurt.hackel@oracle.com>, <npiggin@kernel.dk>,
        Dave Mccracken <dave.mccracken@oracle.com>, <riel@redhat.com>,
        <avi@redhat.com>, Konrad Wilk <konrad.wilk@oracle.com>,
        <mel@csn.ul.ie>, <yinghan@google.com>, <gthelen@google.com>,
        <torvalds@linux-foundation.org>
In-Reply-To: <276f7410-ff4d-4a3b-ab9c-fd1b5fe8c952@default>
References: <20110414212002.GA27846@ca-server1.us.oracle.com>
	 <1302904935.22658.9.camel@localhost.localdomain>
	 <5d23c6c4-5d68-4c2e-af24-2a08f592cb8e@default 1303116441.5997.107.camel@zakaz.uk.xensource.com>
	 <276f7410-ff4d-4a3b-ab9c-fd1b5fe8c952@default>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 18 Apr 2011 17:03:47 +0100
Message-ID: <1303142627.5997.125.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 07:12 -0700, Dan Magenheimer wrote:
> > From: Ian Campbell [mailto:Ian.Campbell@eu.citrix.com]
> > > >
> > > > On Thu, 2011-04-14 at 14:20 -0700, Dan Magenheimer wrote:
> > > >
> > > > There's no need to build this into a kernel which doesn't have
> > > > cleancache (or one of the other frontends), is there? I think there
> > > > should be a Kconfig option (even if its not a user visible one)
> > with
> > > > the appropriate depends/selects.
> > >
> > > Yes, you're right.  It should eventually depend on
> > >
> > > CONFIG_CLEANCACHE || CONFIG_FRONTSWAP
> > >
> > > though there's no sense merging this xen cleancache
> > > shim at all unless/until Linus merges cleancache
> > > (and hopefully later some evolution of frontswap).
> > 
> > Cleancache isn't in already? I thought I saw references to it in
> > drivers/staging?
> 
> Linus said he would review it after 2.6.39-rc1 was released,
> but has neither given thumbs up nor thumbs down so I'm
> assuming he didn't have time and it will be reconsidered
> for 2.6.40.  This latest patchset (V8) is updated in linux-next.
> 
> Yes, zcache is in driver/staging and has references to it.
> I guess that proves the chicken comes before the egg...
> or was it vice versa? :-)

Ah, I didn't realise that the relaxations associated with staging
allowed for unsatisfiable (due to the other half being out of tree)
Kconfig items as well.
 
> > > And once cleancache (and/or frontswap) is merged,
> > > there's very little reason NOT to enable one or
> > > both on a Xen guest kernel.
> > 
> > There are software knobs to allow the host- and guest-admin to opt in
> > or out as they desire though, right?
> 
> Definitely.  Both Xen and a Linux guest have runtime
> options, which currently default to off.

Good to know, thanks!

Ian.


