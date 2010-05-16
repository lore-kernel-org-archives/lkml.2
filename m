Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab0EPJVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 05:21:33 -0400
Received: from www.tglx.de ([62.245.132.106]:54074 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab0EPJVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 05:21:32 -0400
Date: Sun, 16 May 2010 11:20:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arjan van de Ven <arjan@infradead.org>
cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <20100515224305.17a04022@infradead.org>
Message-ID: <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
References: <1273887635-27610-1-git-send-email-venki@google.com> <87tyq9mqrz.fsf@basil.nowhere.org> <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default 20100515121424.38f5b389@infradead.org> <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
 <20100515224305.17a04022@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010, Arjan van de Ven wrote:
> On Sat, 15 May 2010 15:32:51 -0700 (PDT)
> Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> 
> > > From: Arjan van de Ven [mailto:arjan@infradead.org]
> > (Arjan comments reordered somewhat)
> > 
> > > But friends don't let friends use rdtsc in application code.
> > 
> > Um, I realize that many people have been burned by this
> > many times over the years so it is a "hot stove".  I also
> > realize that there are many environments where using
> > rdtsc is risking stepping on landmines.  
> 
> > But I (we?) also
> > know there are many environments now where using rdtsc is
> > NOT risky at all... 
> 
> I see a lot of Intel hardware.. (stuff that you likely don't see yet ;-)
> and I have not yet seen a system where the kernel would be able to give
> the guarantee as you describe it in your email.
> 
> If you want a sysfs variable that is always 0... go wild.

Nah, there are systems which will have it set to 1:

     Dig out your good old Pentium-I box and enjoy.

> > > oh and.. what notification mechanism do you have to notify the
> > > application that the tsc now is no longer reliable? Such conditions
> > > can exist... for example due to a CPU being hotplugged, or some SMM
> > > screwing around and the kernel detecting that or .. or ...
> > 
> > The proposal doesn't provide a notification mechanism (though I'm
> > not against it)... if the tsc can EVER become unreliable,
> > tsc_reliable should be 0.
> 
> then it should be 0 always on all of todays hardware.
> SMM, thermal overload, etc etc ... you name it.
> Things the kernel will get notified about... 

What we could expose is an estimate about the performance of
gettimeofday/clock_gettime. The kernel has all the information to do
that, but this still does not solve the notification problem when we
need to switch to a different clock source.

Thanks,

	tglx
