Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab2CBVML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:12:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab2CBVMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:12:09 -0500
Date: Fri, 2 Mar 2012 16:11:56 -0500
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "mjg@redhat.com" <mjg@redhat.com>,
        "levinsasha928@gmail.com" <levinsasha928@gmail.com>
Subject: Re: [PATCH 1/2] x86, reboot: revert stop_other_cpus to using IRQ
 with NMI fallback
Message-ID: <20120302211156.GM3083@redhat.com>
References: <1329164860-668-1-git-send-email-dzickus@redhat.com>
 <1329164860-668-2-git-send-email-dzickus@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2DACAECA8F@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2DACAECA8F@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 03:41:57PM -0500, Seiji Aguchi wrote:
> 
> > +	/* if the REBOOT_VECTOR didn't work, try with the NMI */
> > +	if ((num_online_cpus() > 1) && (!smp_no_nmi_ipi))  {
> > +		if (register_nmi_handler(NMI_LOCAL, smp_stop_nmi_callback,
> > +					 NMI_FLAG_FIRST, "smp_stop"))
> 
> register_nmi_handler() doesn't work if kernel panics in nmi context because kzalloc() is called in register_nmi_handler() and 
> it may sleep.
> 
> register_nmi_handler() should be replaced with notifier_chain like kdump does.

I don't think kdump uses the notifier_chain.

Cheers,
Don
