Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab0LWPpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:45:25 -0500
Received: from tango.0pointer.de ([85.214.72.216]:35855 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0LWPpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:45:24 -0500
Date: Thu, 23 Dec 2010 16:44:59 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Scott James Remnant <scott@netsplit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 for  child processes
Message-ID: <20101223154458.GB17788@tango.0pointer.de>
References: <AANLkTik052sWOtqNyVdg6g6+cvo-NE-TBdSGdmmp_7en@mail.gmail.com>
 <20101221095625.GA4438@tango.0pointer.de>
 <AANLkTi=GGGP4vK1hOBn-+oCAM1gFXg_XUfLeTFM2CqA_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=GGGP4vK1hOBn-+oCAM1gFXg_XUfLeTFM2CqA_@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21.12.10 12:05, Scott James Remnant (scott@netsplit.com) wrote:

> > PID namespaces primarily provide an independent PID numbering scheme for
> > a subset of processes, i.e. so that identical may PIDs refer to different
> > processes depending on the namespace they are running in. As a side
> > effect this also provides init-like behaviour for processes that aren't
> > the original PID 1 of the operating system. For systemd we are only
> > interested in this side effect, but are not interested at all in the
> > renumbering of processes, and in fact would even really dislike if it
> > happened. That's why PR_SET_ANCHOR is useful: it gives us init-like
> > behaviour without renaming all processes.
> >
> Right, but I don't get why you need this behavior to supervise either
> system or user processes.  You already get all the functionality you
> need to track processes via either cgroups or the proc connector (or a
> combination of both).

Well, we want a clean way to get access to the full siginfo_t of the
SIGCHLD for the main process of a service. the proc connector is awful
and cgroups does not pass siginfo_t's back to userspace, hence the
cleanest way to get this done properly and beautifully is to make the
session systemd a mini-init via PR_SET_ANCHOR, because then the per-user
systemd's and the per-system systemd can use the exact same code to
handle process managment.

> So is this really just about making ps look pretty, as Kay says?

That's a side effect, but for me it's mostly about getting a simple way
to get the SIGCHLDs, focussed on the children of the session manager and
with minimal wakeups.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
