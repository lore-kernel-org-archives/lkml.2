Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3AJMtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:49:23 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:36465 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3AJMtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:49:22 -0500
Date: Thu, 10 Jan 2013 18:18:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Fix utask->xol_vaddr leak in pre_ssout()
Message-ID: <20130110124835.GA28546@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121231175150.GA32066@redhat.com>
 <20121231175226.GA32108@redhat.com>
 <20130108121328.GH1325@linux.vnet.ibm.com>
 <20130108174447.GA887@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130108174447.GA887@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011012-5806-0000-0000-00001E0D0764
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  	utask->vaddr = bp_vaddr;
> > >
> > > -	return arch_uprobe_pre_xol(&uprobe->arch, regs);
> > > +	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
> > > +	if (unlikely(err)) {
> > > +		xol_free_insn_slot(current);
> > > +		return err;
> > > +	}
> > > +
> > > +	return 0;
> > >  }
> >
> > Nit: we could reduce a line or two with
> >
> > 	err = arch_uprobe_pre_xol(&uprobe->arch, regs);
> > 	if (unlikely(err))
> > 		xol_free_insn_slot(current);
> >
> > 	return err;
> 
> Yes, but this is also preparation for the next patch which adds more
> code after arch_uprobe_pre_xol() == 0.
> 

Agree

-- 
Thanks and Regards
Srikar

