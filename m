Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab1CVIpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:45:32 -0400
Received: from smtp.nokia.com ([147.243.128.24]:53908 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab1CVIpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:45:30 -0400
Subject: Re: [RFC] pstore: Don't use persistent store for normal shutdown
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
To: "ext Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Seiji Aguchi <seiji.aguchi@hds.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
References: <4d8797d74168a6441@agluck-desktop.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Tue, 22 Mar 2011 10:42:45 +0200
Message-ID: <1300783365.2735.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 11:24 -0700, ext Luck, Tony wrote:
> In commit 04c6862c055fb687c90d9652f32c11a063df15cf
> kmsg_dump: add kmsg_dump() calls to the reboot, halt, poweroff and emergency_restart paths
> 
> Seiji Aguchi added kmsg_dump options for all the "normal" ways
> that a system can be shut down (KEXEC, RESTART, HALT and POWEROFF).
> It doesn't seem useful to save the kernel log to persistent store
> in these cases.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> 
> ---
> 
> My /dev/pstore changes have been merged - and I immediately noticed that they
> now save a record on every shutdown.  Some simple detective work with git found
> that kmsg_dump now has some new "reasons" for calling its subscribers.
> 
> This patch excludes the four "normal shutdown" cases from being logged
> to persistent store, on the assumption that we don't want to clutter up
> a limited amount of storage space with routine data.  My presumption is
> that there is some other subscriber to kmsg_dump that is doing something
> with these reason codes ... is that right?  Or do you think that we should
> save the tail of kernel log into persistent store for every shutdown?
> 
> Perhaps we could save less data for these new reasons? Other ideas?

If you ask me, this smells like policy in the kernel. I'd look into the
direction of having only the mechanisms in the kernel and letting the
user-space making policy decisions by choosing what he wants to filter
out and what he wants to store via some pstore interfaces.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

