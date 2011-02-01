Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1BADku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:40:50 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38484 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751789Ab1BADkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:40:49 -0500
Date: Mon, 31 Jan 2011 22:40:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kevin Hilman <khilman@ti.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC][PATCH] Power domains for platform bus type
In-Reply-To: <871v3s3ahe.fsf@ti.com>
Message-ID: <Pine.LNX.4.44L0.1101312235190.11313-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Kevin Hilman wrote:

> For the on-chip SoC devices we're managing with OMAP, we're currently
> only using one set: post ops on [runtime_]suspend and pre ops on
> [runtime_]resume.
> 
> However, I could imagine (at least conceptually) using the pre ops on
> suspend to do some constraints checking and/or possibly some
> management/notification of dependent devices.  Another possiblity
> (although possibly racy) would be using the pre ops on suspend to
> initiate some high-latency operations.

Dependency management is very relevant here, since we're talking about
relations that explicitly aren't of the parent-child type.  If any of
the devices in question get marked for async suspend/resume, for
example, they certainly will need dependency handling.

> I guess the main problem with two sets is wasted space.  e.g, if I move
> OMAP to this (already hacking on it) there will be only 2 functions used
> in post ops: [runtime_]suspend() and 2 used in pre ops [runtime_]_resume().

The wasted space is minimal; we're only talking about one extra pm_ops
structure for each power domain.  Presumably any reasonable SoC isn't
going to have a tremendous number of separate power domains.  Or am I
wrong about this?

Alan Stern

