Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244Ab2JXSfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:35:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:29264 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934943Ab2JXSfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:35:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,640,1344236400"; 
   d="scan'208";a="159957567"
Subject: Re: [stable 2.6.32..2.6.34] x86, ioapic: initialize
 nr_ioapic_registers early in mp_register_ioapic()
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, linbao.zhang@hp.com
Date: Wed, 24 Oct 2012 11:37:52 -0700
In-Reply-To: <20121024182546.GB3338@elie.Belkin>
References: <1351102644.6017.72.camel@sbsiddha-desk.sc.intel.com>
	 <20121024182546.GB3338@elie.Belkin>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1351103872.6017.80.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 11:25 -0700, Jonathan Nieder wrote:
> Hi Suresh,
> 
> Suresh Siddha wrote:
> 
> [...]
> > This problem doesn't happen with more recent kernels and closer
> > look at the 2.6.32 kernel shows that the code which masks
> > the IO-APIC RTE's is not working as expected as the nr_ioapic_registers
> > for each IO-APIC is not yet initialized at this point. In the later
> > kernels we initialize nr_ioapic_registers much before and
> > everything works as expected.
> >
> > For 2.6.[32..34] kernels, fix this issue by initializing
> > nr_ioapic_registers early in mp_register_ioapic()
> >
> > Relevant upstream commit info:
> >
> > commit 7716a5c4ff5f1f3dc5e9edcab125cbf7fceef0af
> 
> Why not cherry-pick 7716a5c4ff5 in full?

As that depends on the other commits like:
commit 4b6b19a1c7302477653d799a53d48063dd53d555
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Mar 30 01:07:08 2010 -0700

Wanted to keep the changes as minimal as possible.

thanks,
suresh

