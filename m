Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0LHXuD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:50:03 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55499 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0LHXuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nHPttAeMaH7OfMXj2cx80xYMoFsXexiq434M2m24F8CKq/93XElvnpYCEfkhUG4Rig
         oLqJPBKhFYSUKqyPQICZVvdcXZj0aGAIp9RyThFg/081lxolGW06+yzYw8u7105PTZzZ
         Rf68RKuJW3Bdn8zGIRpaqBC/5AEvQGKv0awuw=
Date: Wed, 8 Dec 2010 15:49:50 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Message-ID: <20101208234950.GB15294@core.coreip.homeip.net>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
 <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
 <1291801990.5992.105.camel@i7.infradead.org>
 <20101208174603.GA7107@core.coreip.homeip.net>
 <20101208135105.a8482d46.randy.dunlap@oracle.com>
 <1291849721.5992.145.camel@i7.infradead.org>
 <20101208233101.GA15294@core.coreip.homeip.net>
 <1291851309.5992.150.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291851309.5992.150.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 11:35:08PM +0000, David Woodhouse wrote:
> On Wed, 2010-12-08 at 15:31 -0800, Dmitry Torokhov wrote:
> > Even better tool would allow selecting the needed optios right there,
> > without the need of moving away from teh current option.
> 
> That's exactly what the Nemesis version of xconfig did, almost 15 years
> ago.
> 
> >  And yet better tool would not even ask user and enable them on its
> > own. Hey, but we have it! It's called "select".
> 
> The tools could do that with 'depends on' too. Why make a distinction?

To allow automatic/manual selection. Sometimes the only answer to
"shoudl it be enabled" is "Yes". I.e. drivers that need polling need
input-polldev support. There is no reason whatsoever to even ask user.

Same thing for platform drivers. "Don't you also want to enable option for
your keyboard and mouse to work? Go do that, you won't regret." "Well,
duh!"

> 
> > Seriously, select is dangerous. I wonder if a rule like "One can only
> > select a symbol whose dependencies are all satisfied by the current
> > symbol and/or its parents and the symbols they select or depend on"
> > would not make select safe enough. 
> 
> "One can only select a symbol which isn't otherwise presented to the
> user as a choice".

Input-polldev _is_ presented as a choice in case user or distro want to
use out of tree driver that depends on it. Does this mean we shoudl
disallow selects on it? I don't think so.

> So things like CONFIG_REED_SOLOMON are fine to be selected, because the
> user would never see it anyway.
> 
> Otherwise, just use depends. And if that's a problem for you, fix the
> damn tools.

Yep, starting with kconfig.

-- 
Dmitry
