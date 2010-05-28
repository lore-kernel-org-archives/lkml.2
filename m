Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab0E1EQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 00:16:44 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:60954 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab0E1EQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 00:16:43 -0400
Date: Fri, 28 May 2010 00:16:40 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Chase Douglas <chase.douglas@canonical.com>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for select
 intel processors
In-reply-to: <1275013933.2312.7.camel@cndougla-ubuntu>
Message-id: <alpine.LFD.2.00.1005272359510.24823@localhost.localdomain>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
 <1275013933.2312.7.camel@cndougla-ubuntu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I see that you have updated this code in your tree to disable C4 and C6
> on atom. This has piqued my curiosity. I've now seen 2 atom netbooks
> from different OEMs that hide C4 when you plug the power in. After the
> first machine I thought, "must be a BIOS/ACPI bug," but now I'm
> beginning to wonder if there's some issue with atom C4 states? That's
> beside the fact that I've not seen C6 on either machine at all. Do you
> have any insight?

The reasoning behind ACPI taking deep C-states away
when on AC is the assumption that users on AC
care more about low latency and high performance
than they care about power savings, heat, and noise.

I have an Acer aspire-1 that exposes only C1 on AC
but adds C2 and C4 when on DC.

Many believe that the BIOS is not the right place to
make this policy decision.  Others feel that decision
is dated no matter where it is made -- particularly in
light of the latest EPA Energy STAR certification measuring
power ONLY when plugged into AC...

So my intent is to give Linux control over this decision,
via PM_QOS or otherwise.  At the moment C4 is commented out
because when i first tested it failed the lapic timer workaround.
C6 is commented out because I've not found that any BIOS supporting
it -- so it is possibly de-featured or has some other limitations that
I need to find out about.

thanks,
Len Brown, Intel Open Source Technology Center

