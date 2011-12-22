Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1LVDx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:53:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54507 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab1LVDxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:53:24 -0500
Date: Wed, 21 Dec 2011 19:49:53 -0800
From: Greg KH <gregkh@suse.de>
To: Brian Swetland <swetland@google.com>
Cc: NeilBrown <neilb@suse.de>, Tim Bird <tim.bird@am.sony.com>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222034953.GC14174@suse.de>
References: <4EF264C3.6000104@am.sony.com>
 <20111221231956.GB23859@suse.de>
 <4EF27B85.9080801@am.sony.com>
 <20111222122026.3a0fae36@notabene.brown>
 <CANqkERC+mdSGxk4tiU7+dbauSXqqANN+Z+TTb_pVXoPq+k=rJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqkERC+mdSGxk4tiU7+dbauSXqqANN+Z+TTb_pVXoPq+k=rJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 06:34:08PM -0800, Brian Swetland wrote:
> The goals behind the logger driver have been:
> - keep userland and kernel logging separate (so that spammy userland
> logging doesn't make us lose critical kernel logs or the other way
> round)

Wouldn't a simple userspace daemon solve this, writing the data to a
ramfs file?

> - make log writing very inexpensive -- avoid having to pass messages
> between processes (more critical on ARM9 platforms where this implied
> extra cache flushing), avoid having to make several syscalls to write
> a log message (getting time of day, etc), and so on

ramfs?

> - make log writing reliable -- don't trust userland to report its
> timestamp, PID, or to correctly format the datagrams, etc

existing userspace printk tty driver?

> - allow a log watching process (logcat) to easily pull data from all
> logs at once

what do you mean by "at once"?

> - avoid committing a vast amount of memory to logging

memory where, in code or in the data being logged?

> - try to prevent clients from spamming each other out of log space
> (only successful on a coarse granularity right now with the
> main/system/radio/events logs)
> - ensure logs are not lost at the moment an app crashes

Which logs?

> On one hand, having each app (per PID) be able to create their own
> logs up to a specified size limit could be really useful and is
> something we've kicked around -- for one it would allow us to avoid
> the ever present request from userspace developers to increase the log
> size because of too much log spam ("reduce log spam" never seems to be
> an answer that makes them happy) -- but we haven't come up with a
> reasonable plan for dealing with "well if we allow 16KB of log per app
> and the user installs 100 apps, they may be pinning up to 1.6MB of ram
> worst case", and so on.

I think the userspace printk and syslog might already handle most of
this today.  Tim, care to look into that and see if it does or not?

thanks,

greg k-h
