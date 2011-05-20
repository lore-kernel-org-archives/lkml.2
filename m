Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977Ab1ETRlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 13:41:37 -0400
Received: from mga14.intel.com ([143.182.124.37]:60141 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205Ab1ETRlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 13:41:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,243,1304319600"; 
   d="scan'208";a="439892014"
Subject: Re: [patch 6/6] x86, apic: use .apicdrivers section to find the
 list of apic drivers
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "steiner@sgi.com" <steiner@sgi.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>
In-Reply-To: <20110520130135.GA15248@elte.hu>
References: <20110519234545.700125442@sbsiddha-MOBL3.sc.intel.com>
	 <20110519234637.671736436@sbsiddha-MOBL3.sc.intel.com>
	 <20110520130135.GA15248@elte.hu>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 20 May 2011 10:41:35 -0700
Message-Id: <1305913295.13584.4303.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 06:01 -0700, Ingo Molnar wrote:
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > This will enable each apic driver to be self-contained and eliminate the need
> > for apic_probe[].
> > 
> > Apic probe will now depend on the order in which apic drivers are listed in
> > the .apicdrivers section. Ordering of apic driver files in the Makefile
> > and the macros apic_driver()/apic_drivers() help enforce the desired order.
> > 
> > Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> > ---
> >  arch/x86/include/asm/apic.h           |   25 ++++++++++---
> >  arch/x86/kernel/apic/Makefile         |   17 +++++---
> >  arch/x86/kernel/apic/apic_flat_64.c   |   11 ++++-
> >  arch/x86/kernel/apic/bigsmp_32.c      |    2 +
> >  arch/x86/kernel/apic/es7000_32.c      |    9 +++-
> >  arch/x86/kernel/apic/numaq_32.c       |    7 ++-
> >  arch/x86/kernel/apic/probe_32.c       |   65 ++++++++++++----------------------
> >  arch/x86/kernel/apic/probe_64.c       |   43 ++++++----------------
> >  arch/x86/kernel/apic/summit_32.c      |    4 +-
> >  arch/x86/kernel/apic/x2apic_cluster.c |    4 +-
> >  arch/x86/kernel/apic/x2apic_phys.c    |    6 ++-
> >  arch/x86/kernel/apic/x2apic_uv_x.c    |    6 ++-
> >  arch/x86/kernel/vmlinux.lds.S         |    6 +++
> >  13 files changed, 111 insertions(+), 94 deletions(-)
> 
> This patch crashes one of my testboxes (AMD X2 whitebox, config attached). No 
> crashlog.

oops. obviously just testing on small and big servers was not enough :(

flat mode was broken, as it had null probe routine. Old code didn't have
flat mode listed in the apic probe array (as the flat mode was the
default option). Will fix it and split it into multiple patches.

thanks.
> 
> The patch is also clearly too large and should be split up into 4 pieces:
> 
>  - there should be a patch adding the whole driver section thing and marking 
>    all the existing APIC drivers with it
> 
>  - one patch adding the functions doing the new-style probing.
> 
>  - one patch flipping over from old-style to new-style probing
> 
>  - a final patch removing all the stale functions and marking the APIC driver
>    probe functions static.
> 
> Thanks,
> 
> 	Ingo

