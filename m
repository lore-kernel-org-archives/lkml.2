Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab1HDQMj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 12:12:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1HDQMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 12:12:36 -0400
Date: Thu, 4 Aug 2011 12:12:27 -0400
From: Jason Baron <jbaron@redhat.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: bvanassche@acm.org, joe@perches.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
Subject: Re: dynamic_debug: enabled vs FLAGS_PRINT, more filtering tricks.
Message-ID: <20110804161227.GB2462@redhat.com>
References: <CAJfuBxx_cSTuYoJjLkrGX3kYMvgw4Ep+rEL2VDNv-Ti5PB1C4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJfuBxx_cSTuYoJjLkrGX3kYMvgw4Ep+rEL2VDNv-Ti5PB1C4w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 04:04:53PM -0600, Jim Cromie wrote:
> On Mon, Jul 25, 2011 at 3:42 PM, Jim Cromie <jim.cromie@gmail.com> wrote:
> >
> >
> > This patchset extends dynamic-debug facility to allow
> > use of pr_debug() within a loadable module's module_init()
> > function.  Query/rules can be given on the boot-line,
> > and are saved to a pending list if they cannot be applied
> > immediately.  Later, when the module is being loaded, the
> > pending list is scanned, and matching rules are applied.
> > Thus pr_debug() calls in the module's initialization function
> > are active when it is invoked.
> >
> 
> latest version (including fixes for Barts comments) is at
> git://github.com/jimc/linux-2.6.git
> in dyndbg-next branch.
> 
> Is there a reason for having both enabled and _DPRINTK_FLAGS_PRINT  ?
> 
> struct _ddebug {
> ...
> #define _DPRINTK_FLAGS_PRINT   (1<<0)
> ...
> #define _DPRINTK_FLAGS_DEFAULT 0
> 	unsigned int flags:8;
> 	char enabled;
> } __attribute__((aligned(8)));
> 
> as things stand, you can disable print flag with " -p "
> but the call-site may still be enabled, ie [tmlf]
> 
> New ability to clear all flags via  " =_ " handles this, but ..
> 
> OTOH,         if (descriptor.enabled)
> becomes    if (descriptor.flags & _DPRINTK_FLAGS_PRINT)
> 
> then current flags can be filtered to enable/disable previously
> selected callsites.
>   echo " t+p " > /dbg/dynamic_debug/control
> 
> This suggests that unused flags can be named (x,y,z for example)
> then used expressly for marking arbitrary sets of callsites,
> and toggling their enabled/disabled states.
> 
>   echo " x+p " > /dbg/dynamic_debug/control
>   echo " y-p " > /dbg/dynamic_debug/control
>   echo " z+p " > /dbg/dynamic_debug/control

'enabled' is an artifact from when we only had only flag: 'p'. Now, that
we have multiple flags, it probably does make more sense to use 'p' to
control whether there is printing. Since as you pointed out, it makes it
easier to disable things with just " -p".

Thanks,

-Jason
