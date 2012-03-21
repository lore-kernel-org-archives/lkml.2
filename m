Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760003Ab2CUTAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:00:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:45634 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445Ab2CUTAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:00:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121623345"
Subject: Re: [PATCH 3/3] xen/x86: Implement x86_apic_ops
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jwboyer@redhat.com, mingo@elte.hu, hpa@zytor.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 12:01:32 -0700
In-Reply-To: <20120321164124.GB16441@phenom.dumpdata.com>
References: <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
	 <1332288764-10351-1-git-send-email-konrad.wilk@oracle.com>
	 <1332288764-10351-4-git-send-email-konrad.wilk@oracle.com>
	 <1332293497.16101.90.camel@sbsiddha-desk.sc.intel.com>
	 <20120321164124.GB16441@phenom.dumpdata.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332356492.16101.102.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 12:41 -0400, Konrad Rzeszutek Wilk wrote:
> > > +unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> > > +{
> > > +	if (reg == 0x1)
> > > +		return 0x00170020;
> > > +	else if (reg == 0x0)
> > > +		return 0x00000000;
> > 
> > For IO-APIC ID register (0), you can probably use the argument 'apic' to
> > set the ID bits in the returned register.
> 
> ok, that would be just
> return 0x0000000 | apic
> 
> right? Since the last 8 bits are the apic value?

It is the most significant 8 bits.

So you need to return (apic << 24);

thanks,
suresh

