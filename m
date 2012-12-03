Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab2LCRvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:51:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29508 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab2LCRvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:51:05 -0500
X-Authority-Analysis: v=2.0 cv=Mv7QGhme c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XlK8ECWECGUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=aYz5cAgaFdEA:10 a=s-gwoRVtHMEgTxDo564A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354557056.6276.203.camel@gandalf.local.home>
Subject: Re: MIPS Function Tracer question
From: Steven Rostedt <rostedt@goodmis.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Daney <ddaney.cavm@gmail.com>, Alan Cooper <alcooperx@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Dec 2012 12:50:56 -0500
In-Reply-To: <20121203161346.GA29573@linux-mips.org>
References: <CAOGqxeUOrVFoqsmUV19h5tXsD6pw5creXP9aN1C-V7K3WL2EXA@mail.gmail.com>
	 <50B7E91C.6070403@gmail.com> <1354545648.6276.202.camel@gandalf.local.home>
	 <20121203161346.GA29573@linux-mips.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-12-03 at 17:13 +0100, Ralf Baechle wrote:
> On Mon, Dec 03, 2012 at 09:40:48AM -0500, Steven Rostedt wrote:
> 
> > The issue is with x86. Gcc wont compile if you have -pg and
> > -fomit-frame-pointer on x86. I originally forced function tracing to
> > select FRAME_POINTER, but because now on x86 with -mfentry, -pg no
> > longer requires frame pointers being set, I just let -pg complain one
> > way or the other. I believe that gcc by default will not add frame
> > pointers. Thus adding function tracing just prevents
> > -fomit-frame-pointer from being set, and if -pg requires frame pointers
> > it will automatically enable them otherwise they should not be enabled.
> 
> On architectures such as MIPS where a frame pointer is not required for
> debugging -O and higher imply -fomit-frame-pointer.

Then this shouldn't be an issue for MIPS.

-- Steve


