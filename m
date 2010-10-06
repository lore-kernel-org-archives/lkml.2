Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0JFVvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:51:40 -0400
Received: from kroah.org ([198.145.64.141]:57392 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756030Ab0JFVvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:51:39 -0400
Date: Wed, 6 Oct 2010 14:51:02 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Renninger <trenn@suse.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, bjorn.helgaas@hp.com,
        jbaron@redhat.com
Subject: Re: [PATCH 1/4] Dynamic Debug: Introduce global fake module param
 module.ddebug - V4
Message-ID: <20101006215102.GB3440@kroah.com>
References: <20100920184441.GA2915@redhat.com>
 <1285331311-21753-2-git-send-email-trenn@suse.de>
 <20101006211604.GA2093@kroah.com>
 <201010062340.53041.trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201010062340.53041.trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 11:40:52PM +0200, Thomas Renninger wrote:
> On Wednesday 06 October 2010 11:16:04 pm Greg KH wrote:
> > On Fri, Sep 24, 2010 at 02:28:28PM +0200, Thomas Renninger wrote:
> > > Dynamic Debug allows enabling of pr_debug and dev_dbg messages at
> > > runtime. This is controlled via /sys/kernel/debug/dynamic_debug/control.
> > > One major drawback is that the whole initialization of a module cannot be
> > > tracked, because ddebug is only aware of debug strings of loaded modules.
> > > But this is the most interesting part...
> > >
> > > This patch introduces a fake module parameter module.ddebug(not shown in
> > > /sys/module/*/parameters, thus it does not use any resources/memory).
> > >
> > > If a module passes ddebug as a module parameter (e.g. via module.ddebug
> > > kernel boot param or via "modprobe module ddebug"), all debug strings of
> > > this module get activated by issuing "module module_name +p" internally
> > > (not via sysfs) when the module gets loaded.
> > >
> > > Possible enhancements for the future if ddebug might get extended with
> > > further flags:
> > > module.ddebug=flags
> > > Then module.ddebug="p" would be the same as module.ddebug, but if there
> > > is a "x" ddebug flag added, one could pass:
> > > module.ddebug="xp"
> > > which would result in such a dynamic debug query:
> > > module module_name +xp
> > >
> > > Modules must not use "ddebug" as module parameter or it will get ignored.
> > > If it's tried, a warning will show up at module load time that it will
> > > get ignored (only works for not built-in modules).
> > >
> > > Tested with (additional added pr_debug messages):
> > > options hp-wmi ddebug
> > > in modprobe.conf
> > > -> works and pr_debug messages issued at module initialization time show
> > > up. Also "p" flag gets set for the whole hp-wmi module:
> > > grep hp-wmi /sys/../dynamic_debug/control
> > > also tested with compiled-in modules, e.g. pnp.ddebug and an additional
> > > patch later in the patch series which instruments pnp code to work with
> > > ddebug.
> >
> > I don't think you actually built this patch, as it dies:
> > kernel/params.c: In function ‘parse_one’:
> > kernel/params.c:114:2: error: ‘tmp’ undeclared (first use in this function)
> > kernel/params.c:114:2: note: each undeclared identifier is reported only
> > once for each function it appears in kernel/params.c: In function
> > ‘destroy_params’:
> > kernel/params.c:726:8: warning: unused variable ‘tmp’
> Strange, I added them to the latest SUSE factory kernel already and I didn't 
> do much more than copying (and slightly adjusting?).
> 
> Can you give me a pointer to your git tree and branch you want the
> patches based on, iirc I based them on latest Linus master branch.

Try them on top of linux-next, which has my patches in it.

Or use my quilt tree, which is on kernel.org (and in the MAINTAINERS
file.)

thanks,

greg k-h
