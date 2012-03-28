Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab2C1HEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:04:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59927 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2C1HEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:04:39 -0400
Date: Wed, 28 Mar 2012 00:04:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>, Christoph Lameter <cl@linux.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: randconfig chosing more than one slab allocator
In-Reply-To: <alpine.LFD.2.02.1203271323420.19093@tux.localdomain>
Message-ID: <alpine.DEB.2.00.1203272359290.16201@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203041404590.18555@chino.kir.corp.google.com> <alpine.DEB.2.00.1203111432020.790@chino.kir.corp.google.com> <alpine.LFD.2.02.1203271323420.19093@tux.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Pekka Enberg wrote:

> > > make randconfig seems to allow chosing more than one slab allocator 
> > > although they are all part of a choice,endchoice block (and none are 
> > > tristate).  The following quickly finds both CONFIG_SLUB and CONFIG_SLOB 
> > > enabled:
> > > 
> > > $ while [ 1 ]; do make randconfig &> /dev/null; if [ $(grep "CONFIG_SL[OU]B=y" .config | wc -l) == 2 ]; then break; fi; done
> > > $ grep CONFIG_SL[OU]B=y .config
> > > CONFIG_SLUB=y
> > > CONFIG_SLOB=y
> > 
> > Ping on this?
> 
> I'm fairly sure this is a kbuild issue and that init/Kconfig is correct.
> 

Right, but it happens because SLOB is only available for CONFIG_EXPERT 
(the CONFIG_EMBEDDED restriction dates back to 81819f0fc828 in May 2007) 
so I was wondering if the kconfig folks would know what's going on without 
having to investigate it myself.
