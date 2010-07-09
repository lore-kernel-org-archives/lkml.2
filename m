Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab0GIPx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:53:56 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:58677 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568Ab0GIPxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:53:44 -0400
Date: Fri, 9 Jul 2010 17:53:12 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Daniel Kiper <dkiper@net-space.pl>,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning to memory hotplug in Xen
Message-ID: <20100709155312.GA8696@router-fw-old.local.net-space.pl>
References: <871vbdr4ey.fsf@basil.nowhere.org> <592dc9b4-d329-4ce3-a5a1-9e6e7044b90c@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592dc9b4-d329-4ce3-a5a1-9e6e7044b90c@default>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 04:12:01PM -0700, Dan Magenheimer wrote:
> > From: Andi Kleen [mailto:andi@firstfloor.org]
> >
> > Daniel Kiper <dkiper@net-space.pl> writes:
> > >
> > > OK, let's go to details. When I was playing with Xen I saw that
> > > ballooning does not give possibility to extend memory over boundary
> > > declared at the start of system. Yes, I know that is by desing
> > however
> > > I thought that it is a limitation which could by very annoing in some
> > > enviroments (I think especially about servers). That is why I decided
> > to
> > > develop some code which remove that one. At the beggining I thought
> > > that it should be replaced by memory hotplyg however after some test
> > > and discussion with Jeremy we decided to link balooning (for memory
> > > removal) with memory hotplug (for extending memory above boundary
> > > declared at the startup of system). Additionaly, we decided to
> > implement
> > > this solution for Linux Xen gustes in all forms (PV/i386,x86_64 and
> > > HVM/i386,x86_64).
> >
> > While you can do that the value is not very large because you
> > could just start the guests with more memory, but ballooned in
> > the first place (so that they don't actually use it)
> >
> > The only advantage of using memory hotadd is that the mem_map doesn't
> > need to be pre-allocated, but that's only a few percent of the memory.
> >
> > So it would only help if you want to add gigantic amounts of memory
> > to a VM (like >20-30x of what it already has).
>
> One can envision a scenario where a cloud customer launches a
> business-critical VM with some reasonably large "maxmem" set,
> balloons up to the max, then finds out it isn't enough after
> all and would like to avoid rebooting.  Or a cloud provider
> might charge for a specific maxmem, but allow the customer
> to increase maxmem if they pay more money.

Dan scenario description is very good (thx). The idea behind this
project was to serve that cases. Maybe some misunderstanding come
from short description of my proposal.

Daniel
