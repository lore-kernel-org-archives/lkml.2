Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1ECUpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:45:24 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:48834 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab1ECUpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:45:23 -0400
Date: Tue, 3 May 2011 22:44:41 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, wdauchy@gmail.com,
        rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2] xen/balloon: Memory hotplug support for Xen balloon driver
Message-ID: <20110503204441.GC15775@router-fw-old.local.net-space.pl>
References: <20110502220148.GI4623@router-fw-old.local.net-space.pl> <1304440353.30823.73.camel@nimitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304440353.30823.73.camel@nimitz>
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:32:33AM -0700, Dave Hansen wrote:
> On Tue, 2011-05-03 at 00:01 +0200, Daniel Kiper wrote:
> > @@ -448,6 +575,14 @@ static int __init balloon_init(void)
> >         balloon_stats.retry_count = 1;
> >         balloon_stats.max_retry_count = RETRY_UNLIMITED;
> >
> > +#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
> > +       balloon_stats.hotplug_pages = 0;
> > +       balloon_stats.balloon_hotplug = 0;
> > +
> > +       register_online_page_callback(&xen_online_page);
> > +       register_memory_notifier(&xen_memory_nb);
> > +#endif 
>
> This is 100% static, apparently.  XEN_BALLOON can't be a module, so I
> still don't see the point of having the un/register stuff.  

You are right to some extent. However, xen_online_page() is registered
as page onlining function only on Xen hypervisor. On bare metal
generic_online_page() is only valid page onlining function.

Additionally, I think this callback mechanism enable other balloon
implementations (KVM, VMware, ...) to easily integrate with memory
hotplug. If it comes true (I am going to propose relevant solution
maybe with more generic balloon driver for Linux Kernel somewhen;
I have some ideas, however, I must focus on more important issues
for me now) proper page onlining function (for Xen, KVM, ...) should
be registered at boot time or module load/unload (after hypervisor
detection). That is why I am insisting on run time solution.
It is an investment into the future.

Daniel
