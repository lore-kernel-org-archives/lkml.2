Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab2EVRWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:22:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:45632 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747Ab2EVRWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:22:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102949844"
Subject: Re: [PATCH 2/2] x2apic, cluster: use all the members of one cluster
 specified in the smp_affinity mask for the interrupt desintation
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: agordeev@redhat.com, yinghai@kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gorcunov@openvz.org
Date: Tue, 22 May 2012 10:21:15 -0700
In-Reply-To: <20120522070428.GA15738@gmail.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
	 <20120522070428.GA15738@gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337707275.1997.184.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 09:04 +0200, Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > If the HW implements round-robin interrupt delivery, this 
> > enables multiple cpu's (which are part of the user specified 
> > interrupt smp_affinity mask and belong to the same x2apic 
> > cluster) to service the interrupt.
> 
> Could/should we do something similar for regular APICs as well? 
> They too support masks and LowestPrio delivery - and doing that 
> will increase test coverage rather significantly.

Existing logical flat xapic mode already takes advantage of this today.
And that apic driver allows multiple cpu's to be set in the destination
field allowing round-robin/power-aware interrupt delivery etc depending
on the platform capabilities etc.

So most of the laptops with 8 or less logical cpu's should take
advantage of this today.

For bigger platforms, we use physical xapic mode. Some older kernels
used xapic cluster mode, which allows 4 members in a cluster. With two
HT siblings, that will leave room for only 2 cores. So the benefit will
be limited. And on the multi-socket platforms, x2apic/vt-d will be
available and used for various other reasons too (virtualization etc).

x2apic is available on desktop/laptop models too.

So for legacy xapic, we can use logical flat mode to take advantage of
these HW modes.

thanks,
suresh 



