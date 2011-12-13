Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1LMAU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:20:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:21702 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab1LMAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:20:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="95407077"
Subject: Re: x2apic boot failure on recent sandy bridge system
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 12 Dec 2011 16:25:02 -0800
In-Reply-To: <4EE68C80.7000408@gmail.com>
References: <4EE2BC33.80902@gmail.com>
	 <CAE9FiQXH6d0eAjbQ0Dz3Q8NR6ktP_x6UKtzDtuq8253Qv4KS7w@mail.gmail.com>
	 <20111211075713.GA20790@elte.hu>
	 <CAE9FiQXk7y_oafNZG-QF5h3kDUQ3J6SP3A=ezHBT2W4Njo=uxQ@mail.gmail.com>
	 <4EE5291C.1030302@gmail.com>
	 <CAE9FiQXf2GzR2Uuw23CK7YVN4djtCd+aOFTRrf=96u9NTXRn=A@mail.gmail.com>
	 <4EE68C80.7000408@gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323735902.1984.165.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 15:21 -0800, Berck E. Nash wrote:
> On 12/11/2011 08:40 PM, Yinghai Lu wrote:
> > x2apic pre-enabled skip the mapping for lapic address. so need map it
> > after fall back.
> > 
> > please check attached -v5..
> 
> It appears to work correctly as far as I can tell.

Ok. In this case, it looks like bios didn't enable interrupt-remapping
(part of vt-d) and just enabled x2apic with out touching or exporting
vt-d HW.

Yinghai, In other scenarios where OS can't recover, mostly likely we
will fail in check_timer() when we fall back to xapic. Can we add a
printk in this case to convey the potential reason (that I mentioned in
the previous e-mail), so that the user can get more accurate information
for the check timer failure.

thanks,
suresh

