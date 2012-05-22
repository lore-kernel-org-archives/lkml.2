Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454Ab2EVQwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 12:52:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31576 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2EVQwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 12:52:21 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=huzqtivG31QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=teaT499NlCQ6FntJr90A:9 a=1w2v0sI_Kxct7RhKtYQA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337705539.13348.81.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH RT] rwsem_rt: Another (more sane) approach to mulit
 reader rt locks
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 22 May 2012 12:52:19 -0400
In-Reply-To: <alpine.LFD.2.02.1205221803290.3231@ionos>
References: <1337090625.14207.304.camel@gandalf.stny.rr.com>
	  <alpine.LFD.2.02.1205221553400.3231@ionos>
	 <1337701801.13348.56.camel@gandalf.stny.rr.com>
	 <alpine.LFD.2.02.1205221803290.3231@ionos>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 18:40 +0200, Thomas Gleixner wrote:

> > I'm all for benchmarks. But right now, making all readers pass through a
> > single mutex is a huge bottle neck for a lot of loads. Yes, they are
> > mostly Java loads, but for some strange reason, our customers seems to
> > like to run Java on our RT kernel :-p
> 
> I'm well aware that mmap_sem is a PITA but replacing one nightmare
> with the next one is not the best approach.

Perhaps we could just change the mmap_sem to use this approach. Create a
new type of rwsem/lock for -rt that we can be picky about.

Yeah, mmap_sem is a real PITA and it would be nice to have a solution
that can be used until we can convert it to an RCU lock.

-- Steve


