Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263Ab2EaL4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:56:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62998 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab2EaL4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:56:00 -0400
Subject: Re: [PATCH] tty: annotate tty_lock() for lockdep
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Alan Cox <alan@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <20120531113115.GA1548@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1205282042290.15057@pobox.suse.cz>
	 <20120531113115.GA1548@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 May 2012 13:55:54 +0200
Message-ID: <1338465354.2760.1336.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 17:01 +0530, Srikar Dronamraju wrote:
> Hi Jiri, 
> 
> 
> 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 3.4.0-08218-gb48b2c3 #7 Not tainted
> > ---------------------------------------------
> > blogd/279 is trying to acquire lock:
> >  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f51e>] tty_lock+0x3e/0x90
> > 
> > but task is already holding lock:
> >  (&tty->legacy_mutex){+.+.+.}, at: [<ffffffff8150f51e>] tty_lock+0x3e/0x90
> > 
> > other info that might help us debug this:
> >  Possible unsafe locking scenario:
> > 
> >        CPU0
> >        ----
> >   lock(&tty->legacy_mutex);
> >   lock(&tty->legacy_mutex);
> > 
> >  *** DEADLOCK ***
> > 
> 
> I saw a similar problem and applied your patch, but that doesnt seem to
> help me.

I was not aware of Jiri patch

Try this one instead :

https://lkml.org/lkml/2012/5/31/125



