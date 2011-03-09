Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1CIW0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:26:52 -0500
Received: from kroah.org ([198.145.64.141]:40716 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab1CIW0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:26:49 -0500
Date: Wed, 9 Mar 2011 14:26:29 -0800
From: Greg KH <greg@kroah.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, serge.hallyn@canonical.com,
        morgan@kernel.org
Subject: Re: [PATCH -v2] capabilites: allow the application of capability
 limits to usermode helpers
Message-ID: <20110309222629.GB30323@kroah.com>
References: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
 <20110309213813.GA28009@kroah.com>
 <1299708672.17577.42.camel@unknown001a4b0c2895>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299708672.17577.42.camel@unknown001a4b0c2895>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 05:11:12PM -0500, Eric Paris wrote:
> On Wed, 2011-03-09 at 13:38 -0800, Greg KH wrote:
> > > When the kernel launches a usermodehelper it will do so with these as
> > > the bset and pI.
> > 
> > Shouldn't the caller of these functions be the ones dictating the
> > capabilities it should be run with?
> 
> Yes. And no.  It depends what you mean.  The caps of the 'caller' task
> are irrelevant.  If I run ifconfig ipv6 I need CAP_NET_ADMIN but the
> upcall needs CAP_SYS_MODULE.  If I plug in a USB drive there is no
> 'caller' task which makes sense.
> 
> Now if by 'caller' you mean 'call site' then yes, we could probably
> launch usermodehelpers with reduced privileged sets.  We know in the
> code when we are asking to launch modprobe that we are going to need
> CAP_SYS_MODULE and don't need caps like CAP_SYS_RAWIO and CAP_MAC_ADMIN.
> We know when we upcall to hotplug we don't really need any priv, since
> it's another task that is going to do the real work.  So yeah, there
> might be some value in another patch to address this....

Yes, that is what I was referring to.

> But neither solves the problem of being able to eliminate capabilities
> from a machine globally.  In olden times we had a global cap-bound but
> it was dropped in favor of an inheritance from init type mechanism.
> Since kthreads don't inherit from init we still end up with this patch.

I'm not objecting to the patch, or the idea, just want to make sure it
is correct.

thanks,

greg k-h
