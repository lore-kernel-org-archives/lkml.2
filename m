Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab1LEOrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:47:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266Ab1LEOrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:47:48 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Jim Cromie <jim.cromie@gmail.com>
Subject: Re: [PATCH 19/25] pnp: if CONFIG_DYNAMIC_DEBUG, use pnp.ddebug instead of pnp.debug
Date: Mon, 5 Dec 2011 15:47:42 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop; KDE/4.6.0; x86_64; ; )
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com> <201112011215.21146.trenn@suse.de> <CAJfuBxzF7ScsQrrh4PYo5p0VQ1h=1EYTyanoVkRmwcwWRFimkw@mail.gmail.com>
In-Reply-To: <CAJfuBxzF7ScsQrrh4PYo5p0VQ1h=1EYTyanoVkRmwcwWRFimkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112051547.43298.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 05, 2011 06:42:42 AM Jim Cromie wrote:
> 2011/12/1 Thomas Renninger <trenn@suse.de>:
> > On Wednesday 30 November 2011 20:56:48 jim.cromie@gmail.com wrote:
> >> From: Jim Cromie <jim.cromie@gmail.com>
> >>
> >> resubmit of https://lkml.org/lkml/2010/9/15/398
> >>
> >> This allows usage of generic pnp.ddebug debug parameter instead of
> >> pnp.debug PNP specific parameter.
> 
> > It depends on what you compile in which pnp debug parameter one has to use
> > and both are doing more or less the same?
> >
> > We could add two pnp parameters in !defined(CONFIG_DYNAMIC_DEBUG) case:
> >  - deprecate pnp.debug by a message:
> >    "pnp.debug deprecated, use pnp.ddebug" instead
> 
> Just to be clear, this patch (yours) does this deprecation.
> 
> >  - pnp.ddebug doing what pnp.debug is doing currently
> 
> FWIW, the patch after this changes the name .ddebug to .dyndbg.
> 
> Why is this better than just fixing kernel-parameters to
> advise using dyndbg directly, and skipping the indirection ?
With this patch you'd have pnp.debug and pnp.dyndbg essentially doing
the same (from what I can see),
but you'd either have to use the one or the other, depending
on what is compiled in.

It's not a big deal, but imo it would be nice to have one pnp debug
option which would always work.

This could look like this (not even compile tested):

#if !defined(CONFIG_DYNAMIC_DEBUG)
static int __init pnp_debug_setup(char *__unused)
{
     pnp_debug = 1;
}
__setup("pnp.dyndbg", pnp_debug_setup);

static int __init pnp_old_debug_setup(char *__unused)
{
     printk(KERN_INFO "pnp.debug is deprecated, use pnp.dyndbg instead\n");
}
__setup("pnp.debug", pnp_old_debug_setup);
#endif


As said, not a big deal. Maybe nicer, not sure.

    Thomas
