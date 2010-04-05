Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0DEWSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 18:18:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756735Ab0DEWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 18:18:02 -0400
Date: Mon, 5 Apr 2010 15:17:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, Avi Kivity <avi@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>
Subject: Re: [PATCH] VMware Balloon driver
Message-Id: <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
In-Reply-To: <4BBA5E1C.10706@goop.org>
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
	<20100405142419.2c9bea3d.akpm@linux-foundation.org>
	<4BBA5E1C.10706@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Apr 2010 15:03:08 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 04/05/2010 02:24 PM, Andrew Morton wrote:
> > I think I've forgotten what balloon drivers do.  Are they as nasty a
> > hack as I remember believing them to be?
> >    
> 
> (I haven't looked at Dmitry's patch yet, so this is from the Xen 
> perspective.)
> 
> In the simplest form, they just look like a driver which allocates a 
> pile of pages, and the underlying memory gets returned to the 
> hypervisor.  When you want the memory back, it reattaches memory to the 
> pageframes and releases the memory back to the kernel.  This allows a 
> virtual machine to shrink with respect to its original size.
> 
> Going the other way - expanding beyond the memory allocation - is a bit 
> trickier because you need to get some new page structures from 
> somewhere.   We don't do this in Xen yet, but I've done some experiments 
> with hotplug memory to implement this.  Or a simpler approach is to fake 
> up some reserved E820 ranges to grow into.
> 

Lots of stuff for Dmitry to add to his changelog ;)

> > A summary of what this code sets out to do, and how it does it would be
> > useful.
> >
> > Also please explain the applicability of this driver.  Will xen use it?
> > kvm?  Out-of-tree code?
> >    
> The basic idea of the driver is to allow a guest system to give up 
> memory it isn't using so it can be reused by other virtual machines (or 
> the host itself).

So...  does this differ in any fundamental way from what hibernation
does, via shrink_all_memory()?

