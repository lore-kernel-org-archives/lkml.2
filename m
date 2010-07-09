Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0GIXOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 19:14:15 -0400
Received: from smtp4.Stanford.EDU ([171.67.219.84]:57962 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751452Ab0GIXOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 19:14:14 -0400
Subject: Re: 2.6.33.5 rt23: machine lockup (nfs/autofs related?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1278716222.2349.20.camel@localhost.localdomain>
References: <1278609590.7527.11.camel@localhost.localdomain>
	 <1278628386.3008.11.camel@localhost.localdomain>
	 <1278629044.12059.6.camel@localhost.localdomain>
	 <1278630050.3008.18.camel@localhost.localdomain>
	 <1278702134.5102.9.camel@localhost.localdomain>
	 <1278705254.2349.14.camel@localhost.localdomain>
	 <1278713600.7122.22.camel@localhost.localdomain>
	 <1278716222.2349.20.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 16:13:44 -0700
Message-ID: <1278717224.7122.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 15:57 -0700, john stultz wrote:
> On Fri, 2010-07-09 at 15:13 -0700, Fernando Lopez-Lezcano wrote:
> > On Fri, 2010-07-09 at 12:54 -0700, john stultz wrote:
> > > On Fri, 2010-07-09 at 12:02 -0700, Fernando Lopez-Lezcano wrote:
> > > > Ok, I got one! (had to go buy a null modem cable, I thought I had one
> > > > but it has disappeared since the last time I did this :-)
> > > 
> > > Great! Sorry to make you go shopping! But this points out the problem
> > > nicely.
> > 
> > No problem at all, I was sure I had one... anyway, I still need it :-<
> > 
> > > > Find it below... it keeps spewing stuff every once in a while. Hopefully
> > > > this will be enough. No response from the network or the keyboard or
> > > > mouse at this point, reset is the only way out. 
> > > > 
> > > > I can retest if somebody comes up with a patch...
> > 
> > Sorry, it looks like the patch patched correctly and this is the new
> > kernel, but I still get a hang as before. 
> 
> So looking over it, I'm not easily seeing what else could be off.
> 
> So Lets see if we can cut some of the guess work out of this...
> 
> >  [<c04e08e9>] ? d_materialise_unique+0xbf/0x29e
> 
> I'm curious exactly where that is in d_materialise_unique. To find out,
> can you find the vmlinux image in the base of the directory you built
> the kernel you triggered this in?
> 
> Then run:
> # gdb ./vmlinux
> 
> Once gdb loads:
> (gdb) list *0xc04e08e9
> 
> That should point to exactly where in the function we are trying to
> acquire a previously locked lock.

I'll have to rebuild. I'm doing full rpm package builds or a build
server and the original build tree is gone. 

-- Fernando


