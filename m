Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab0FUCdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 22:33:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:58179 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757856Ab0FUCdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 22:33:02 -0400
Date: Sun, 20 Jun 2010 22:33:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: markgross@thegnar.org
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
In-Reply-To: <20100620225810.GB9735@gvim.org>
Message-ID: <Pine.LNX.4.44L0.1006202223440.29532-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010, mark gross wrote:

> > Indeed, the same problem arises if the event isn't delivered to
> > userspace until after userspace is frozen.  Of course, the underlying
> > issue here is that the kernel has no direct way to know when userspace
> > has finished processing an event.  Userspace would have to tell it,
> > which generally would mean rewriting some large number of user
> > programs.
> 
> Suspend blockers don't solve this, and the large number of user programs
> isn't a big number.  /me thinks its 1 or 2 services.

On Android, perhaps.  What about on other systems?

> > In what way is this better than suspend blockers?
> 
> 1) I don't think suspend blockers really solve or effectively articulate
> the suspend wake event race problem.

Why not?

> 2) the partial solution suspend blocker offer for the suspend race is
> tightly bound to the suspend blocker implementation and not useful in
> more general contexts.

I don't understand.  Can you explain further?

> > One advantage of the suspend-blocker approach is that it essentially
> > uses a single tool to handle both kinds of races (event not fully
> > handled by the kernel, or event not fully handled by userspace).  
> > Things aren't quite this simple, because of the need for a special API
> > to implement userspace suspend blockers, but this does avoid the need
> > for a power-manager process.
> 
> I don't think suspend-blocker handles both kinds of races as well as you
> seem to think.

Can you give any counterexamples?

>  A single tool that conflates multiple kernel facilities
> is not an advantage.  It limits applications outside of the scope of
> doing it the "android way".

I don't see that necessarily as a drawback.  You might just as well say
that the entire Linux kernel limits applications to doing things the
"Unix" way.  Often have fewer choices is an advantage.

> Where do you get the idea that there isn't a need for a centralized PM
> process in Android?  Thats not true.

I didn't get that idea from anywhere.  Sorry if I gave the wrong
impression -- I meant that non-Android systems would need to implement
a centralized power-manager process, along with all the necessary
changes to other programs.

(Incidentally, even on Android the centralized PM process does not 
handle _all_ of the userspace/kernel wakelock interactions.)

Alan Stern

