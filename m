Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1ECX5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 19:57:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1ECX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 19:57:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=gnTYkZZfaSThXrSSSMXXHobn6PoKbASMScsdHs0rZAY3ImbpSjGfwVs028wT50v031
         evvRgstRPX1OwEQzhPUg==
Date: Tue, 3 May 2011 16:57:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Hutchings <ben@decadent.org.uk>
cc: James Bottomley <James.Bottomley@suse.de>,
        Michael Schmitz <schmitzmic@googlemail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Pekka Enberg <penberg@kernel.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
Subject: Re: [Stable-review] [36/55] [PARISC] slub: fix panic with
 DISCONTIGMEM
In-Reply-To: <20110503231721.GI2268@decadent.org.uk>
Message-ID: <alpine.DEB.2.00.1105031655370.19613@chino.kir.corp.google.com>
References: <20110429185656.051229285@clark.kroah.org> <1304366677.2833.170.camel@localhost> <alpine.DEB.2.00.1105031544240.27795@chino.kir.corp.google.com> <20110503231721.GI2268@decadent.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Ben Hutchings wrote:

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
> don't set the node states to N_NORMAL_MEMORY will break it.  And
> there's no good way to test for that in Kconfig.
> 

Right, I haven't seen a kernel panic from a kernel that still breaks after 
those two patches (the one for parisc and the one for m68k) were merged in 
the slub allocator.  James, if you have such a panic on parisc, please 
post it.

Thanks!
