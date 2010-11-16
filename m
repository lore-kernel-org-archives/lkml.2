Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0KPRMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 12:12:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37082 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0KPRMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 12:12:05 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>
Date: Tue, 16 Nov 2010 11:11:42 -0600
Subject: RE: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
Thread-Topic: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
Thread-Index: AcuFsOovlprdL/mZRs2ox1rlh+cs8AAAE1+A
Message-ID: <A24693684029E5489D1D202277BE89447382A591@dlee02.ent.ti.com>
References: <1289925179-17085-1-git-send-email-saaguirre@ti.com>
	 <1289925901.2109.629.camel@laptop>
	 <A24693684029E5489D1D202277BE89447382A55A@dlee02.ent.ti.com>
 <1289927326.2109.631.camel@laptop>
In-Reply-To: <1289927326.2109.631.camel@laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> Sent: Tuesday, November 16, 2010 11:09 AM
> To: Aguirre, Sergio
> Cc: LKML; Huang Ying; Martin Schwidefsky; Ingo Molnar; Kyle McMartin
> Subject: RE: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
> 
> On Tue, 2010-11-16 at 10:57 -0600, Aguirre, Sergio wrote:
> 
> > > > @@ -145,7 +145,10 @@ void irq_work_run(void)
> > > >  		 * Clear the BUSY bit and return to the free state if
> > > >  		 * no-one else claimed it meanwhile.
> > > >  		 */
> > > > -		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY),
> NULL);
> > > > +		xchgres = cmpxchg(&entry->next,
> > > > +				  next_flags(NULL, IRQ_WORK_BUSY),
> > > > +				  NULL);
> > > > +		BUG_ON(unlikely(xchgres != next_flags(NULL,
> IRQ_WORK_BUSY)));
> > >
> > > simply adding (void) in front would be much easier.
> >
> > But isn't that still leaving the remote possibility of a hidden cmpxchg
> > Failure open?
> 
> No, we don't care if it fails, read the comment. All we want to know is
> that if it still matched, we flipped the bit.

I understand. Will add just a (void) typecast, and resend then.

Regards,
Sergio
