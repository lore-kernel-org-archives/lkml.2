Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab0IXMSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:18:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab0IXMSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:18:50 -0400
From: Thomas Renninger <trenn@suse.de>
To: Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH 1/4] Dynamic Debug: Introduce global fake module param module.ddebug - V3
Date: Fri, 24 Sep 2010 14:18:33 +0200
User-Agent: KMail/1.9.10
Cc: bjorn.helgaas@hp.com, gregkh@suse.de, linux-kernel@vger.kernel.org
References: <1284588708-54170-1-git-send-email-trenn@suse.de> <201009172352.46631.trenn@suse.de> <20100920184441.GA2915@redhat.com>
In-Reply-To: <20100920184441.GA2915@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009241418.34377.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 September 2010 08:44:41 pm Jason Baron wrote:
> On Fri, Sep 17, 2010 at 11:52:46PM +0200, Thomas Renninger wrote:
> > > Hi,
> > >
> > > So i'm wondering if need to support the module.ddebug on the command
> > > line?
> >
> > Yep, that would make things a bit easier...
> > People would e.g. have to use ddebug_query="module pnp +p"  (which
> > already is available with the patch that is queued in linux-next)
> > instead of pnp.ddebug. Not that obvious or say user friendly, though.
> >
> > > The ddebug_query="module foo +p" format that you introduced does
> > > the same thing.
> >
> > No that does not work for real (not built-in) modules. Give it a try...
> > The stuff needs to be set up when the module is loaded.
> > If you have a real module declared as =m
> > You need to call "module foo +p" when the module gets/got loaded.
> > But ddebug_query="..." only gets executed once, when
> > dynamic debug gets set up, far before any module got loaded.
>
> ok, to be consistent, if passing 'ddebug' as a module parameter when a
> module loads, we also need for module.ddebug to work, as that is how
> other module parameters work.
>
> > > Also, we can't put those large char[] arrays on the kernel stack. They
> > > probably should be global.
> >
> > Where exactly, the command line(*args)?
>
> The character arrays, that put COMMAND_LINE_SIZE
I dynamically malloc (kstrdup) the command line now.

> and DDEBUG_STRING_SIZE 
I reuse an __initdata var I already have for that.

> on the stack are too large. Also, ddebug_boot_parse_args() should be
> marked as '__init' since it only used on boot.
Yep.

I'll repost all 4 patches:
  - The first is the ddebug fake parameter.
  - 2x pnp compile in one namespace
  - minor compile fixups if DEBUGP is defined in kernel/modules.c

Thanks,

       Thomas
