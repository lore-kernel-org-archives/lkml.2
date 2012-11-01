Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762190Ab2KATBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:01:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56323 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab2KATBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:01:21 -0400
Date: Thu, 1 Nov 2012 20:01:19 +0100
From: Jan Kara <jack@suse.cz>
To: Marcus Sundman <marcus@hibox.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20121101190119.GA27294@quack.suse.cz>
References: <508DB432.2030208@hibox.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508DB432.2030208@hibox.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29-10-12 00:39:46, Marcus Sundman wrote:
  Hello,

> I have a big problem with the system freezing and would appreciate
> any help on debugging this and pinpointing where exactly the problem
> is, so it could be fixed.
> 
> So, whenever I write to the disk the system comes to a crawl or
> freezes altogether. This happens even when the writing processes are
> running on nice '19' and ionice 'idle'. (E.g. a 10 second compile
> could freeze the system for several minutes, rendering the computer
> pretty much unusable for anything interesting.)
> 
> Here you can see a 20 second gap even in superhigh priority:
> # nice -n -20 ionice -c1 iostat -t -m -d -x 1 > http://pastebin.com/j5qnh2VV
> 
> I'm currently running 3.5.0-17-lowlatency on the ZenBook UX31E,
> using the NOOP I/O scheduler on the SanDisk SSD U100. The chipset
> seems to be Intel QS67. I've had this same problem on 3.2.0 generic
> and lowlatency kernels.
  These are Ubuntu kernels. Any chance to reproduce the issue with vanilla
kernels - i.e. kernels without any Ubuntu patches? Also when you speak of
system freezing - can you e.g. type to terminal while the system is frozen?
Or is it just that running commands freezes? And how much free memory do
you have while the system is frozen? Finally, can you trigger the freeze by
something simpler than compilation - e.g. does
  dd if=/dev/zero of=/tmp bs=1M
trigger the freeze as well?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
