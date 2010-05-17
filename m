Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab0EQXeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:34:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61983 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab0EQXeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:34:08 -0400
MIME-Version: 1.0
Message-ID: <b190a20b-6420-4bd0-a261-f66c520ae983@default>
Date: Mon, 17 May 2010 16:33:20 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <87tyq9mqrz.fsf@basil.nowhere.org>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
 <20100517102214.GA20761@basil.fritz.box>
 <a3572531-ca89-4959-b190-bcb9309a0193@default
 alpine.LFD.2.00.1005180022040.3368@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005180022040.3368@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4BF1D253.0070:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> 
> On Mon, 17 May 2010, Dan Magenheimer wrote:
> >
> > OK, so let's invert the sense of the sysfs file and call it (for now)
> > "tsc_detected_as_UNreliable".  Then anytime the kernel detects
> > a failed warp test (or any other suspicious condition), it changes
> > the bit from 0 to 1 effectively saying "if you are using rdtsc
> > against our recommendation, we told you that it might go bad and
> > it has, so consider yourself warned that some of the timestamps
> > you've taken since the last time you've checked this flag
> > may be b*rked"
> >
> > IMHO, addressing the issue directly and clearly documenting it
> > (instead of trying to hide the dirty laundry in the kernel)
> > will result in far better education of systems programmers
> > and far fewer end user problems. Which raises another good analogy:
> >
> > You are telling teenagers to abstain and I am proposing that we
> > instead encourage them to use a condom.
> 
> Wrong. A vsyscall _is_ the protection which you want them to pull over
> the rdtsc.
> 
> You are basically telling them: Go ahead, but keep in mind to look for
> that well hidden tag behind the left earlobe which might change
> suddenly from "no disease" to "infectous".

OK, well ignoring the metaphor, it's clear we disagree on a point
that neither one of us can prove: You think your decision to avoid
sharing kernel information will stop system programmers from using
rdtsc, and I think some are going to use rdtsc anyway and blame
Linux when something eventually and silently breaks.

Given that I'm not going to win this argument even by pointing
to examples, let's move forward with your solution.  Can you say
more about your vget_tsc_raw() directions?  Or at least describe
the API if there is anything special?  I'm getting beaten on for
an answer *today*, they say (and I quote from an email today)
they "have been using vsyscalls for a while and still have a
performance headache", and rdtsc looks awfully tempting, even
if it is not 100% perfect.  So what can I give them as an
alternative?

(And, yes, I understand this is not your problem, but I do worry
that it is perceived as *Linux's* problem.  And as we all have
painfully learned in our careers, it's almost impossible to
beat back a perception by presenting a set of byzantine facts
that only a handful of people in the world truly understand.)

Thanks!
Dan
