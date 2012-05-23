Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985Ab2EWT0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:26:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:23591 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933026Ab2EWT0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:26:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="147558820"
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 12:24:46 -0700
In-Reply-To: <20120523190414.GA5263@sgi.com>
References: <20120521164959.GE16454@sgi.com>
	 <alpine.LFD.2.02.1205212304580.3231@ionos> <20120521211917.GA25567@sgi.com>
	 <alpine.LFD.2.02.1205212324260.3231@ionos> <20120523181636.GA2032@sgi.com>
	 <20120523190414.GA5263@sgi.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337801086.1997.197.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 14:04 -0500, Dimitri Sivanich wrote:
> On Wed, May 23, 2012 at 01:16:36PM -0500, Dimitri Sivanich wrote:
> > In create_irq_nr() there is a window where we have set vector_irq in
> > __assign_irq_vector(), but not yet called irq_set_chip_data() to set the
> > irq_cfg pointer.

Ha. Now I understand how it can happen during boot/module load time.
Thanks.

> BTW - is there a reason why we're calling irq_set_chip_data() in create_irq_nr()
> rather than in __assign_irq_vector() for the case where irq_cfg is NULL?

assign_irq_vector() is also for setting up vectors during irq migration.
So may be we could have done the irq_set_chip_data() in create_irq_nr()
itself before calling assign_irq_vector(). Anyways, this change can't
help in case of destroy irq path which can also lead to the same issue
of de-referencing null pointer.

Also, it will be nice if you can refer to this destroy irq path in your
changelog.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

