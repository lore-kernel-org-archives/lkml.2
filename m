Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab2EaU4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:56:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758475Ab2EaU4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:56:53 -0400
X-Authority-Analysis: v=2.0 cv=cssZYiEi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=6I2XFdsDAPIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=H7pp7oPaKotvaRadOxEA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1338497811.13348.443.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Date: Thu, 31 May 2012 16:56:51 -0400
In-Reply-To: <4FC7D6EC.3000904@zytor.com>
References: <20120531012829.160060586@goodmis.org>
	    <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com>
	   <1338492300.13348.384.camel@gandalf.stny.rr.com>
	   <4FC7C62C.1020807@zytor.com>
	  <1338494431.13348.410.camel@gandalf.stny.rr.com>
	  <4FC7D1F7.8090405@zytor.com>
	 <1338496555.13348.429.camel@gandalf.stny.rr.com>
	 <4FC7D6EC.3000904@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 13:39 -0700, H. Peter Anvin wrote:
> On 05/31/2012 01:35 PM, Steven Rostedt wrote:
> > 
> > Thus only the debug stack does the stack TSS trick.
> > 
> > Is this what you were looking for? (God, it just shows how much time
> > I've been spending on this crap, as I was able to find all this by
> > memory and not grepping for it :-p )
> > 
> 
> That's why I asked instead of pulled it up myself.
> 
> However, what is missing is what the permitted transitions are.  This
> affects the options.

Only the debug stack changes. These happen in the two places I already
mentioned.

One, the switch of the IDT in NMI (to convert the IST from 4 to 0, and
just keep the same stack).

Two, is the trick in the paranoidzeroentry_ist code (adding the debug
stack). That changes the DEBUG stack pointer.

-- Steve


