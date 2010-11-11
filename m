Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0KKFVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 00:21:38 -0500
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:7621 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757030Ab0KKFVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 00:21:36 -0500
From: Bruno Randolf <br1@einfach.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v6] Add generic exponentially weighted moving average (EWMA) function
Date: Thu, 11 Nov 2010 14:21:49 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: randy.dunlap@oracle.com, peterz@infradead.org, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        kosaki.motohiro@jp.fujitsu.com, kevin.granade@gmail.com,
        "John W. Linville" <linville@tuxdriver.com>
References: <20101111034756.15014.2156.stgit@localhost6.localdomain6> <20101110200231.aaa51b47.akpm@linux-foundation.org>
In-Reply-To: <20101110200231.aaa51b47.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011111421.49464.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu November 11 2010 13:02:31 Andrew Morton wrote:
> On Thu, 11 Nov 2010 12:47:56 +0900 Bruno Randolf <br1@einfach.org> wrote:
> > ...
> > 
> > The original idea for this implementation came from the rt2x00 driver
> > (rt2x00link.c). I would like to use it in several places in the mac80211
> > and ath5k code and I hope it can be useful in many other places in the
> > kernel code.
> > 
> > ...
> > 
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
> > 
> >  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o
> >  random32.o \
> >  
> >  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> > 
> > -	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
> > +	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o average.o
> 
> It would be a bit strange to merge this into 2.6.36-rcX when there are
> no callers.  But you do want it to be present in some tree for your own
> testing and distribution purposes.
> 
> So perhaps it would be best to merge this via the wireless tree, so
> everything exists in one place and it can be fed into linux-next and
> into mainline in an orderly fashion.
> 
> If that sounds like a plan then I can send this patch in John's
> direction.  Which means that if he merges it into mainline without also
> merging any of your patches which _use_ this function then we still end
> up with unused code in mainline, but at least that way it wasn't my fault
> ;)
> 
> Let me know your thoughts?

Sounds like a good plan to me. But let's hear Johns opinion.

I have a patch or two using this function, which I hope will get merged into 
wireless-testing soon after, but obviously it's up to John. There are more 
places in the wireless part which could make use of this function (right now 
each have their own EWMA implementation), and I'll try to get them all 
updated, but finally it's the individual maintainers, who decide if they want 
to make that change or not, I guess.

> (And it's a bit sad that the function will exist in the base vmlinux
> even for people who don't ever use it, but that's a problem which we
> don't really have a good solution for).

Hmm, should I switch it back to all inlines?

On the other hand, if a generic EWMA function is useful at all I guess it 
could be used in many places all over the kernel. Unfortunately I don't have 
time and knowledge to find all these places and update them to use the generic 
code.

bruno
