Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1AEPKg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:10:36 -0500
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:5558 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab1AEPKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:10:35 -0500
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jan 2011 10:10:35 EST
From: Ian Campbell <ijc@hellion.org.uk>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201101051547.12107.sheng@linux.intel.com>
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
	 <1292912329-12451-2-git-send-email-sheng@linux.intel.com>
	 <201101051547.12107.sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 14:56:28 +0000
Message-ID: <1294239388.3831.3516.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=z0RUBZs6AVsA:10 a=IkcTkHD0fZMA:10 a=EqSVyYDxCmx5PoDwFIsA:9 a=qJ0bFeMbzbMGuu1AVugA:7 a=P7rXIyUuUSQbflqvmqnNICf3BD4A:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1384,6 +1365,17 @@ static bool __init xen_hvm_platform(void)
> >       return true;
> >  }
> > 
> > +bool xen_hvm_need_lapic(void)
> > +{
> > +     if (xen_pv_domain())
> > +             return false;
> > +     if (xen_hvm_domain() && xen_feature(XENFEAT_hvm_pirqs) &&
> > +                     xen_have_vector_callback)
> > +             return false;
> > +     return (xen_cpuid_base() != 0);
> > +}
> > +EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
> > +

Since xen_hvm_domain() is always true if xen_cpuid_base() != 0, isn't
this more obviously written as:
	if (!xen_hvm_domain())
		return false;
	if (xen_feature(XENFEAT_hvm_pirqs) && xen_have_vector_callback)
		return false;
	return true;
?

Also, checking for the XenVMMXenVMM signature alone seems like a very
broad test for checking the availability of a specific feature, is there
nothing more specific which we could/should be testing?

Ian.

-- 
Ian Campbell
Current Noise: Taint - Mass Appeal Sadness

What's a cult?  It just means not enough people to make a minority.
		-- Robert Altman

