Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab1CDHj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:39:59 -0500
Received: from quamquam.org ([88.198.196.3]:34690 "EHLO quamquam.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab1CDHj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:39:58 -0500
Date: Fri, 4 Mar 2011 08:39:44 +0100
From: Daniel Poelzleithner <poelzi@poelzi.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, containers@lists.linux-foundation.org
Message-ID: <20110304083944.22fb612f@sol>
Reply-To: linux-kernel@vger.kernel.org
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 194.77.75.60
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, containers@lists.linux-foundation.org
X-SA-Exim-Mail-From: poelzi@poelzi.org
Subject: cgroup memory, blkio and the lovely swapping
X-SA-Exim-Version: 4.2.1 (built Sat, 07 Nov 2009 20:03:47 +0000)
X-SA-Exim-Scanned: Yes (on quamquam.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

currently when one process causes heavy swapping, the responsiveness of
the hole system suffers greatly. With the small memleak [1] test tool I
wrote, the effect can be experienced very easily, depending on the
delay the lag can become quite large. If I ensure that 10% of the RAM
stay free for free memory and cache, the system never swaps to death.
That works very well, but if accesses to the swap are very heavy, the
system still lags on all other processes, not only the swapping one.
Putting the swapping process into a blkio cgroup with little weight does
not affect the io or swap io from other processes with larger weight in
their group.

Maybe I'm mistaken, but wouldn't it be the easiest way to get fair
swapping and control to let the pagein respect the blkio.weight value
or even better add a second weight value for swapping io ?



kind regards
  Daniel


[1] https://github.com/poelzi/ulatencyd/blob/master/tests/memleak.c
