Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab1A3QDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 11:03:34 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39980 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750780Ab1A3QDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 11:03:33 -0500
Date: Sun, 30 Jan 2011 11:03:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
In-Reply-To: <201101300107.19389.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1101301100090.6500-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Jan 2011, Rafael J. Wysocki wrote:

> Hi,
> 
> This is something we discussed during the last Linux Plumbers Conference.
> 
> The problem appears to be that the same device may be used in different
> systems in different configurations such that actions necessary for the
> device's power management can vary from one system to another.  In those
> cases the drivers' power management callbacks are generally not sufficient,
> because they can't take the configuration of the whole system into account.
> 
> I think this issue may be addressed by adding objects that will represent
> power domains and will provide power management callbacks to be executed
> in addition to the device driver's PM callbacks, which is done by the patch
> below.
> 
> Please have a look at it and tell me what you think.

One thing about this implementation is slightly questionable.  The new
power_domain callbacks were added to the __weak platform PM routines,
which means they will have to be included in every overriding routine
provided by a platform imiplementation.

Would it be better to separate these things?  Have the power_domain 
callbacks occur in a static outer function which then calls a public 
__weak inner function that can be overridden?

Alan Stern


