Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2C0KZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:25:13 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51985 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707Ab2C0KZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:25:10 -0400
Date: Tue, 27 Mar 2012 13:25:04 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: David Rientjes <rientjes@google.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Arnaud Lacombe <lacombar@gmail.com>, Christoph Lameter <cl@linux.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: randconfig chosing more than one slab allocator
In-Reply-To: <alpine.DEB.2.00.1203111432020.790@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1203271323420.19093@tux.localdomain>
References: <alpine.DEB.2.00.1203041404590.18555@chino.kir.corp.google.com> <alpine.DEB.2.00.1203111432020.790@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012, David Rientjes wrote:
> > Hi folks,
> > 
> > make randconfig seems to allow chosing more than one slab allocator 
> > although they are all part of a choice,endchoice block (and none are 
> > tristate).  The following quickly finds both CONFIG_SLUB and CONFIG_SLOB 
> > enabled:
> > 
> > $ while [ 1 ]; do make randconfig &> /dev/null; if [ $(grep "CONFIG_SL[OU]B=y" .config | wc -l) == 2 ]; then break; fi; done
> > $ grep CONFIG_SL[OU]B=y .config
> > CONFIG_SLUB=y
> > CONFIG_SLOB=y
> 
> Ping on this?

I'm fairly sure this is a kbuild issue and that init/Kconfig is correct.

			Pekka
