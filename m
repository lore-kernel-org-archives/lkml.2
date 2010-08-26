Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0HZB26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:28:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55901 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab0HZB2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:28:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 Aug 2010 10:23:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Daniel Kiper <dkiper@net-space.pl>, konrad.wilk@oracle.com,
        stefano.stabellini@eu.citrix.com, linux-mm@kvack.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        v.tolstov@selfip.ru, Dulloor <dulloor@gmail.com>
Subject: Re: [PATCH] GSoC 2010 - Memory hotplug support for Xen guests -
 third fully working version
Message-Id: <20100826102352.9d7bcfd0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C758C12.2020107@goop.org>
References: <20100812012224.GA16479@router-fw-old.local.net-space.pl>
	<4C649535.8050800@goop.org>
	<20100816154444.GA28219@router-fw-old.local.net-space.pl>
	<4C758C12.2020107@goop.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Aug 2010 14:33:06 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> >> 2 requires a deeper understanding of the existing hotplug code.  It
> >> needs to be refactored so that you can use the core hotplug machinery
> >> without enabling the sysfs page-onlining mechanism, while still leaving
> >> it available for physical hotplug.  In the short term, having a boolean
> >> to disable the onlining mechanism is probably the pragmatic solution, so
> >> the balloon code can simply disable it.
> > I think that sysfs should stay intact because it contains some
> > useful information for admins. We should reconsider avaibilty
> > of /sys/devices/system/memory/probe. In physical systems it
> > is available however usage without real hotplug support
> > lead to big crash. I am not sure we should disable probe in Xen.
> > Maybe it is better to stay in sync with standard behavior.
> > Second solution is to prepare an interface (kernel option
> > or only some enable/disable functions) which give possibilty
> > to enable/disable probe interface when it is required.
> 
> My understanding is that on systems with real physical hotplug memory,
> the process is:
> 
>    1. you insert/enable a DIMM or whatever to make the memory
>       electrically active
>    2. the kernel notices this and generates a udev event
>    3. a usermode script sees this and, according to whatever policy it
>       wants to implement, choose to online the memory at some point
> 
> I'm concerned that if we partially implement this but leave "online" as
> a timebomb then existing installs with hotplug scripts in place may poke
> at it - thinking they're dealing with physical hotplug - and cause problems.
> 

IIUC, IBM guys, using LPAR?, does memory hotplug on VM.

The operation is.
	1. tell the region of memory to be added to a userland daemon.
	2. The daemon write 0xXXXXXX > /sys/devices/system/memory/probe
	   (This notifies that memory is added physically.)
	   Here, memory is created.
	3. Then, online memory.

I think VM guys can use similar method rather than simulating phyiscal hotplug.
Then, you don't have to worry about udev etc...
No ?

Thanks,
-Kame

