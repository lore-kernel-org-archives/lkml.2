Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2BFWvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:51:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab2BFWvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:51:24 -0500
Date: Mon, 6 Feb 2012 23:51:22 +0100
From: Jan Kara <jack@suse.cz>
To: Gerard Saraber <gsaraber@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Soft lockup problem
Message-ID: <20120206225122.GF24840@quack.suse.cz>
References: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOgv-ziomS-+ML0Xb4oSoWTjzkG8BBBQcMjXwn7rjQV2pFtQ6Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 06-02-12 09:40:45, Gerard Saraber wrote:
> Greetings everyone,
> I've been having a bit of a problem since upgrading to the linux 3.x
> series, I have a machine that we're using as a NAS that runs various
> rsync processes (mostly at night), lately after a day or two, I will
> come in in the morning to a load average of 49, but the machine not
> really doing anything, when trying to run 'dstat' the command just
> hung with no output at all. there were no errors in the logs, or even
> anything that would vaguely point at anything I could work with.
> So needing to get the machine back to work I attempted to reboot it
> "shutdown -r now" on console... it gives a nice message saying it's
> going to reboot, but nothing ever happens.. the only way to reboot it
> is by using ctrl + alt + sysrq + b. after which the machine reboots
> and the raid array comes back clean.
> 
> I'm not sure how to troubleshoot this, any pointers would be appreciated.
> 
> I'm compiling 3.2.4 at the moment and found a bunch of possibly useful
> options in the kernel debugging section:
> detect hard/soft lockups and detect hung tasks, maybe it'll give me
> something more to go on.
> 
> Some details about the machine:
> Linux xenbox 3.2.2 #1 SMP Sun Jan 29 10:28:22 CST 2012 x86_64 Intel(R)
> Xeon(R) CPU 5140 @ 2.33GHz GenuineIntel GNU/Linux
> It has 3 software raid arrays (2 x 5 drives and 1 x 4 drives) LVM'ed
> together into a 23TB XFS filesystem.
> 6GB memory and a pair of Intel Gigabit ethernet controllers bonded together.
  Hmm, might be some deadlock in the filesystem. Adding XFS guys to CC.
Can you run 'echo w >/proc/sysrq-trigger' and post output of dmesg here?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
