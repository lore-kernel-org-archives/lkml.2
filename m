Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965954Ab0CPBvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:51:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:52213 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965941Ab0CPBvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:51:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="604705029"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH][v9 4/6] xen/hvm: Xen PV extension of HVM initialization
Date: Tue, 16 Mar 2010 09:51:48 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; x86_64; ; )
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>,
       "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com> <alpine.DEB.2.00.1003151108151.27222@kaball-desktop> <4B9EBBEE.9020107@goop.org>
In-Reply-To: <4B9EBBEE.9020107@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003160951.48973.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 March 2010 06:59:58 Jeremy Fitzhardinge wrote:
> On 03/15/2010 05:04 AM, Stefano Stabellini wrote:
> >> But we should make sure Xen have ability to support such kind of
> >> operation. The CPUID would show if Xen have such ability, and if it
> >> does, the feature would be enabled unconditionally. Guest kernel always
> >> enable all features it can do unconditionally, but Xen should offer the
> >> support for them.
> >
> > In my opinion once the guest knows that is running on Xen HVM (that is
> > from xen_cpuid_base() or xen_para_available()) it should assume
> > that the pv clocksource is available, therefore XEN_HVM_PV_CLOCK_ENABLED
> > should not be needed.
> > In other words the mere presence of Xen should imply
> > XEN_HVM_PV_CLOCK_ENABLED.
> 
> The only reason why we wouldn't want to do this is if we want to
> withdraw this feature at some point in the future.  We're stuck with it
> indefinitely for PV, but I don't know if that's necessarily going to be
> the case for HVM.  On the other hand, if other - better - mechanisms
> become available, we can give them their own clocksource driver with a
> higher priority than the Xen pvclock one, and users can still select
> clocksources on the kernel command line.

So you think about adding a new XENFEAT?
> 
> > Do you mean write generic code now, then introduce the 64 bit
> > limitation later? Or the other way around?
> > I don't have a strong opinion here so I am OK with both approaches, but
> > I would prefer to add the limitation later (maybe we'll be able to make
> > it work on 32 bit too...).
> 
> Seems like making it work for both 32 and 64-bit is the easiest thing to
>  do.

If it is, it should be fine. But I had encountered some issues on 32 bits.

-- 
regards
Yang, Sheng
