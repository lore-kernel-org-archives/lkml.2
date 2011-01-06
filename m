Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1AFBSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 20:18:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:50338 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab1AFBSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 20:18:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,280,1291622400"; 
   d="scan'208";a="370674610"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
Date: Thu, 6 Jan 2011 09:20:47 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <201101051547.12107.sheng@linux.intel.com> <1294239388.3831.3516.camel@zakaz.uk.xensource.com>
In-Reply-To: <1294239388.3831.3516.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101060920.47797.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 January 2011 22:56:28 Ian Campbell wrote:
> > > @@ -1384,6 +1365,17 @@ static bool __init xen_hvm_platform(void)
> > > 
> > >       return true;
> > >  
> > >  }
> > > 
> > > +bool xen_hvm_need_lapic(void)
> > > +{
> > > +     if (xen_pv_domain())
> > > +             return false;
> > > +     if (xen_hvm_domain() && xen_feature(XENFEAT_hvm_pirqs) &&
> > > +                     xen_have_vector_callback)
> > > +             return false;
> > > +     return (xen_cpuid_base() != 0);
> > > +}
> > > +EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
> > > +
> 
> Since xen_hvm_domain() is always true if xen_cpuid_base() != 0, isn't
> this more obviously written as:
> 	if (!xen_hvm_domain())
> 		return false;

XEN_HVM_DOMAIN works only when kernel built with CONFIG_XEN. This patch can also 
support kernel built without CONFIG_XEN but with CONFIG_X86_X2APIC.

> 	if (xen_feature(XENFEAT_hvm_pirqs) && xen_have_vector_callback)
> 		return false;
> 	return true;
> ?
> 
> Also, checking for the XenVMMXenVMM signature alone seems like a very
> broad test for checking the availability of a specific feature, is there
> nothing more specific which we could/should be testing?

The CPU flag x2apic is checked when we want to enable x2apic, and only Xen which 
supported x2apic emulation would show this flag.

--
regards
Yang, Sheng

> 
> Ian.
