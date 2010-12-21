Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab0LUJ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:56:52 -0500
Received: from tango.0pointer.de ([85.214.72.216]:45668 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703Ab0LUJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:56:51 -0500
Date: Tue, 21 Dec 2010 10:56:25 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Scott James Remnant <scott@netsplit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 for  child processes
Message-ID: <20101221095625.GA4438@tango.0pointer.de>
References: <AANLkTik052sWOtqNyVdg6g6+cvo-NE-TBdSGdmmp_7en@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik052sWOtqNyVdg6g6+cvo-NE-TBdSGdmmp_7en@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20.12.10 14:26, Scott James Remnant (scott@netsplit.com) wrote:

> > This patch adds a simple flag for each process that marks it as an
> > "anchor" process for all its children and grandchildren. If a child of
> > such an anchor dies all its children will not be reparented to init, but
> > instead to this anchor, escaping this anchor process is not possible. A
> > task with this flag set hence acts is little "sub-init".
> >
> Why can't you simply begin a new pid namespace with the session
> manager or other process supervisor?  That way the session
> manager/process supervisor is for all intents and purposes an init
> daemon, so shouldn't be surprised about getting SIGCHLD.

PID namespaces primarily provide an independent PID numbering scheme for
a subset of processes, i.e. so that identical may PIDs refer to different
processes depending on the namespace they are running in. As a side
effect this also provides init-like behaviour for processes that aren't
the original PID 1 of the operating system. For systemd we are only
interested in this side effect, but are not interested at all in the
renumbering of processes, and in fact would even really dislike if it
happened. That's why PR_SET_ANCHOR is useful: it gives us init-like
behaviour without renaming all processes.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
