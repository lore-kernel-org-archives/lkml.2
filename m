Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab1JGB5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 21:57:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37512 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1JGB5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 21:57:37 -0400
Date: Fri, 7 Oct 2011 03:57:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Andi Kleen <andi@firstfloor.org>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111007015732.GZ14482@one.firstfloor.org>
References: <1317943022.1095.25.camel@mop> <m2lisx3cpl.fsf@firstfloor.org> <20111007001356.GA11994@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111007001356.GA11994@tango.0pointer.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, I am aware of PR_SET_NAME, but that modifies comm, not argv[]. And
> while "top" indeed shows the former, "ps" shows the latter. We are looking
> for a way to nice way to modify argv[] without having to reuse space
> from environ[] like most current Linux implementations of
> setproctitle() do.

It's not clear to me how the kernel could change argv[] any better than you 
could in user space.

> Well, it's interesting in the syslog case, and it's OK if people can
> change it. What matters is that this information is available simply for
> the informational value. Right now, if one combines SCM_CREDENTIALS and
> /proc/$PID/comm you often end up with no information about the senders
> name at all, since at the time you try to read comm the PID might
> actually not exist anymore at all. We are simply trying to close this
> particular race between receiving SCM_CREDENTIALS and reading
> /proc/$PID/comm here, we are not looking for a way to make process names
> trusted.

The issue with all of these proposals is that the sender currently doesn't
know if the receiver needs it. Thus it always has to put it in and you
slow down the fast paths.

e.g. consider

sender sends packet
                                     receiver enables funky option
                                     receiver reads

If it was done lazily you would lose.

Also there are usually various complications with namespaces.

-Andi
