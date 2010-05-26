Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0EZWYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:24:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44859 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab0EZWYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:24:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Thu, 27 May 2010 00:25:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: James Bottomley <James.Bottomley@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu
References: <1274863342.5882.4850.camel@twins> <1274894685.4467.758.camel@mulgrave.site> <alpine.LFD.2.00.1005261948290.2995@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005261948290.2995@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270025.33579.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010, Thomas Gleixner wrote:
> On Wed, 26 May 2010, James Bottomley wrote:
> > On Wed, 2010-05-26 at 19:01 +0200, Peter Zijlstra wrote:
> > > On Wed, 2010-05-26 at 18:59 +0200, Pavel Machek wrote:
> > > > On Wed 2010-05-26 18:28:28, Peter Zijlstra wrote:
> > > > > On Wed, 2010-05-26 at 11:18 -0500, James Bottomley wrote:
> > > > > > > Or make the suspend manager a C proglet and provide a JNI interface,
> > > > > > > or whatever.
> > > > > > 
> > > > > > It's a fairly large piece of code to try to rewrite in C, so I don't
> > > > > > think that's feasible on a reasonable timescale.  Android does have the
> > > > > > concept of special sockets that can be used to communicate from less to
> > > > > > more privileged processes (it has a very segmented runtime model), so
> > > > > > these might be usable ... they have a drawback that they're essentially
> > > > > > named pipes, so no multiplexing, but one per suspend influencing C
> > > > > > process shouldn't be a huge burden. 
> > > > > 
> > > > > It wouldn't need to convert the whole Frameworks layer into C, just
> > > > > enough to manage the suspend state.
> > > > > 
> > > > > Anyway, I think there's been enough arguments against even the concept
> > > > > of opportunistic/auto-suspend, and I for one will object with a NAK if
> > > > > Rafael send this to Linus.
> > > > 
> > > > It was submitted already. I tried to followup with NAK, but can't
> > > > currently see it in the archive.
> > 
> > You mean this one:
> > 
> > https://lists.linux-foundation.org/pipermail/linux-pm/2010-May/025689.html
> > 
> > ?
> > 
> > > It was apparently hidden on some funky list.
> > 
> > Sending a PM pull request to the PM list doesn't really strike me as the
> > height of obfuscation.  Plus almost everyone who objected was on the cc
> > list.
> > 
> > >  Hiding pull requests is bad enough, but hiding pull requests for
> > > contended features is just plain wrong.
> > 
> > I don't think it's a conspiracy ... just standard operating procedure
> > for this subsystem.  I do think cc'ing lkml is good practise (having
> > been yelled at for not doing that in the past) but it's certainly not
> > universal practise.
> 
> At least it would be good style for a topic which is

As I said in another message, I intended to send the pull request to the LKML,
but for some reason that didn't work.  Perhaps that was my fault, so sorry for
that, but I think the CC list contained people who had objections, so they
easily could respond (adding the CC to the LKML).

>    1) contended like this one
> 
>    2) pushing an intrusive feature last minute which has been merged
>       into the pm tree barely two days ago.

It had been discussed for a month before without any serious progress, though,
so I simply had to do something to make things go. :-)

> Darn, _we_ have to deal with that forever as it sets a crappy user
> space ABI in stone.

Well, I don't think it's _that_ bad, although it isn't nice either.

The whole reason why it's there is because the Google people want to collect
suspend blocker usage statistics, so that they can easily check how often
applications block suspending.  If we dropped the statistics part, the
interface might be substantially simplified.

Thanks,
Rafael



> 
> Thanks,
> 
> 	tglx
> 
> 

