Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab2LCOkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:40:52 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11957 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab2LCOku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:40:50 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XlK8ECWECGUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=aYz5cAgaFdEA:10 a=1g4hhj49uufQi-hBbH4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354545648.6276.202.camel@gandalf.local.home>
Subject: Re: MIPS Function Tracer question
From: Steven Rostedt <rostedt@goodmis.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Alan Cooper <alcooperx@gmail.com>, ralf@linux-mips.org,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 09:40:48 -0500
In-Reply-To: <50B7E91C.6070403@gmail.com>
References: <CAOGqxeUOrVFoqsmUV19h5tXsD6pw5creXP9aN1C-V7K3WL2EXA@mail.gmail.com>
	 <50B7E91C.6070403@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-11-29 at 15:00 -0800, David Daney wrote:
> On 11/29/2012 01:04 PM, Alan Cooper wrote:
> > I've been doing some testing of the MIPS Function Tracer functionality
> > on the 3.3 kernel. I was surprised to find that the option to generate
> > frame pointers was required for tracing.
> 
> It is not really required for MIPS function tracing, but the Kconfigs 
> for some reason set it.
> 

The issue is with x86. Gcc wont compile if you have -pg and
-fomit-frame-pointer on x86. I originally forced function tracing to
select FRAME_POINTER, but because now on x86 with -mfentry, -pg no
longer requires frame pointers being set, I just let -pg complain one
way or the other. I believe that gcc by default will not add frame
pointers. Thus adding function tracing just prevents
-fomit-frame-pointer from being set, and if -pg requires frame pointers
it will automatically enable them otherwise they should not be enabled.

-- Steve

> >  When I don't enable
> > FRAME_POINTER along with FUNCTION_TRACER, the kernel hangs on boot. I
> > also noticed that a checkin to the 3.4 kernel
> > (b732d439cb43336cd6d7e804ecb2c81193ef63b0) no longer forces on
> > FRAME_POINTER when FUNCTION_TRACER is selected. I was wondering how it
> > works in 3.4 and beyond, so I built a Malta kernel from the latest
> > MIPS tree with FUNCTION_TRACING enabled and tested it with QEMU. The
> > kernel hung the same way. I can think of 2 reasons for this:
> > 1. Function tracing is broken for MIPS in 3.4 and beyond.
> > 2. The 4.5.3 GNU C compiler I'm using is generating different code for
> > function tracing.
> 


