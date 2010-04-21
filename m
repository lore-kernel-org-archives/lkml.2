Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0DUUMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:12:24 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52289 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756320Ab0DUUMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:12:21 -0400
Date: Wed, 21 Apr 2010 21:12:17 +0100
From: Hedi Berriche <hedi@sgi.com>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
	pid_max v2
Message-ID: <20100421201216.GW16427@zorg.emea.sgi.com>
References: <4BCE579C.5070100@sgi.com> <4BCE5A73.3000904@sgi.com> <20100421102350.4c222e6b@lxorguk.ukuu.org.uk> <20100421165934.GN16427@zorg.emea.sgi.com> <20100421185852.3397f1da@lxorguk.ukuu.org.uk> <20100421191213.GR16427@zorg.emea.sgi.com> <20100421195106.GA15958@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421195106.GA15958@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 20:52 Greg KH wrote:
| On Wed, Apr 21, 2010 at 08:12:13PM +0100, Hedi Berriche wrote:
| > Let's also not forget all those ephemeral user space tasks (udev and the likes)
| > that will be spawned at boot time on even large systems with even more
| > thousands of disks, arguably one might consider hack initrd and similar to work
| > around the problem and set pid_max as soon as /proc becomes available but it's
| > a bit of a PITA.
| 
| udev should properly handle large numbers of cpus and the tasks that it
| spawns so as to not overload things.  If not, and you feel it is
| creating too many tasks, please let the udev developers know and they
| will be glad to work with you on this issue.

Just to be clear here --and be done with the udev parenthesis-- we kind of need
udev to take advantage of the fact that there's a large number of CPUs on the
machine especially on in the case of a config with thousands of disks, as that
shortens the time required to have a box in a working state with all disks
available and all.

IOW, I am not after throttling or serialising udev, just mentioned it as an
example of user space beast that can contribute --in the current state of things--
to the need of having a large number of pid_max on certain configurations.

That said I do realise that bit too should be looked at and any problems, as you
quite rightly pointed out, should be discussed with the udev chaps.

Cheers,
Hedi.
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
