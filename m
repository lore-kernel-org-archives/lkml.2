Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab0LHXbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:31:12 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:55320 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0LHXbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:31:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g8t84tSyEYqjAl2necNV8nthsmK+UhPwtjpaMz6/6l3yrr43ykhVaCuegG5mI0dfqp
         jFY7ROV2KnnuWWNiZ8VvmCkhmPMNu1r31YF15T70dZK98TqY+pRWA2vzs1CIIWAv6wA7
         Xs9qTVagj7ETSD0Vv+sVFvZxCOZsvO6lPmgrI=
Date: Wed, 8 Dec 2010 15:31:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Corentin Chary <corentin.chary@gmail.com>, sedat.dilek@gmail.com,
        Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for December 8
 (drivers/platform/x86/Kconfig:422:error: recursive dependency detected!)
Message-ID: <20101208233101.GA15294@core.coreip.homeip.net>
References: <AANLkTim3FJjVpbjM10kJJhXbONpvGSGQFE+mfGX9pAS6@mail.gmail.com>
 <AANLkTimjVY-6OwRfFUzUbmyacM81M35wf5qDWqAouUYb@mail.gmail.com>
 <1291801990.5992.105.camel@i7.infradead.org>
 <20101208174603.GA7107@core.coreip.homeip.net>
 <20101208135105.a8482d46.randy.dunlap@oracle.com>
 <1291849721.5992.145.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291849721.5992.145.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 08, 2010 at 11:08:39PM +0000, David Woodhouse wrote:
> On Wed, 2010-12-08 at 13:51 -0800, Randy Dunlap wrote:
> > 
> > I dislike select, but reality is that modules do need to select/enable
> > library code and minor features sometimes.
> > 
> > OTOH, where drivers/platform/x86/Kconfig:ACPI_CMPC does "select INPUT"
> > to enable an entire subsystem is wrong and bad IMO. 
> 
> This is just a deficiency in the tools. The correct answer is to fix the
> damn tools, not invent this silly 'select' facility which means much the
> same thing as 'depends on' but is implemented differently.
> 
> As long ago as the mid-1990s, the Nemesis research OS was using a tcl
> xconfig tool based on the Linux one, but which would show you the
> dependencies for an option that was disabled, so you could enable them
> where you needed to. Rather than just hiding the option completely.

Even better tool would allow selecting the needed optios right there,
without the need of moving away from teh current option. And yet better
tool would not even ask user and enable them on its own. Hey, but we
have it! It's called "select".

Seriously, select is dangerous. I wonder if a rule like "One can only
select a symbol whose dependencies are all satisfied by the current
symbol and/or its parents and the symbols they select or depend on"
would not make select safe enough.

-- 
Dmitry
