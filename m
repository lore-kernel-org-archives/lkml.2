Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965395Ab2EXUdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 16:33:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab2EXUdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 16:33:08 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=irseqbIK9hsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=kjX7_rKuXr5PvPQUUXIA:9 a=UYWFLoxdwKkJ_VTLLGsA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337891586.13348.202.camel@gandalf.stny.rr.com>
Subject: Re: tracing ring_buffer_resize oops.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kbuild@vger.kernel.org
Date: Thu, 24 May 2012 16:33:06 -0400
In-Reply-To: <1337890690.13348.199.camel@gandalf.stny.rr.com>
References: <20120524160146.GA6226@redhat.com>
	 <1337876398.13348.178.camel@gandalf.stny.rr.com>
	 <20120524172223.GA10689@redhat.com>
	 <1337880914.13348.189.camel@gandalf.stny.rr.com>
	 <20120524184728.GA13201@redhat.com>
	 <1337885672.13348.194.camel@gandalf.stny.rr.com>
	 <20120524191147.GA13936@redhat.com>
	 <1337887495.13348.195.camel@gandalf.stny.rr.com>
	 <20120524200541.GA6552@redhat.com>
	 <1337890690.13348.199.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 16:18 -0400, Steven Rostedt wrote:
> On Thu, 2012-05-24 at 16:05 -0400, Dave Jones wrote:
> > On Thu, May 24, 2012 at 03:24:55PM -0400, Steven Rostedt wrote:
> >  > On Thu, 2012-05-24 at 15:11 -0400, Dave Jones wrote:
> >  > 
> >  > >  > Also, how reproducible is it? When it triggered for me, it was constant.
> >  > >  > Every boot and test failed. But after I did the make mrproper, I have
> >  > >  > not been able to trigger it again. This is why I put it down as a bad
> >  > >  > build.
> >  > > 
> >  > > happens every time for me so far.
> >  > 
> >  > Did you also do a make mrproper and try again?
> > 
> > ok, that's nasty.  Works fine after a make clean.
> > 
> 
> Thanks for verifying. I'm thinking this is a build bug. Something's not
> cleaning up properly. It may be with the recordmcount code. Perhaps
> objects needed to change where the mcount calls are and did not?
> 
> I'll try other things to see if I can trigger this again. Then I'll save
> off the build tree, do a make clean, rebuild, and compare what's
> different.
> 

I'm kicking off the ktest that initially caused this issue hoping that
it reproduces the bad tree again.

BTW, did you happen to upgrade gcc or anything? The ktest I run does
test against different gcc's and I don't think I had it do a make clean
between the switch. That may be the cause of this problem too :-?

-- Steve


