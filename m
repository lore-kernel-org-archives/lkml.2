Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab1AXW6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:58:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:48602 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab1AXW6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:58:08 -0500
Date: Tue, 25 Jan 2011 08:57:58 +1000
From: Neil Brown <neilb@suse.de>
To: Harald Braumann <harry@unheit.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Deadlock on concurrent remount-ro and mdadm --stop (2.6.37)
Message-ID: <20110125085758.06df5e3e@nbeee.brown>
In-Reply-To: <20110123161500.GB4108@nn.nn>
References: <20110121124754.GA5233@nn.nn>
	<20110123161500.GB4108@nn.nn>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 17:15:00 +0100
Harald Braumann <harry@unheit.net> wrote:

> On Fri, Jan 21, 2011 at 01:47:54PM +0100, Harald Braumann wrote:
> > On shutdown `umountroot' and `mdadm-raid'  are executed
> > concurrently. The actual commands are:
> > mount -o remount,ro /
> > mdadm --stop --scan
> > 
> > This seems to trigger a deadlock in the kernel. Dumping blocked
> > tasks (sysrq-W) gives:
> > 
> > md126_raid5: call trace:
> >   md_super_wait
> >   autoremove_wake_function
> >   bitmap_unplug
> >   ...
> > 
> > mount: call trace:
> >   sync_page
> >   io_schedule
> >   sync_page
> 
> I've now disable parallel boot in my system, so umountroot and mdadm
> shouldn't be called cuncurrently anymore. But I still get lock-ups on
> mdadm --stop. Umountroot is called before mdadm --stop, and all other
> filesystems are unmounted before that, so I guess
> there should be no `sync_page' in progress anymore. But I also have
> swap on the raid, so maybe there's a problem?
> 
> As not even the magic SysRQ keys work, I can't provide any more
> details. Any suggestions how I could debug this problem?

Thanks for the bug report.
Extra useful details would include:
 cat /proc/mdstat
 cat /proc/mounts

i.e. what is the exact configuration of the RAID or RAIDs, and where
are they mounted.

Thanks,
NeilBrown
