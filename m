Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1JBTue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:50:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53947 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab1JBTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:50:28 -0400
Date: Sun, 2 Oct 2011 12:50:23 -0700
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tigran@aivazian.fsnet.co.uk,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111002195023.GC31799@mtj.dyndns.org>
References: <4E88B5E0.6080503@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E88B5E0.6080503@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Oct 03, 2011 at 12:35:04AM +0530, Srivatsa S. Bhat wrote:
> So, this patch addresses this issue by ensuring that microcode is not freed
> from kernel memory, nor invalidated when a CPU goes offline. Thus once the
> kernel gets the microcode during boot-up, it will never have to depend on
> userspace ever again to get microcode, since it never releases the copy it
> already has. So every run of the microcode callback for CPU online event will
> now succeed irrespective of whether userspace is frozen or not. As a result,
> this fixes the task freezing failure encountered while running CPU hotplug
> stress test along with suspend/resume operations simultaneously.

I'm not familiar with how microcode is supposed to be managed but is
it impossible for the newly hotplugged CPU (an actual hot unplug /
plug) may not like the microcode loaded for the previous CPU?  Isn't
that why CPU_DEAD was invalidating the microcode?

Thanks.

-- 
tejun
