Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1ECXRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:17:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56971 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab1ECXRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:17:30 -0400
Date: Wed, 4 May 2011 00:17:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        Michael Schmitz <schmitzmic@googlemail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Pekka Enberg <penberg@kernel.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
Subject: Re: [Stable-review] [36/55] [PARISC] slub: fix panic with
 DISCONTIGMEM
Message-ID: <20110503231721.GI2268@decadent.org.uk>
References: <20110429185656.051229285@clark.kroah.org>
 <1304366677.2833.170.camel@localhost>
 <alpine.DEB.2.00.1105031544240.27795@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105031544240.27795@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.i.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 03:46:13PM -0700, David Rientjes wrote:
[...]
> SLUB relies heavily on N_NORMAL_MEMORY, so these two patches fix that 
> allocator but the problem is actually not just isolated to that subsystem; 
> it fixes an issue with anything that uses N_NORMAL_MEMORY.
> 
> The former patch sets the nodes correctly for parisc and Michael's patch 
> sets the nodes correctly for m68k, so it's the same fix for two different 
> previously-broken architectures.

So if I understand you correctly, the Kconfig condition for SLUB is
now wrong - only architectures that use DISCONTIGMEM's fake-NUMA and
don't set the node states to N_NORMAL_MEMORY will break it.  And
there's no good way to test for that in Kconfig.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
