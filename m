Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab2FJU7D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 16:59:03 -0400
Received: from broadrack.ru ([195.178.208.66]:39285 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752497Ab2FJU7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 16:59:01 -0400
Date: Mon, 11 Jun 2012 00:58:55 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120610205855.GD4380@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
 <20120501213958.GA15560@ioremap.net>
 <20120502162627.50544c8b@notabene.brown>
 <20120503175857.GA13988@ioremap.net>
 <20120504070838.5bd23110@notabene.brown>
 <20120503212706.GA26612@ioremap.net>
 <20120509114349.5ceee472@notabene.brown>
 <20120515012634.GF25482@ioremap.net>
 <20120518160507.63cddc24@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518160507.63cddc24@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Sorry for *that* long delay, this mail was somehow dropped.

On Fri, May 18, 2012 at 04:05:07PM +1000, NeilBrown (neilb@suse.de) wrote:
> So to avoid deadlocks between w1 slaves and sysfs, these must be
> two separate locks.  Making them separate means that the work around
> in ds2780 and ds2781 can be removed.
> 
> So this patch:
>  - adds a new mutex: "bus_mutex" which serialises access to the bus.
>  - takes mutex in w1_search and ds1wm_search while they access
>    the bus for searching.  The mutex is dropped before calling the
>    callback which adds the slave.
>  - changes all slaves to use bus_mutex instead of mutex to
>    protect access to the bus
>  - removes w1_ds2790_io_nolock and w1_ds2781_io_nolock, and the
>    related code from drivers/power/ds278[01]_battery.c which
>    calls them.

Greg, can you put it into the tree when merge window opens (sorry, I do
not really know release cycle dates). Since other drivers basically are
not affected (only mutex name changed for them), it should be ok, but
this new feature should be told for all new device.

Also if deadlock will be caught somewhere in w1 in current tree (which
is possible, although unlikely - w1 users are usually embedded devices
where new sysfs files are created only at startup time), we can direct
authors to this thread.

> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Evgeniy Polyakov <zbr@ioremap.net>

-- 
	Evgeniy Polyakov
