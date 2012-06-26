Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab2FZAXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:23:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59231 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab2FZAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:23:12 -0400
Date: Mon, 25 Jun 2012 17:23:07 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120626002307.GA4389@kroah.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com>
 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 05:01:11PM -0700, Linus Torvalds wrote:
> On Mon, Jun 25, 2012 at 4:55 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Stephen and Ingo, I understand that your tests now would require
> > multiple printk() lines, but this affects what, 10 boxes in the world
> > that run these tests (I'm not trying to be mean, just understand the
> > issues).  The fixes that now are in place fix problems for many more
> > systems, and provide the infrastructure for proper logging that people
> > have been screaming at us for over 10 years to accomplish.
> 
> I disagree violently.
> 
> I think we absolutely should apply Steven's patch.
> 
> Why? Because the buffering does not help *anything*, and it's
> surprising, and it breaks one of our main debugging tools. There's no
> upside to it.

Ok, but I thought you wanted the "properly handle continuations" that we
now have in the kernel.  I must be mistaken.

> The fact that we found *one* case where it broke within days of it
> being introduced is not the issue. Fixing that one case is irrelevant.
> It's the unknown number of other cases that did similar thngs that
> matter.
> 
> If there are other places that print out partial lines, they may have
> this problem too. Don't buffer.
> 
> And if there are *not* other places that print out partial lines, then
> buffering doesn't help. Don't buffer.
> 
> Notice? Buffering partial lines is never *ever* the right thing to do
> for something like printk.
> 
> If you want to merge the partial lines, do it at the *logging* stage,
> not at the printout stage. Nobody cares if you buffer the stuff that
> actually makes it to "dmesg". But buffering the stuff before it makes
> it to the screen is just wrong.

Ok, Kay, does Stephen's patch work for you as well?  I'll go boot a box
with it and look at the output, but that will take 30 minutes or so...

greg k-h
