Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760007Ab2CTNvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:51:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41083 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab2CTNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:51:47 -0400
Date: Tue, 20 Mar 2012 06:51:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ed Okerson <eokerson@quicknet.net>,
        Greg Herlein <gherlein@quicknet.net>,
        "David W. Erhart" <derhart@quicknet.net>,
        John Sellers <jsellers@quicknet.net>,
        Mike Preston <mpreston@quicknet.net>,
        David Huggins-Daines <dhd@cepstral.com>,
        Fabio Ferrari <fabio.ferrari@digitro.com.br>,
        Artis Kugevics <artis@mt.lv>, Daniele Bellucci <bellucda@tiscali.it>
Subject: Re: [PATCH 1/2] drivers/telephony/ixj.c::add_caps(): don't rely on
 undefined behaviour
Message-ID: <20120320135143.GA4535@kroah.com>
References: <alpine.LNX.2.00.1203192332420.9012@swampdragon.chaosbits.net>
 <1332197078.7847.1.camel@joe2Laptop>
 <alpine.LNX.2.00.1203192345020.9012@swampdragon.chaosbits.net>
 <1332198657.7847.7.camel@joe2Laptop>
 <alpine.LNX.2.00.1203200017100.9012@swampdragon.chaosbits.net>
 <1332199784.7847.12.camel@joe2Laptop>
 <alpine.LNX.2.00.1203200034040.9012@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1203200034040.9012@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:40:50AM +0100, Jesper Juhl wrote:
> On Mon, 19 Mar 2012, Joe Perches wrote:
> 
> > On Tue, 2012-03-20 at 00:19 +0100, Jesper Juhl wrote:
> > > On Mon, 19 Mar 2012, Joe Perches wrote:
> > > > On Mon, 2012-03-19 at 23:46 +0100, Jesper Juhl wrote:
> > > > > On Mon, 19 Mar 2012, Joe Perches wrote:
> > > > > > On Mon, 2012-03-19 at 23:37 +0100, Jesper Juhl wrote:
> > > > > > > In drivers/telephony/ixj.c::add_caps() we have several statements like this:
> > > > > > >   	j->caplist[j->caps].handle = j->caps++;
> > > > > > > That's undefined behaviour right there.
> > > > > > telephony has been moved to staging.
> > > > > Since when? Where?
> > > > > In my up-to-date Linus tree with HEAD at 
> > > > > c16fa4f2ad19908a47c63d8fa436a1178438c7e7, that file is is still in 
> > > > > drivers/telephony/, not in staging/...
> > > > > /confused
> > > > In the -next tree.
> > > Ok, seems I've missed that.
> > > > Yes, it's a bug fix, but drivers/telephony is pretty dead.
> > > Dead or not, as long as it's in the tree I think that fixing bugs is 
> > > relevant.
> > > Besides, who knows if/when it'll get ressurrected ;)
> > 
> > Sorry, I didn't mean to suggest it shouldn't
> > be fixed.
> > 
> > I meant that it probably didn't need to be
> > fixed during the merge window or maybe even
> > not backported to stable unless you're sure
> > the order of operations is now done correctly
> > and with no real change in current operation
> > by inspecting the object.  I presume it worked
> > before but it's likely not too many people
> > actually still use this hardware with the
> > current kernel.
> > 
> I never intended to push it for -stable, it probably "works" in its 
> current form with any relevant compiler. I just spotted a bug and wanted 
> to fix it :-)
> If it gets fixed during the merge window or at some other time I don't 
> really care - but I don't see any reason to not just fix it as soon as 
> possible.
> 
> I have no idea how many people still use this hardware with current 
> kernels, but even if just a few do, they deserve to get code that has 
> well-defined behaviour with standards conforming C compilers and not what 
> is currently there that can change with different compilers/different 
> compiler versions.

Then care to send me the patch, against the linux-next tree, so I can
queue it up for the 3.5 merge window?

greg k-h
