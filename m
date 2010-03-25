Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab0CYVc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 17:32:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51543 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab0CYVc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 17:32:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 06/15] PM / Hibernate: swap, remove swap_map_handle usages
Date: Thu, 25 Mar 2010 22:35:35 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <20100324203329.GG5798@elf.ucw.cz> <4BAA842A.6060906@gmail.com>
In-Reply-To: <4BAA842A.6060906@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252235.35500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Jiri Slaby wrote:
> On 03/24/2010 09:33 PM, Pavel Machek wrote:
> > On Tue 2010-03-23 17:17:34, Jiri Slaby wrote:
> >> Some code, which will be moved out of swap.c, needs know nothing about
> >> swap. There will be also other than swap writers later, so that it
> >> won't make sense at all.
> >>
> >> Make it a global static in swap.c as a singleton.
> > 
> > I guess I just dislike global static. Logically, methods do operate on
> > handles, so...
> 
> Ok, "upper layers" may get a handle via .get_reader/writer. The downside
> is that they would have to get (void *) and pass (void *) down again. I
> wanted to avoid that (taking into account that it's a singleton).
> 
> > I don't see a point and I do not think the change is an improvement.
> 
> The point was to avoid (void *)'s and save users from transferring
> pointer as a handle. No matter what, the decision is not up to me,
> discussion indeed welcome.

The whole thing boils down to whether or not there may be more than one
swap map in use at a time.

Perhaps it's better to use a static pointer, though?

And I don't really know at this point how exactly this change is going to make
your life easier down the road.  Care to elaborate?

Rafael
