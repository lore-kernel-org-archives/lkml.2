Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab2AIPy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:54:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755695Ab2AIPy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:54:27 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5mlinyXLCh8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=82irRftXAAAA:8 a=Aal68Ew68FdzEPTtPtIA:9 a=5lXJhK3phjKh96y-dBQA:7 a=PUjeQqilurYA:10 a=WgwKcZQGGVUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326124464.7642.27.camel@gandalf.stny.rr.com>
Subject: Re: linux-next: build failure after merge of the final tree
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Linus <torvalds@linux-foundation.org>
Date: Mon, 09 Jan 2012 10:54:24 -0500
In-Reply-To: <20120109154259.GD9329@kroah.com>
References: <20120105190405.1e3191fb5a43b2a0f1655e1f@canb.auug.org.au>
	 <20120105160448.dc482ef6.akpm@linux-foundation.org>
	 <20120109165950.53933c3050416bd242acff76@canb.auug.org.au>
	 <20120109172016.2496b94ce207c5f7f750a1ea@canb.auug.org.au>
	 <20120109154259.GD9329@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-09 at 07:42 -0800, Greg KH wrote:
>  
> > 8a25a2fd126c621f44f3aeaef80d51f00fc11639 is the first bad commit
> > commit 8a25a2fd126c621f44f3aeaef80d51f00fc11639
> > Author: Kay Sievers <kay.sievers@vrfy.org>
> > Date:   Wed Dec 21 14:29:42 2011 -0800
> > 
> >     cpu: convert 'cpu' and 'machinecheck' sysdev_class to a regular subsystem
> 
> How is this triggering this build problem?  I didn't see this happen
> before, and it wasn't showing up in linux-next in the past, right?
> 
> This patch has nothing to to with tracing, perhaps it is an #include
> file problem?  Or is the build error a different one (remember the
> -Werror problem in linux-next that I fixed up for PPC?)

I'll take a look at this today. The problem is that something probably
included one of the "include/trace/event/*.h" files in a header. That's
always a pain, as those files should not be in headers and only called
by C files that directly use tracepoints. Those headers have the macro
magic to create those undefined symbols that Stephen is seeing and when
you have one trace/event/*.h included in another, it can sometimes cause
strange side effects like this.

Thus, simply adding an "include" somewhere can trigger this.

I'll checkout latest mainline and see.

Stephen, what config does this trigger with?

Thanks,

-- Steve

