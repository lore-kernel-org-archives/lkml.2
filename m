Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab2LMA34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 19:29:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2LMA3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 19:29:54 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6rjoWDsBMgUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=TkPsaq_4P5wA:10 a=VwQbUJbxAAAA:8 a=AdX03QhhDBMRJ6uPRCAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1355358592.17101.360.camel@gandalf.local.home>
Subject: Re: [PATCH 0/5] [GIT PULL] ktest: fixes and updated for new boot
 loaders
From: Steven Rostedt <rostedt@goodmis.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 19:29:52 -0500
In-Reply-To: <20121213104736.bd2094f856d459edae2d9529@canb.auug.org.au>
References: <20121212221437.245229327@goodmis.org>
	 <20121213104736.bd2094f856d459edae2d9529@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 10:47 +1100, Stephen Rothwell wrote:
> Hi Steve,
> 
> On Wed, 12 Dec 2012 17:14:37 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Please pull the latest ktest-v3.8 tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
> > ktest-v3.8
> > 
> > Head SHA1: a7c85ac16cf29aa0fec5fef2fe26bb09a9e3ee19
> > 
> > 
> > Steven Rostedt (5):
> >       ktest: Add support for grub2
> >       ktest: Sync before reboot
> >       ktest: Add native support for syslinux boot loader
> >       ktest: Fix breakage from change of oldnoconfig to olddefconfig
> >       ktest: Test if target machine is up before install
> 
> Just a bit disappointed that none of this made ever it into your for-next
> branch (and hence linux-next) ...
> 

Yeah, I know. That's because most of it stays in a quilt queue and I
commit it to git when the merge window opens. I use ktest every day, and
hammer it more than anyone else. I usually shake out all the bugs before
I post.

As this sits in the tools/testing/ktest/ directory and is just a single
perl script, it doesn't interact with other parts of the kernel tree.
I've been trying to remember to add it to linux-next, but sometimes I
forget :-(

My work flow with ktest is basically this:

1) Something about ktest bothers me

2) I write up a new feature

3) Test it a bit, and then make it into a quilt patch

4) After using it for a while, I'll do the git commit and push
   it off to linux-next

5) Merge window opens, I look at both my commits and my quilt queue
   and commit any missing patches that I feel is good enough

6) Push the entire thing off to Linus


ktest is very low on my priority list of things to maintain, and I
sometimes forget step 4. But I don't worry too much because it may miss
out on some testing, but if it breaks, it will only break ktest. It
shouldn't break anything else in the kernel.

And actually, I admit the last 3 patches of the series was written in
the last week and the other 2 a couple of weeks before that, as I was
adding a new machine to my test suite and added a Fedora 17 image for
the first time (first one without grub1 and with systemd), that it
caused me a lot of pain with my automated testing. I struggled with
grub2, got it mostly working, but then decided recently to just use
syslinux. I also just noticed the breakage that was there from the last
release, where the make oldnoconfig was changed. Hmm, maybe I should
look at linux-next more often, to see if anyone is touching ktest
without telling me.

I'll try to be better next time :-)  (no pun intended)

-- Steve


