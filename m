Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab1AaSJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:09:34 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54642 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab1AaSJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:09:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
Date: Mon, 31 Jan 2011 19:09:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>
References: <Pine.LNX.4.44L0.1101310957350.1931-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1101310957350.1931-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101311909.07333.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 31, 2011, Alan Stern wrote:
> On Sun, 30 Jan 2011, Rafael J. Wysocki wrote:
> 
> > > One thing about this implementation is slightly questionable.  The new
> > > power_domain callbacks were added to the __weak platform PM routines,
> > > which means they will have to be included in every overriding routine
> > > provided by a platform imiplementation.
> > > 
> > > Would it be better to separate these things?  Have the power_domain 
> > > callbacks occur in a static outer function which then calls a public 
> > > __weak inner function that can be overridden?
> > 
> > That certainly is a good idea, but I wasn't sure how to do that.  It looks
> > like I could keep the __weak functions as they are and modify
> > platform_dev_pm_ops instead to point to a new set of function that in turn
> > would call the __weak ones.  For example, the .suspend pointer in
> > platform_dev_pm_ops might point to a new function, say
> > platform_pm_full_suspend() that would call the power domain functions and
> > the "original" platform_pm_suspend().  Is that what you mean?
> 
> Yes.  But what about the platform_bus_set_pm_ops() interface?  Should
> platform-specific replacements for the pm_ops functions also include
> the power_domain callbacks?

Well, whoever uses platform_bus_set_pm_ops(), he can simply prevent power
domains from being used by not defining them in the first place. :-)

Rafael
