Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab2CSX3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 19:29:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59120 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755249Ab2CSX3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 19:29:46 -0400
Message-ID: <1332199784.7847.12.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] drivers/telephony/ixj.c::add_caps(): don't rely on
 undefined behaviour
From: Joe Perches <joe@perches.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ed Okerson <eokerson@quicknet.net>,
        Greg Herlein <gherlein@quicknet.net>,
        "David W. Erhart" <derhart@quicknet.net>,
        John Sellers <jsellers@quicknet.net>,
        Mike Preston <mpreston@quicknet.net>,
        David Huggins-Daines <dhd@cepstral.com>,
        Fabio Ferrari <fabio.ferrari@digitro.com.br>,
        Artis Kugevics <artis@mt.lv>, Daniele Bellucci <bellucda@tiscali.it>
Date: Mon, 19 Mar 2012 16:29:44 -0700
In-Reply-To: <alpine.LNX.2.00.1203200017100.9012@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1203192332420.9012@swampdragon.chaosbits.net>
	 <1332197078.7847.1.camel@joe2Laptop>
	 <alpine.LNX.2.00.1203192345020.9012@swampdragon.chaosbits.net>
	 <1332198657.7847.7.camel@joe2Laptop>
	 <alpine.LNX.2.00.1203200017100.9012@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 00:19 +0100, Jesper Juhl wrote:
> On Mon, 19 Mar 2012, Joe Perches wrote:
> > On Mon, 2012-03-19 at 23:46 +0100, Jesper Juhl wrote:
> > > On Mon, 19 Mar 2012, Joe Perches wrote:
> > > > On Mon, 2012-03-19 at 23:37 +0100, Jesper Juhl wrote:
> > > > > In drivers/telephony/ixj.c::add_caps() we have several statements like this:
> > > > >   	j->caplist[j->caps].handle = j->caps++;
> > > > > That's undefined behaviour right there.
> > > > telephony has been moved to staging.
> > > Since when? Where?
> > > In my up-to-date Linus tree with HEAD at 
> > > c16fa4f2ad19908a47c63d8fa436a1178438c7e7, that file is is still in 
> > > drivers/telephony/, not in staging/...
> > > /confused
> > In the -next tree.
> Ok, seems I've missed that.
> > Yes, it's a bug fix, but drivers/telephony is pretty dead.
> Dead or not, as long as it's in the tree I think that fixing bugs is 
> relevant.
> Besides, who knows if/when it'll get ressurrected ;)

Sorry, I didn't mean to suggest it shouldn't
be fixed.

I meant that it probably didn't need to be
fixed during the merge window or maybe even
not backported to stable unless you're sure
the order of operations is now done correctly
and with no real change in current operation
by inspecting the object.  I presume it worked
before but it's likely not too many people
actually still use this hardware with the
current kernel.


