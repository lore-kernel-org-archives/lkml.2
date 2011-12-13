Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1LMO6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:58:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab1LMO6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:58:48 -0500
Message-ID: <4EE76810.7000802@redhat.com>
Date: Tue, 13 Dec 2011 16:58:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com> <20111212172059.GC23870@elte.hu> <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com> <20111212192135.GA18876@elte.hu> <alpine.LFD.2.02.1112130056370.3020@ionos> <4EE72FCB.3070109@redhat.com> <alpine.LFD.2.02.1112131434320.3020@ionos> <4EE75FF8.5060208@redhat.com> <alpine.LFD.2.02.1112131547590.3020@ionos>
In-Reply-To: <alpine.LFD.2.02.1112131547590.3020@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 04:51 PM, Thomas Gleixner wrote:
> > > The whole APIC timer calibration and the back and forth
> > > conversion is definitely nothing which falls into the category of
> > > smart.
> > 
> > APIC timer calibration is silly but it hasn't proven to be a real-world
> > problem.
>
> Well, that depends on the world. 

What I mean by that, is that I haven't seen any bug reports in this area
apart from some issue with wiring the PIT/PIC/APIC correctly which were
resolved long ago.

> The issue with that calibration is
> that it can be off and for a certain category of application it
> matters. Definitely not for the usual virt workload stuff. But saving
> cycles for highres/nohz enabled guests would be nice. Maybe I have a
> go when I find a some time.

Just dropping the calibration an replacing it with a pre-calibrated
value should be simple, if there is a workload that could benefit.

-- 
error compiling committee.c: too many arguments to function

