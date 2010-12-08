Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0LHKkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:40:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:53349 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab0LHKkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:40:15 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <4CFED0AE.9000900@kernel.org>
References: <1291219906.32004.1671.camel@laptop>
	 <20101201162335.GB2511@redhat.com> <1291232292.32004.1969.camel@laptop>
	 <20101201194644.GD2511@redhat.com> <1291232989.32004.1987.camel@laptop>
	 <20101201195835.GE2511@redhat.com> <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	 <1291275270.4023.20.camel@twins> <20101207211614.GL21786@redhat.com>
	 <4CFED0AE.9000900@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 11:39:53 +0100
Message-ID: <1291804793.28378.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 16:26 -0800, Yinghai Lu wrote:
> > +++ b/arch/x86/kernel/cpu/perf_event.c
> > @@ -377,10 +377,10 @@ static bool check_hw_exists(void)
> >       u64 val, val_new = 0;
> >       int ret = 0;
> >  
> > -     val = 0xabcdUL;
> > -     ret |= checking_wrmsrl(x86_pmu.perfctr, val);
> > -     ret |= rdmsrl_safe(x86_pmu.perfctr, &val_new);
> > -     if (ret || val != val_new)
> > +     val = 0xabUL;
> > +     ret |= checking_wrmsrl(x86_pmu.eventsel, val);
> > +     ret |= rdmsrl_safe(x86_pmu.eventsel, &val_new);
> > +     if (ret || val != (val_new & 0xFF))
> >               return false;
> >  
> >       return true;
> 
> Thanks. it fixes the problem.
> 
Won't merge it though, I think it stinks..
