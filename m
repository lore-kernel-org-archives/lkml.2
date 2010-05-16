Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751645Ab0EPFk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 01:40:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:56763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0EPFk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 01:40:26 -0400
Date: Sat, 15 May 2010 22:43:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100515224305.17a04022@infradead.org>
In-Reply-To: <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
References: <1273887635-27610-1-git-send-email-venki@google.com>
	<87tyq9mqrz.fsf@basil.nowhere.org>
	<35aa841b-e151-424d-b1c1-0c03dbcae5cc@default
 20100515121424.38f5b389@infradead.org>
	<e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010 15:32:51 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > From: Arjan van de Ven [mailto:arjan@infradead.org]
> (Arjan comments reordered somewhat)
> 
> > But friends don't let friends use rdtsc in application code.
> 
> Um, I realize that many people have been burned by this
> many times over the years so it is a "hot stove".  I also
> realize that there are many environments where using
> rdtsc is risking stepping on landmines.  

> But I (we?) also
> know there are many environments now where using rdtsc is
> NOT risky at all... 

I see a lot of Intel hardware.. (stuff that you likely don't see yet ;-)
and I have not yet seen a system where the kernel would be able to give
the guarantee as you describe it in your email.

If you want a sysfs variable that is always 0... go wild.


> and with the vast majority of new
> systems soon shipping with Invariant TSC and a single socket
> (and even most multiple-socket systems with non-broken
> BIOSes passing a warp test), 

(the warp test is going away)

on multisocket that passes a wrap test you can still get skew over
time.. due to things like SMM, thermal throttling etc etc.


> why should past burns outlaw
> userland use of a very fast, very useful CPU feature?  After
> all, CPU designers at both Intel and AMD have spent
> a great deal of design effort and transistors to FINALLY
> provide an Invariant TSC.

sadly even with all these transistors no system that I know of today
can guarantee the guarantee by the rules you state.


> > oh and.. what notification mechanism do you have to notify the
> > application that the tsc now is no longer reliable? Such conditions
> > can exist... for example due to a CPU being hotplugged, or some SMM
> > screwing around and the kernel detecting that or .. or ...
> 
> The proposal doesn't provide a notification mechanism (though I'm
> not against it)... if the tsc can EVER become unreliable,
> tsc_reliable should be 0.

then it should be 0 always on all of todays hardware.
SMM, thermal overload, etc etc ... you name it.
Things the kernel will get notified about... 

> A CPU-hotplugable system is a good example of a case where
> the kernel should expose that tsc_reliable is 0.  (I've heard
> anecdotally that CPU hotplug into a QPI or Hypertransport system
> will have some other interesting challenges, so may require some
> special kernel parameters anyway.)  

eh no.
hot add works just fine.

(hot remove is a very different ballgame)


> > really. Use the vsyscall. If the vsyscall does not do exactly what
> > you want, make a better vsyscall.
> 
> If this discussion results in a better vsyscall and/or a way
> for applications to easily determine (and report loudly) that
> the system does NOT provide a good way to do a fast timestamp,
> that may be sufficient.  But please propose how that will be done
> as the current software choices are inadequate and the CPU
> designers have finally fixed the problem for the vast majority
> of systems. 

*cough*

> I am already aware of some enterprise software
> that is doing its best to guess whether TSC is reliable by
> looking at CPU families and socket counts, but this is doomed
> to failure in userland and is something that the kernel knows
> and should now expose.

can you name said "enterprise" software by name please? We need a huge
advertisement to let people know not to trust their important data to
it..



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
