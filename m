Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0ITSpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab0ITSpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:45:49 -0400
Date: Mon, 20 Sep 2010 14:44:41 -0400
From: Jason Baron <jbaron@redhat.com>
To: Thomas Renninger <trenn@suse.de>
Cc: bjorn.helgaas@hp.com, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Dynamic Debug: Introduce global fake module param
	module.ddebug - V3
Message-ID: <20100920184441.GA2915@redhat.com>
References: <1284588708-54170-1-git-send-email-trenn@suse.de> <1284588708-54170-2-git-send-email-trenn@suse.de> <20100917195456.GA2825@redhat.com> <201009172352.46631.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009172352.46631.trenn@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 11:52:46PM +0200, Thomas Renninger wrote:
> > Hi,
> > 
> > So i'm wondering if need to support the module.ddebug on the command
> > line?
> Yep, that would make things a bit easier...
> People would e.g. have to use ddebug_query="module pnp +p"  (which 
> already is available with the patch that is queued in linux-next)
> instead of pnp.ddebug. Not that obvious or say user friendly, though.
> 
> > The ddebug_query="module foo +p" format that you introduced does
> > the same thing. 
> No that does not work for real (not built-in) modules. Give it a try...
> The stuff needs to be set up when the module is loaded.
> If you have a real module declared as =m
> You need to call "module foo +p" when the module gets/got loaded.
> But ddebug_query="..." only gets executed once, when
> dynamic debug gets set up, far before any module got loaded.
>  

ok, to be consistent, if passing 'ddebug' as a module parameter when a
module loads, we also need for module.ddebug to work, as that is how
other module parameters work.

> > Also, we can't put those large char[] arrays on the kernel stack. They
> > probably should be global.
> Where exactly, the command line(*args)?
> 

The character arrays, that put COMMAND_LINE_SIZE and DDEBUG_STRING_SIZE
on the stack are too large. Also, ddebug_boot_parse_args() should be
marked as '__init' since it only used on boot.

thanks,

-Jason
