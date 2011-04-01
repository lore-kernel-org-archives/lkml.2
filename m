Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1DASdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:33:31 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:44840 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1DASda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:33:30 -0400
Date: Fri, 01 Apr 2011 14:33:24 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 0/9] x86 idle cruft removal - v2
In-reply-to: <4D959D25.5010805@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1104011313540.2606@x980>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
 <1301551404-8263-1-git-send-email-lenb@kernel.org>
 <alpine.LFD.2.02.1104010020280.2797@x980> <4D959D25.5010805@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I guess this would eliminate the problems caused by pm_idle.

Right.

...at least we can contain it inside process.c
where we still need to be able to handle halt/amd-bug/poll.
Probably I'll re-name it to better reflect its function,
say x86_default_idle, in this case.

> In that case I also think we need not implement a default
> driver (like the one I had done https://lkml.org/lkml/2011/3/22/154)
> to handle the case when acpi_idle and intel_idle may not register.

Right.

the stuff in process.c should handle the !cpuidle
and !CPU_IDLE cases, and in the typical case it will
handle idle during boot before cpuidle initializes.

> Additionally, we may not need to support multiple cpuidle driver registration
> as now there would be only acpi_idle and intel_idle
> and mechanism already exists to select between the two.

Right.

I think multiple driver registration is over-kill, though
I have no real opposition to it should a real need for it emerge.
The only need I could come up with is that it would save me
a reboot when I want to compare drivers -- but we should optimize
for real-world-use, not lab use, and simpler is better.

thanks,
Len Brown, Intel Open Source Technology Center


