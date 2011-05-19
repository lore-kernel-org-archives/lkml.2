Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933042Ab1ESXC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:02:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab1ESXCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:02:55 -0400
Date: Thu, 19 May 2011 16:01:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: David Rientjes <rientjes@google.com>, ian.campbell@citrix.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, pasik@iki.fi, dave@linux.vnet.ibm.com,
        wdauchy@gmail.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V3 2/2] mm: Extend memory hotplug API to allow memory
 hotplug in virtual machines
Message-Id: <20110519160143.02163f36.akpm@linux-foundation.org>
In-Reply-To: <20110519204509.GD27202@router-fw-old.local.net-space.pl>
References: <20110517213858.GC30232@router-fw-old.local.net-space.pl>
	<alpine.DEB.2.00.1105182026390.20651@chino.kir.corp.google.com>
	<20110519204509.GD27202@router-fw-old.local.net-space.pl>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 22:45:09 +0200
Daniel Kiper <dkiper@net-space.pl> wrote:

> On Wed, May 18, 2011 at 08:36:02PM -0700, David Rientjes wrote:
> > On Tue, 17 May 2011, Daniel Kiper wrote:
> >
> > > This patch contains online_page_callback and apropriate functions for
> > > setting/restoring online page callbacks. It allows to do some machine
> > > specific tasks during online page stage which is required to implement
> > > memory hotplug in virtual machines. Additionally, __online_page_set_limits(),
> > > __online_page_increment_counters() and __online_page_free() function
> > > was added to ease generic hotplug operation.
> >
> > There are several issues with this.
> >
> > First, this is completely racy and only allows one global callback to be
> > in use at a time without looping, which is probably why you had to pass an
> 
> One callback is allowed by design. Currently I do not see
> any real usage for more than one callback.

I'd suggest that you try using the notifier.h tools here and remove the
restriction.  Sure, we may never use the capability but I expect the
code will look nice and simple and once it's done, it's done.

