Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab0GLOYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 10:24:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab0GLOYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 10:24:14 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: Dynamic Debug broken on 2.6.35-rc3?
Date: Mon, 12 Jul 2010 16:24:16 +0200
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, yehuda@hq.newdream.net
References: <201007011744.19564.trenn@suse.de> <201007091303.08693.trenn@suse.de> <20100709133019.GA2856@redhat.com>
In-Reply-To: <20100709133019.GA2856@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007121624.17543.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it's this one:
commit ff49d74ad383f54041378144ca1a229ee9aeaa59
Author: Yehuda Sadeh <yehuda@hq.newdream.net>
Date:   Sat Jul 3 13:07:35 2010 +1000

which touches same code than Jason's fix does.
Possibly this patch also addresses (only parts of?) this problem?
Jason: Do you mind having a look at the latest git version and review
Yehuda's  and adjust your patch if still necessary.
If Yehuda's patch is fixing this already, we still need it backported for
2.6.34 stable kernel and further?

One question about dynamic debug (unrelated to the mem corruption
issue):
Would it make sense to initialize dynamic debug earlier, somewhen shortly
after __setup is called.
Then a boot param ddebug_enable="xy" could be added.
The param could be in /sys/../control format or just be "all"?
My idea is to be able to track all the pr_debug calls (as) early (as possible) 
at boot up.
One example is ec.c. Currently it is not possible to see the pr_debug messages
when EC accesses are done when the ACPI interpreter is started, there
is no userspace and no sysfs yet.
Same for PCI related pr_debug messages at early PCI(e) initialization time?
Would that be possible or do I miss something?

Thanks,

     Thomas

On Friday 09 July 2010 03:30:19 pm Jason Baron wrote:
> On Fri, Jul 09, 2010 at 01:03:08PM +0200, Thomas Renninger wrote:
> > Hi,
> >
> > I can confirm that this patch fixes the issue for me.
> >
> > On Thursday 08 July 2010 23:53:00 Andrew Morton wrote:
> > > On Thu, 8 Jul 2010 17:39:28 -0400
> > >
> > > Jason Baron <jbaron@redhat.com> wrote:
> > > > Make sure we properly call ddebug_remove_module() when a module fails
> > > > to load. In addition, pass the pointer to the "debug table", to both
> > > > ddebug_add_module(), and ddebug_remove_module() so that we can
> > > > uniquely identify each set of debug statements. In this way even
> > > > modules with the same name can be properly identified and removed.
> > > >
> > > >
> > > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > >
> > > It'd be nice to track the Reported-by:s.  And the Tested-by:s if/when
> > > they arrive.  SighIllDoIt.
> > >
> > > The patch (almost) applies to 2.6.34.  So are we missing a Cc:stable
> > > tag as well?
> >
> > I'll resubmit with some more meta info and will include
> > stable@kernel.org.
> >
> > Could it be that this isn't a regression, but a bug that was always
> > present, but only gets exposed if you add modules with a specific
> > implementation, e.g. specific declarations of functions missing, etc.?
>
> Hi Thomas,
>
> yes, this race has likely been present for a while (i'd have to look at
> specific kernel versions to verify). I suspect its getting exposed now
> due to more usage of this feature, and the proliferation of kernel
> modules...
>
> > I tried to patch this into a 2.6.32.X kernel. While some hunks did not
> > succeed, it looks like an adjusted patch should get submitted for older
> > stable kernels as well?:
>
> if nobody else has done the 2.6.32 stable patch, I can do it, just let
> me know.
>
> thanks again for reporting this to me.
>
> thanks,
>
> -Jason


