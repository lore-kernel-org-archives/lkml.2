Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab2E1Ted (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 15:34:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:32587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab2E1Tec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 15:34:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="145512569"
Date: Mon, 28 May 2012 20:50:02 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: tty: AB-BA between tty->legacy_mutex and devpts_mutex
Message-ID: <20120528205002.17609388@bob.linux.org.uk>
In-Reply-To: <alpine.LNX.2.00.1205282100390.15057@pobox.suse.cz>
References: <alpine.LNX.2.00.1205282044410.15057@pobox.suse.cz>
	<alpine.LNX.2.00.1205282100390.15057@pobox.suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2012 21:02:15 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 28 May 2012, Jiri Kosina wrote:
> 
> > ======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 3.4.0-08219-g238d69d #11 Not tainted
> > -------------------------------------------------------
> > blogd/265 is trying to acquire lock:
> >  (devpts_mutex){+.+.+.}, at: [<ffffffff8134d696>]
> > pty_close+0x166/0x190
> > 
> > but task is already holding lock:
> >  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f632>]
> > tty_lock+0x22/0x29
> > 
> > which lock already depends on the new lock.
> 
> [ ... snip ... ]
> 
> > This deadlock scenario doesn't really seem realistic, as it's
> > between open()/close(). Not being really familiar with tty layer, I
> > am not sure what the proper lock ordering in this case is, I am
> > just reporting for you guys to decide how to get rid of this one.
> 
> This seems to have been caused by
> 
> commit d739e65bb21d34f0f5d3bf4048410e534fbec148
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Thu May 3 22:22:09 2012 +0100
> 
>     pty: Lock the devpts bits privately

Already fixed. It turned out we could just get rid of the lock there
anyway
