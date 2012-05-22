Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2EVRj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:39:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42916 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab2EVRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:39:27 -0400
Date: Tue, 22 May 2012 21:39:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, agordeev@redhat.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/2] x2apic, cluster: use all the members of one cluster
 specified in the smp_affinity mask for the interrupt desintation
Message-ID: <20120522173922.GC1442@moon>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
 <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
 <20120522070428.GA15738@gmail.com>
 <1337707275.1997.184.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337707275.1997.184.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:21:15AM -0700, Suresh Siddha wrote:
> On Tue, 2012-05-22 at 09:04 +0200, Ingo Molnar wrote:
> > * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> > 
> > > If the HW implements round-robin interrupt delivery, this 
> > > enables multiple cpu's (which are part of the user specified 
> > > interrupt smp_affinity mask and belong to the same x2apic 
> > > cluster) to service the interrupt.
> > 
> > Could/should we do something similar for regular APICs as well? 
> > They too support masks and LowestPrio delivery - and doing that 
> > will increase test coverage rather significantly.
> 
> Existing logical flat xapic mode already takes advantage of this today.

Suresh, should not we tune up es7000_cpu_mask_to_apicid code to return
apicid with a cluster number and ORed logical apicid part as done for
x2apic, or the way it resturns apicid now was done by a purpose?

	Cyrill
