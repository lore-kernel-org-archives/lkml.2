Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933910Ab2EWTET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:04:19 -0400
Received: from relay1.sgi.com ([192.48.179.29]:42294 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933848Ab2EWTEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:04:16 -0400
Date: Wed, 23 May 2012 14:04:14 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: check for valid irq_cfg pointer in
 smp_irq_move_cleanup_interrupt
Message-ID: <20120523190414.GA5263@sgi.com>
References: <20120521164959.GE16454@sgi.com>
 <alpine.LFD.2.02.1205212304580.3231@ionos>
 <20120521211917.GA25567@sgi.com>
 <alpine.LFD.2.02.1205212324260.3231@ionos>
 <20120523181636.GA2032@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523181636.GA2032@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 01:16:36PM -0500, Dimitri Sivanich wrote:
> In create_irq_nr() there is a window where we have set vector_irq in
> __assign_irq_vector(), but not yet called irq_set_chip_data() to set the
> irq_cfg pointer.

BTW - is there a reason why we're calling irq_set_chip_data() in create_irq_nr()
rather than in __assign_irq_vector() for the case where irq_cfg is NULL?
