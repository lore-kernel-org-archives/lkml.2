Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab2LHJac (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 04:30:32 -0500
Received: from hosting.adsl24.co.uk ([84.234.17.171]:55492 "EHLO
	hosting.adsl24.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab2LHJa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 04:30:28 -0500
X-Greylist: delayed 2611 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Dec 2012 04:30:28 EST
Date: Sat, 8 Dec 2012 08:47:34 +0000
From: Alun <auj@ty-penguin.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Alun <alun.linux@ty-penguin.org.uk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121208084734.36be9360@aspire.ty-penguin.org.uk>
In-Reply-To: <20121208012029.GR27172@dastard>
References: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
	<20121207004255.GC27172@dastard>
	<20121207085952.57ee1f22@pcebbj.staff.aber.ac.uk>
	<20121208012029.GR27172@dastard>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelisted: from local domain
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hosting.adsl24.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ty-penguin.org.uk
X-Get-Message-Sender-Via: hosting.adsl24.co.uk: authenticated_id: mail@typenguin.adsl24.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2012 12:20:29 +1100
Dave Chinner <david@fromorbit.com> wrote:

First off, thanks for the examples. I'll answer your one question and
then I'll shut up!

> > I'll try and chase this up by submitting patches to lvcreate and
> > fsfreeze (in the former case, I think there's no reason not to run
> > syncfs; in the latter perhaps it should be a command line option).
> 
> Is that even necesary? users can issue the sync themselves if
> necessary....

I think it's necessary for the issue to be better documented in LVM at
the very least. I've dabbled with LVM for nearly 10 years, and used it
in a busy production environment for around 6. For nearly 2 years I've
been seeing, every now and then, these odd cases where taking a snapshot
caused irrecoverable high load on the server. I've never seen any
mention anywhere of the advisability of manually running sync prior to
taking a snapshot on a busy system, and I had to get down to looking at
the kernel sources before I got an inkling this might be the issue. I'd
imagine that the vast majority of end users think the same way as I
did, viz that taking a snapshot was designed to have minimal effect on
any other users of the filesystem.

There's also the issue that AFAIK there's no commonly distributed
program which will allow you to call syncfs() on a filesystem. Running
sync is a bit of a sledgehammer approach for a busy system with
multiple large filesystems.

I've submitted a patch to util-linux, adding a --sync option to
fsfreeze which, if specified, will syncfs the requested filesystem
prior to any freeze operation. Hopefully they'll accept this, though
the only comment I've received so far suggested that I should be
submitting a kernel patch rather than band aiding it in userland!

Looking at the LVM sources, it would appear that the freezing of 
affected filesystems is done in the kernel side of device mapper. I'm
not going there!

Anyway, thanks for your time.

Cheers,
Alun.
