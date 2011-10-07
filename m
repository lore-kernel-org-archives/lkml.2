Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab1JGAUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 20:20:21 -0400
Received: from tango.0pointer.de ([85.214.72.216]:46454 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab1JGAUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 20:20:20 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 20:20:20 EDT
Date: Fri, 7 Oct 2011 02:13:56 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111007001356.GA11994@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <m2lisx3cpl.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2lisx3cpl.fsf@firstfloor.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06.10.11 16:46, Andi Kleen (andi@firstfloor.org) wrote:

> 
> Kay Sievers <kay.sievers@vrfy.org> writes:
> >
> > * allow changing argv[] of a process without mucking with environ[]:
> > Something like setproctitle() or a prctl() would be ideal. Of course
> > it
> 
> prctl(PR_SET_NAME, ...)
> 
> The only problem is that some programs still use argv[] and get the old
> name, but at least it works in "top"

Well, I am aware of PR_SET_NAME, but that modifies comm, not argv[]. And
while "top" indeed shows the former, "ps" shows the latter. We are looking
for a way to nice way to modify argv[] without having to reuse space
from environ[] like most current Linux implementations of
setproctitle() do.

A while back there were patches for PR_SET_PROCTITLE_AREA floating
around. We'd like to see something like that merged one day.

> > * SCM_COMM, with a similar use case as SCM_CGROUPS. This auxiliary
> > control message should carry the process name as available
> > in /proc/$PID/comm.
> 
> That sounds super racy. No guarantee at all this is unique and useful
> for anything and everyone can change it.

Well, it's interesting in the syslog case, and it's OK if people can
change it. What matters is that this information is available simply for
the informational value. Right now, if one combines SCM_CREDENTIALS and
/proc/$PID/comm you often end up with no information about the senders
name at all, since at the time you try to read comm the PID might
actually not exist anymore at all. We are simply trying to close this
particular race between receiving SCM_CREDENTIALS and reading
/proc/$PID/comm here, we are not looking for a way to make process names
trusted.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
