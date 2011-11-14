Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab1KNChb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 21:37:31 -0500
Received: from lo.gmane.org ([80.91.229.12]:53106 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab1KNChV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 21:37:21 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH v2] kdump: Add udev events for memory online/offline
Date: Mon, 14 Nov 2011 02:37:06 +0000 (UTC)
Message-ID: <j9pusg$hr5$2@dough.gmane.org>
References: <1319645292.3321.24.camel@br98xy6r>
	<20111026192449.GE355@redhat.com>
	<20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
	<1319707965.2830.1.camel@br98xy6r>
	<20111028154630.77c7b96c.akpm@linux-foundation.org>
	<1320067306.2796.34.camel@br98xy6r>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 180.129.196.69
User-Agent: Pan/0.133 (House of Butterflies)
Cc: kexec@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011 14:21:46 +0100, Michael Holzheu wrote:

> On Fri, 2011-10-28 at 15:46 -0700, Andrew Morton wrote:
>> On Thu, 27 Oct 2011 11:32:45 +0200
> 
> [snip]
> 
>> I think a safer place from which to send the uevent is
>> memory_block_change_state() or even memory_block_action().  Because if
>> either of those functions later gets new callers, those callers might
>> forget to send the uevent?
> 
> Ok fine. I put the code into memory_block_change_state(). This also has
> the advantage that we are serialized by "mem->state_mutex". Not sure if
> we need that, but for CPU hotplug the udev events are also serialized
> with a lock. See  "drivers/base/cpu.c" -> cpu_hotplug_driver_lock()
> 
> Do you think the following patch is acceptable? 


Yes.

> ---
> From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
> 
> Currently no udev events for memory hotplug "online" and "offline" are
> generated:
> 
> # udevadm monitor
> # echo offline > /sys/devices/system/memory/memory4/state ==> No event
> 
> When kdump is loaded, kexec detects the current memory configuration and
> stores it in the pre-allocated ELF core header. Therefore, for kdump it
> is necessary to reload the kdump kernel with kexec when the memory
> configuration changes (e.g. for online/offline hotplug memory).
> 
> In order to do this automatically, udev rules should be used. This
> kernel patch adds udev events for "online" and "offline". Together with
> this kernel patch, the following udev rules for online/offline have to
> be added to "/etc/udev/rules.d/98-kexec.rules":
> 
> SUBSYSTEM=="memory", ACTION=="online", PROGRAM="/etc/init.d/kdump
> restart" SUBSYSTEM=="memory", ACTION=="offline",
> PROGRAM="/etc/init.d/kdump restart"
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>


Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

