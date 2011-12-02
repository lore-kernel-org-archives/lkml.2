Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1LBTos (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:44:48 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42423 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1LBToq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:44:46 -0500
Date: Fri, 2 Dec 2011 14:43:09 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Christoph Lameter <cl@linux.com>, "Alex, Shi" <alex.shi@intel.com>,
        Dave Airlie <airlied@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>, tj@kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
Message-ID: <20111202194309.GA12057@homer.localdomain>
References: <20111121080554.GB1625@x4.trippels.de>
 <20111121082445.GD1625@x4.trippels.de>
 <1321866988.2552.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121131531.GA1679@x4.trippels.de>
 <1321884966.10470.2.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20111121153621.GA1678@x4.trippels.de>
 <20111123160353.GA1673@x4.trippels.de>
 <alpine.DEB.2.00.1111231004490.17317@router.home>
 <20111124085040.GA1677@x4.trippels.de>
 <20111201084437.GA1529@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201084437.GA1529@x4.trippels.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 09:44:37AM +0100, Markus Trippelsdorf wrote:
> On 2011.11.24 at 09:50 +0100, Markus Trippelsdorf wrote:
> > On 2011.11.23 at 10:06 -0600, Christoph Lameter wrote:
> > > On Wed, 23 Nov 2011, Markus Trippelsdorf wrote:
> > > 
> > > > > FIX idr_layer_cache: Marking all objects used
> > > >
> > > > Yesterday I couldn't reproduce the issue at all. But today I've hit
> > > > exactly the same spot again. (CCing the drm list)
> > > 
> > > Well this is looks like write after free.
> > > 
> > > > =============================================================================
> > > > BUG idr_layer_cache: Poison overwritten
> > > > -----------------------------------------------------------------------------
> > > > Object ffff8802156487c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > > Object ffff8802156487d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > > Object ffff8802156487e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > > Object ffff8802156487f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > > Object ffff880215648800: 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ....kkkkkkkkkkkk
> > > > Object ffff880215648810: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > 
> > > And its an integer sized write of 0. If you look at the struct definition
> > > and lookup the offset you should be able to locate the field that
> > > was modified.
> 
> It also happens with CONFIG_SLAB. 
> (If someone wants to reproduce the issue, just run a kexec boot loop and
> the bug will occur after a few (~10) iterations.)
> 

Can you provide the kexec command line you are using and full kernel
log (mostly interested in kernel option).

Cheers,
Jerome
