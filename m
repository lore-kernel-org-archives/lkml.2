Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab1JSJxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 05:53:23 -0400
Received: from ist.d-labs.de ([213.239.218.44]:49716 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab1JSJxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 05:53:22 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Oct 2011 05:53:22 EDT
Date: Wed, 19 Oct 2011 11:42:15 +0200
From: Florian Mickler <florian@mickler.org>
To: Benjamin Robin <benjarobin@gmail.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, andi-bz@firstfloor.org,
        greg@kroah.com, maciej.rutecki@gmail.com, rjw@sisk.pl,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 42212] Asus UL80VT hangs on resume from suspend-to-ram
Message-ID: <20111019114215.221535e7@schatten.dmk.lab>
In-Reply-To: <CAAMvZCGzPegbDXjvXdU4b-4=SYVtdN2PQxA15RQTu1631CXbPQ@mail.gmail.com>
References: <bug-42212-18473@https.bugzilla.kernel.org/>
 <201109042039.p84KdLNP015975@demeter2.kernel.org>
 <CAAMvZCGzPegbDXjvXdU4b-4=SYVtdN2PQxA15RQTu1631CXbPQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin!

You forgot the most important cc: linux-kernel@vger.kernel.org ; I
added it. 


On Tue, 18 Oct 2011 22:37:06 +0200
Benjamin Robin <benjarobin@gmail.com> wrote:

> Hi everybody,
> 
> I hoped that bugzilla.kernel.org came back quickly, that's why I waited so
> long, sorry for the delay.
> I lost some of the history and the list of the follower, sorry for that too.

No problem. The regression tracking is a little bit incapacitated by
the bugzilla downtime. I simply could not get myself to go
through the bugzilla mails and try to identify loose ends. I'm hoping
we will be getting everything back in one piece. In the meantime, we
are back to only lkml for regressions.

And to add a short information: this is said (and doublechecked by
reverting) to be a regression from Andi Kleen's personality
patch. 

| --- Comment #9 from benjarobin <benjarobin@gmail.com>  2011-09-03 21:46:11 ---
| I managed to run the compilation through ssh on my main PC.
| I could not believe the result of the bisect, the commit that produce the
| regression doesn't look like related to my problem : 
| 
| commit 512228f0be3af44bf5cf6cc5750ddd279bbedaf3
| Author: Andi Kleen <ak@linux.intel.com>
| Date:   Fri Aug 19 16:15:10 2011 -0700
| 
| Add a personality to report 2.6.x version numbers
| 
| I have attached the steps of the bisect, I compiled twice and check that I was
| using the right kernel
|



> 
> Just to remember I am running an Asus UL80VT on Archlinux i686
> 
> During this period I experiment a lot, here what I found:
> - I compile linux 3.1rc4 with and without the problematic commit => OOps (No
> log, no trace...) The OOps may be unrelated to my problem, maybe I did not
> configure the kernel properly...
> - Linux 3.0.6 vanilla still failing the same way
> - Linux 3.0 + problematic commit => OK
> - On a fresh install (on an USB drive) with x86_64 it's working from 3.0 to
> 3.0.6 vanilla
> - On a fresh install (on an USB drive) with i686 same problem
> - I was not really able to find the version of the kernel + problematic
> commit where everything is OK
> 
> - Debug with RTC (funny but quite long):
>    * First test give me :
>      [    0.992189]   Magic number: 0:319:980
>      [    0.992193]   hash matches drivers/base/power/main.c:510
>    It looks like that not device match...
> 
>   * After putting a lot of "TRACE_RESUME(X);" into the device_resume
> function I was able to find that the problem is around line 531 =>
> pm_dev_dbg(dev, state, "type ");
> 
> I have no idea if there is a way to get the device name.
> And do you think it is possible to debug with an UART (usb serial console) ?
> I think it isn't, but I may be wrong...
> I was thinking of rewriting the code that write to the RTC to be able to
> write the device name and not the hash, but with only 24 bits it's not very
> easy (I can only write 4 characters if I optimism a little bit, instead of
> 3) and I don't have much time.
> 
> So if someone has any idea, he is welcome
> 
> Regards,
> 
> Benjamin Robin
> 
> 2011/9/4 <bugzilla-daemon@bugzilla.kernel.org>
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=42212
> >
> >
> >
> >
> >
> > --- Comment #16 from Andi Kleen <andi-bz@firstfloor.org>  2011-09-04
> > 20:39:19 ---
> > Hmm, but newuname uses personality already, at least on 64bit kernels
> > Also you should see an oops if a NULL pointer is followed. And I don't
> > see how the low level suspend code should be calling uname anyways.
> >
> > This doesn't make much sense.
> >
> > Just to be sure when you do the suspend on the unpatched kernel multiple
> > times in a row does it always fail?
> >
> > --
> > Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> > ------- You are receiving this mail because: -------
> > You reported the bug.
> >
