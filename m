Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab0CQDWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:22:41 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0CQDWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:22:40 -0400
Subject: Re: Weird wireless/wpa_supplicant screw-up.
From: Johannes Berg <johannes@sipsolutions.net>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <12262.1268795213@localhost>
References: <7197.1268086939@localhost>
	 <1268392481.4828.7.camel@jlt3.sipsolutions.net> <5220.1268430568@localhost>
	 <1268449749.4880.2.camel@jlt3.sipsolutions.net>
	 <12262.1268795213@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 20:22:30 -0700
Message-ID: <1268796150.7068.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 23:06 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 12 Mar 2010 19:09:09 PST, Johannes Berg said:
> > No ... look at _all_ that it produces.
> > 
> > [   98.592575] In giwencode idx=0 keys=ffff88001b304000 cipher=0
> > [   98.592580] And we're going home...
> > *****
> > [   98.592633] In giwencode idx=1 keys=ffff88001b304000 cipher=fac04
> > *****
> > [   98.592749] In giwencode idx=2 keys=ffff88001b304000 cipher=0
> > [   98.592751] And we're going home...
> > [   98.592803] In giwencode idx=3 keys=ffff88001b304000 cipher=0
> > [   98.592805] And we're going home...
> > [   98.592856] In giwencode idx=0 keys=ffff88001b304000 cipher=0
> > [   98.592859] And we're going home...
> > 
> > See? It reports one key which is the RX-only group key which is
> > absolutely correct.
> 
> It matches what 'iwlist keys' reports, but I remain unconvinced of
> its "correctness".  

That's your problem then, not mine. It's correct in how wext operates.
If you want to know why, you'll have to understand the distinction
between PTK and GTK and how wext operates with them.

> If a TX key has been set anyplace, what allows me
> to verify that it was in fact set?

Nothing. Blame it on wext and on the fact that nobody cares.

> > > So the root cause has something to do with params[idx].cipher being unset.
> > 
> > Not at all.
> 
> I was referring to the root cause of why 'iwlist keys' wasn't reporting
> anything for the other 3 key slots.

Right ... all of that is completely correct. See above about PTK and
GTK ... You seem to not be interested in telling me what your actual
problem is, if there is one. If your actual problem is just that iwlist
reports what you think is wrong information (which is just incomplete,
it doesn't show the PTK) then that's nothing I actually care about
fixing.

> I'll point out that until fairly recently 'iwconfig' *did* report a
> key for WPA2, so this looks like a regression on somebody's part.

I'm sure it did not.

johannes

