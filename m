Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab0CRRUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:20:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:37682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab0CRRUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:20:51 -0400
Date: Thu, 18 Mar 2010 10:20:24 -0700
From: Greg KH <gregkh@suse.de>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Torokhov <dtor@mail.ru>, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [RFC/PATCH] platform_bus: allow custom extensions to system PM
 methods
Message-ID: <20100318172024.GA1675@suse.de>
References: <1268867896-7616-1-git-send-email-khilman@deeprootsystems.com>
 <20100317234414.GA23319@suse.de>
 <87bpellg9p.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpellg9p.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 09:57:06AM -0700, Kevin Hilman wrote:
> Greg KH <gregkh@suse.de> writes:
> 
> > On Wed, Mar 17, 2010 at 04:18:15PM -0700, Kevin Hilman wrote:
> >> When runtime PM for platform_bus was added, it allowed for platforms
> >> to customize the runtime PM methods since they are defined as weak
> >> symbols.
> >> 
> >> This patch allows platforms to also extend the system PM methods with
> >> custom hooks so runtime PM and system PM extensions can be managed
> >> together by custom platform-specific code.
> >
> > Wow, that's scary, I didn't realize that was done for the runtime stuff.
> >
> > What would you be replacing these functions with for your platform that
> > would require it to be in arch-specific code?
> 
> I'm basically copying the existing functions and extending them with
> platform-specific code to manage device clocks and other PM HW state.
> IOW, I still call the drivers PM methods, but also take care of some
> platform specific PM HW management.  This is just like the runtime PM
> hooks: platform-specific code + calling drivers runtime PM methods.
> 
> On my platform (TI OMAP), the code to handle device PM is common for
> all devices, so for runtime PM, I'm taking care of it at the bus
> level.  At the hardware level, there's really no difference between
> runtime and system PM, so I want to take advantage of the same
> platform specific code for system PM
> 
> Initially, rather than making the system PM methods themselves weak, I
> added some weak hooks that could be overridden instead (see test patch
> below).  The problem with that is that it is not as flexible if you
> want to run some custom code before and/or after calling the drivers
> PM methods.  To be more flexible, using this approach, we'd probably
> need pre- and post- hooks to be used before and after the driver's PM
> methods are called.  Rather than add all these hooks, I decided it was
> cleaner to just allow override of the primary methods themselves,
> which parallels the runtime PM approach.

Ok, that sounds reasonable for now.  I'll queue it up for .35.

thanks,

greg k-h
