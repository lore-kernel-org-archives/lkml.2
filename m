Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1EHTnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 15:43:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53320 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab1EHTnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 15:43:49 -0400
Date: Sun, 8 May 2011 21:43:16 +0200
From: Borislav Petkov <bp@amd64.org>
To: Greg KH <greg@kroah.com>
Cc: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] EDAC, MCE, AMD: Add hw_inject and cpu sysfs attrs
Message-ID: <20110508194316.GA1070@aftab>
References: <1304614176-7063-1-git-send-email-bp@amd64.org>
 <1304614176-7063-4-git-send-email-bp@amd64.org>
 <20110508164054.GA4199@kroah.com>
 <20110508184911.GA511@aftab>
 <20110508191853.GA10273@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508191853.GA10273@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 08, 2011 at 03:18:53PM -0400, Greg KH wrote:
> > > You forgot to add the proper Documentation/ABI/ files for these new
> > > sysfs files.  Please do that.
> > 
> > Yeah, so those sprang up as a testing module and the final goal is to
> > have all injection done through perf events but it could also be prudent
> > to keep those as a fallback alternative.
> > 
> > I'm thinking something like
> > Documentation/ABI/testing/sysfs-devices-system-edac but looking
> > at Documentation/ABI/README and reading the "testing/" category
> > description, I don't think it applies to those interfaces just yet for
> > the simple reason that they're still changing and I wouldn't want to
> > cast them in stone now.
> > 
> > Can we add them to a "unstable" category instead or maybe delay making
> > the ABI description for now?
> 
> No.  If you add sysfs files to the kernel, you had better be sure that
> they are correct and are what you want to be doing.  Otherwise, don't
> add them.

I cannot be sure right now because this whole RAS thing is being
developed now and we're more or less learning by doing. I don't think
anyone can tell you what we're going to need a year from now on
interfaces for error injection.

> As you really want to do this through perf, just do it through perf.
> Please don't create a user/kernel api that you are not going to want
> to use in the end.

As I said above, it is going to be used as a fallback alternative to the
perf option for systems which cannot do perf. This injection method will
be the fallback.

Also, this whole module is default-N in Kconfig and you have to really
know what you're doing when enabling it.

Which brings me to a much better idea: this whole interface should
actually go to debugfs! This is more or less a debugging module, so
debugfs, doh!

/me slaps himself on the forehead and goes to rework the patches.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
