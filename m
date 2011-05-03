Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1ECXUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:20:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:39615 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab1ECXUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:20:52 -0400
Subject: Re: [Stable-review] [36/55] [PARISC] slub: fix panic with
 DISCONTIGMEM
From: James Bottomley <James.Bottomley@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: David Rientjes <rientjes@google.com>,
        Michael Schmitz <schmitzmic@googlemail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Pekka Enberg <penberg@kernel.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <20110503231721.GI2268@decadent.org.uk>
References: <20110429185656.051229285@clark.kroah.org>
	 <1304366677.2833.170.camel@localhost>
	 <alpine.DEB.2.00.1105031544240.27795@chino.kir.corp.google.com>
	 <20110503231721.GI2268@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 18:20:45 -0500
Message-ID: <1304464845.14015.13.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 00:17 +0100, Ben Hutchings wrote:
> On Tue, May 03, 2011 at 03:46:13PM -0700, David Rientjes wrote:
> [...]
> > SLUB relies heavily on N_NORMAL_MEMORY, so these two patches fix that 
> > allocator but the problem is actually not just isolated to that subsystem; 
> > it fixes an issue with anything that uses N_NORMAL_MEMORY.
> > 
> > The former patch sets the nodes correctly for parisc and Michael's patch 
> > sets the nodes correctly for m68k, so it's the same fix for two different 
> > previously-broken architectures.
> 
> So if I understand you correctly, the Kconfig condition for SLUB is
> now wrong - only architectures that use DISCONTIGMEM's fake-NUMA and
> don't set the node states to N_NORMAL_MEMORY will break it.

No, that's not correct; parisc does all of that and still oopses in SLUB
on range > 0 allocations.

I'm not sure why m68k works ... as far as I can tell, the page_to_nid()
issue should trip them as well.

James


