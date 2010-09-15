Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab0IOFGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 01:06:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:36347 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0IOFGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 01:06:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,369,1280732400"; 
   d="scan'208";a="607012913"
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Don Zickus <dzickus@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100914174814.GC3822@elte.hu>
References: <45864.91.60.148.9.1284474680.squirrel@www.firstfloor.org>
	 <20100914174814.GC3822@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 13:06:32 +0800
Message-ID: <1284527192.2256.113.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 01:48 +0800, Ingo Molnar wrote:
> * Some One <some@where> stripped out all quoted identities and wrote:
> > >
> > > The proper approach would be not to add hacks to the NMI code but to 
> > > implement southbridge drivers - which would also have NMI callbacks.
> > 
> > BTW southbridges do less and less regarding PCI.
> 
> Except WICTCR.
> 
> > > These are unchartered waters, but variance in that space is reducing 
> > > systematically so it would be worth a shot.
> > 
> > You don't really need special drivers for AER [...]
> 
> On the contrary, we need proper driverization for _everything_ new. 
> Embedded x86 is here to stay, so we are abstracting away each and every 
> bit of the platform. See struct x86_ops for a highlevel platform driver 
> - but a more specific, southbridge-encompassing driver framework can be 
> created too.

All in all, we can have proper drivers to printk/write to NVRAM the
error information collected for unknown NMI, regardless they are AER or
Southbridge driver or both. And, the drivers will register handlers for
unknown NMI. Do you agree?

Best Regards,
Huang Ying

