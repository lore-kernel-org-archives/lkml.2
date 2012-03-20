Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2CTSL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:11:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:25199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab2CTSLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:11:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="123048788"
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        midgoon@gmail.com
Date: Tue, 20 Mar 2012 11:12:58 -0700
In-Reply-To: <20120320094048.GC20079@phenom.dumpdata.com>
References: <1327454651.27983.7.camel@sbsiddha-desk.sc.intel.com>
	 <20120125134947.GF13655@zod.bos.redhat.com>
	 <1327529048.2327.17.camel@sbsiddha-mobl2>
	 <20120125231534.GL13655@zod.bos.redhat.com>
	 <20120131142621.GA2136@zod.bos.redhat.com>
	 <1328083230.3638.2.camel@sbsiddha-mobl2>
	 <20120312132448.GA20204@zod.bos.redhat.com>
	 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
	 <20120319133046.GB13093@zod.bos.redhat.com>
	 <20120319193842.GA8123@phenom.dumpdata.com>
	 <20120320094048.GC20079@phenom.dumpdata.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332267178.16101.66.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 05:40 -0400, Konrad Rzeszutek Wilk wrote:
> I think there are three ways of fixing this:
> 
>  1). Revert Suresh's patch and look at just removing the "Unable to reset IRR" warning
>     (perhaps by being conditional on running in kexec-env?).
> 
>  2). Make the Xen layer fake out an IOAPIC - so instead of 0xffffff, make sure to
>      clear the three bits that Suresh' patch is testing for (Ewwwww, I don't actually
>      like that - that stinks of a hack).
> 
>  3). Rework Suresh's patch - to only remove the IOAPIC entry if there is no
>      INT_SRV_OVR that depend on it. I made a stab at it and here is draft patch, that
>      looks to work on my boxes that have more than one IOAPIC and are booting under Xen:
>      But I am not 100% confident about it so would appreciate somebody looking at it.
> 

Thanks for looking at this Konrad. This issue is not just specific to
INT_SRC_OVR per-say.

Issue is that Xen though it doesn't use IO-APIC, it does depend on
proper IO-APIC parsing for various things like getting proper gsi_top,
INT_SRV_OVR entries etc.

I think Xen should be setting up a valid dummy IO-APIC mapping instead
of working around.

thanks,
suresh

