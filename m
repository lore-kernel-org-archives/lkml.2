Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1AaPBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:01:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55620 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752016Ab1AaPBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:01:16 -0500
Date: Mon, 31 Jan 2011 10:01:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
In-Reply-To: <201101302339.02993.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1101310957350.1931-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jan 2011, Rafael J. Wysocki wrote:

> > One thing about this implementation is slightly questionable.  The new
> > power_domain callbacks were added to the __weak platform PM routines,
> > which means they will have to be included in every overriding routine
> > provided by a platform imiplementation.
> > 
> > Would it be better to separate these things?  Have the power_domain 
> > callbacks occur in a static outer function which then calls a public 
> > __weak inner function that can be overridden?
> 
> That certainly is a good idea, but I wasn't sure how to do that.  It looks
> like I could keep the __weak functions as they are and modify
> platform_dev_pm_ops instead to point to a new set of function that in turn
> would call the __weak ones.  For example, the .suspend pointer in
> platform_dev_pm_ops might point to a new function, say
> platform_pm_full_suspend() that would call the power domain functions and
> the "original" platform_pm_suspend().  Is that what you mean?

Yes.  But what about the platform_bus_set_pm_ops() interface?  Should
platform-specific replacements for the pm_ops functions also include
the power_domain callbacks?

Alan Stern

