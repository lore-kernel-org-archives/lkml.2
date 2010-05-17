Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab0EQKVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:21:01 -0400
Received: from www.tglx.de ([62.245.132.106]:59901 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab0EQKVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:21:00 -0400
Date: Mon, 17 May 2010 12:20:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: Arjan van de Ven <arjan@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
Message-ID: <alpine.LFD.2.00.1005171032220.3368@localhost.localdomain>
References: <1273887635-27610-1-git-send-email-venki@google.com> <87tyq9mqrz.fsf@basil.nowhere.org> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default> <20100515121424.38f5b389@infradead.org> <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default> <20100515224305.17a04022@infradead.org>
 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain> <b7b4f345-944c-4cbc-b98a-700f915183b9@default alpine.LFD.2.00.1005161925480.3368@localhost.localdomain> <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010, Dan Magenheimer wrote:

> > > > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > > > What we can talk about is a vget_tsc_raw() interface along with a
> > 
> > What I have in mind and what I'm working on for quite a while is going
> > to work on both bare metal and VMs w/o hidden slowness.
> 
> Well, if this can be done today/soon and is fast enough
> (say <2x the cycles of a rdtsc), I am very interested and

Are you going to measure that with rdtsc() ? :)

> "won't let my friends use rdtsc" :-)  Anything I can do
> to help?

Yes, stop trying to convince me that rdtsc in apps is a good idea. :)

> It sounds as if you are saying that "the kernel is allowed
> to use a rope because if it accidentally gets the rope
> around its neck, it has a knife to ensure it doesn't hang
> itself" BUT "the app isn't allowed to use a rope because
> it might hang itself and we'll be damned if we loan
> our knife to an app because, well... because it doesn't
> need a knife because we said it shouldn't use the rope".
> 
> I think you can understand why this isn't a very satisfying
> explanation.

What I understand is that you want us to give out the rope only and
when things go wrong let us kernel developers deal with the bugreports
about the missing knife.

Please understand that once we expose that tsc_reliable information we
are responsible for its correctness. People will use it whether the
enterprise entity who wants this feature has qualified that particular
piece of hardware or not. And while the support of that enity refuses
to help on non qualified hardware (your own words), we'll end up with
the mess which was created to help that very entity.

I think you understand that I have no intention to put a ticking time
bomb into the code I'm responsible for. I really have better things to
do than shooting myself in the foot.

Thanks,

	tglx


