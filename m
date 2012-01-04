Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2ADAC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 19:02:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234Ab2ADAC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 19:02:56 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=QcgJSxWpgi8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ACX1LXelnEveKIP2YgUA:9 a=O6C0Hbbwd9DMcZ8dbJMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1325635373.12696.4.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 00/16] [GIT PULL] tracing: fixes/cleanups, no
 stop-machine, update stack tracer
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 03 Jan 2012 19:02:53 -0500
In-Reply-To: <20120102134856.GA32673@elte.hu>
References: <20111221123624.193898256@goodmis.org>
	 <20120101180949.GA25066@elte.hu> <20120102105856.GA6661@elte.hu>
	 <20120102134856.GA32673@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-02 at 14:48 +0100, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Just to give you an impression of how a failure looks like, the 
> > serial console just stops printing mid-line:
> > 
> >  [   53.212942] calling  vt1211_init+0x0/0x9b @ 1                                                   
> >  [   53.212971] initcall vt1211_init+0x0/0x9b returned -19 after 23 usecs                           
> >  [   53.212975] calling  sm_vt8231_init+0x0/0x1b @ 1                                                
> >    Booting 'Fedora'
> > 
> > and the next message is GRUB's 'Booting ...' line.
> 
> here's another one:
> 
> [   53.224579] calling  sm_via686a_init+0x0/0x1b @ 1                                               
> [   53.224622] bus: 'pci': add driver via686a                                                      
>   Booting 'Fedora
> 
> This occured after a series of 50 successful bootups ...
> 
> Unfortunately this means that the 'baseline' numbers are 
> probably not reliable.

Hi Ingo,

I have a machine that seems to lock up 100% of the time when the bad
commit is used.

I started with tip/master (1bc2a3035df) and merged in my branch (this
patch set) and applied your config and it locks up in different places.
I booted it 4 times, and it locked up 4 times.

Then I tried your config against my branch, and I booted it 10 times
without failure.  Can you crash it with just my branch?

I then tried it against just tip/master, and it again locked up the two
times I booted it.

I then looked at the merge you did with Linus's branch:

c7f46b7aa4ae5cbef32eb5e016512a14f936affa

Checked that out, and booted it twice with your config, and it booted
without failure both times.

I'm currently running a ktest git bisect and will let it run over night.
As building a allyesconfig takes a bit of time. I'm hoping that it will
be done by tomorrow.

-- Steve


