Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab1JCAk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 20:40:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63038 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1JCAkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 20:40:55 -0400
Date: Sun, 2 Oct 2011 17:40:51 -0700
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111003004051.GD31799@mtj.dyndns.org>
References: <4E88B5E0.6080503@linux.vnet.ibm.com>
 <20111002195023.GC31799@mtj.dyndns.org>
 <4E88C3D4.2020300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E88C3D4.2020300@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 03, 2011 at 01:34:36AM +0530, Srivatsa S. Bhat wrote:
> So when a CPU goes offline and comes back online, I don't see why the kernel
> should not reuse the microcode that it already has. Anyhow the microcode will
> not change. The same microcode would be requested from userspace again if the
> kernel has freed its copy.

Can't one take a cpu offline, hot unplug it from the board and put in
a new one and then bring it online?  That's usually what "hot
[un]plug" stands for.  I don't think one would be able to put in a
very different processor but maybe, say, revision difference is
allowed and microcode should be looked up again?  Assuming that the
same microcode can always be applied after the actual CPU is swapped
could be dangerous.  Again, I'm not sure about how this is supposed to
be managed so I could be wrong.

If I'm not wrong, can't we add synchronization between cpu hotplug and
freezer so that they don't happen in parallel?

Thanks.

-- 
tejun
