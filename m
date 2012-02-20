Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2BTOlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:41:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28793 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2BTOlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:41:50 -0500
X-Authority-Analysis: v=2.0 cv=Vp2h8pKn c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=v34b3tIZfGoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=x0QFXkpVA9DC_84b_OwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329748907.25686.29.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH][GIT PULL][v3.3] x86: Test saved %rip in NMI to
 determine nested NMI
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 20 Feb 2012 09:41:47 -0500
In-Reply-To: <20120220081045.GD30810@elte.hu>
References: <1329617173.1561.5.camel@acer.local.home>
	 <20120219125601.GD25900@elte.hu>
	 <1329663451.25686.21.camel@gandalf.stny.rr.com>
	 <20120220081045.GD30810@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 09:10 +0100, Ingo Molnar wrote:
> > 
> > Note, it does not seem to cause any destruction, but screw up 
> > profiling.
> 
> Except if the source of the NMI was not profiling, right?

Well, what else are NMIs used for? All I can think of is profiling and
watchdogs. I'm not sure how much damage a watchdog NMI being missed in
userspace will hurt it. Unless it takes a watchdog to set off the next
watchdog. That is, if watchdogs are enabled in a one shot mode. Then a
missed NMI could cause the watchdog to shut off. This is all theory.

The test that %cs is __KERNEL_CS before considering the NMI nested seems
to fix this bug. And if userspace really can't change the %cs to
__KERNEL_CS than we are safe. The bug only exists in the 3.3-rc releases
and by fixing it now we don't need to worry about what problems the
original bug can cause.

Thanks,

-- Steve


