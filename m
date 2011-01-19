Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1ASQ45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:56:57 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55796 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab1ASQ4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:56:55 -0500
Subject: Re: [patch 3/4] This patch introduces a new oprofile sample add
 function (oprofile_add_ext_hw_sample)
From: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
In-Reply-To: <20110104153411.GV4739@erda.amd.com>
References: <20101220130541.446049933@linux.vnet.ibm.com>
	 <20101220130629.823952802@linux.vnet.ibm.com>
	 <20110104153411.GV4739@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 17:56:46 +0100
Message-ID: <1295456206.7944.5.camel@BR8HFPP0.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

here is the 3rd part.

Thanks a lot for your comments!

Heinz

On Tue, 2011-01-04 at 16:34 +0100, Robert Richter wrote: 
> On 20.12.10 08:05:44, graalfs@linux.vnet.ibm.com wrote:
> > From: graalfs@linux.vnet.ibm.com
> > 
> > This patch introduces a new oprofile sample add function (oprofile_add_ext_hw_sample)
> > that can also take task_struct as an argument, which is used by the hwsampler kernel module 
> > when copying hardware samples to OProfile buffers.
> > 
> > Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> > Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
> > Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> > ---
> >  drivers/oprofile/cpu_buffer.c |   26 +++++++++++++++++++-------
> >  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> > +void oprofile_add_ext_hw_sample(unsigned long pc, struct pt_regs * const regs,
> > +				unsigned long event, int is_kernel,
> > +				struct task_struct *task)
> > +{
> > +	__oprofile_add_ext_sample(pc, regs, event, is_kernel, task);
> > +}
> > +EXPORT_SYMBOL_GPL(oprofile_add_ext_hw_sample);
> 
> Hmm, I am not convinced of this new interface between the hwsampler
> module and oprofile. It is asymmetric and bloats the function's
> parameters list. A first simplification would be to not implement
> hwsampler as module and integrate this in oprofile. Then, we can look
> for a better way to add samples to the oprofile buffer. What do you
> think?
> 
ok, as you suggested hwsampler is now integrated in oprofile, and the
EXPORT is gone, instead I added it to oprofile.h, which I fear you will
not accept but I try.

> -Robert
> 






