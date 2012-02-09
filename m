Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2BIVWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:22:03 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:47614 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab2BIVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:22:01 -0500
Date: Thu, 9 Feb 2012 17:21:47 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Pasi K?rkk?inen <pasik@iki.fi>, jbarnes@virtuousgeek.org, mjg@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] Stop the continuous flood of (XEN) traps.c:2432:d0 Domain	attempted WRMSR ..
Message-ID: <20120209212147.GE14007@andromeda.dapyr.net>
References: <20120203180952.GP12984@reaktio.net> <20120203185527.GA9290@phenom.dumpdata.com> <20120205194413.GR12984@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120205194413.GR12984@reaktio.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 09:44:13PM +0200, Pasi K?rkk?inen wrote:
> On Fri, Feb 03, 2012 at 01:55:27PM -0500, Konrad Rzeszutek Wilk wrote:
> > On Fri, Feb 03, 2012 at 08:09:52PM +0200, Pasi K?rkk?inen wrote:
> > > Hello,
> > > 
> > > IIRC there was some discussion earlier about these messages in Xen's dmesg:
> > > 
> > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > (XEN) traps.c:2432:d0 Domain attempted WRMSR 00000000000001ac from 0x0000000000c800c8 to 0x0000000080c880c8.
> > > 
> > > At least on my systems there's continuous flood of those messages, so they will fill up the
> > > Xen dmesg log buffer and "xm dmesg" or "xl dmesg" won't show any valuable information, just those messages.
> > 
> > Is it always that MSR? That looks to be TURBO_POWER_CURRENT_LIMIT
> > which is the intel_ips driver doing.
> > 
> 
> Yeah, it's always the same..
> 
> > > 
> > > I seem to be getting those messages even when there's only dom0 running.
> > > Is the plan to drop those messages? What's causing them? 
> > 
> > Looks to be the intel-ips. If you rename it does the issue disappear?
> 
> I just did "rmmod intel_ips" and the flood stopped.. 
> 
> 
> Btw on baremetal I get this in dmesg:
> 
> [  745.033645] CPU1: Core temperature above threshold, cpu clock throttled (total events = 1)
> [  745.033652] CPU3: Core temperature above threshold, cpu clock throttled (total events = 1)
> [  745.034676] CPU1: Core temperature/speed normal
> [  745.034678] CPU3: Core temperature/speed normal
> [  849.678508] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 9682, limit 9000
> [  899.614074] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 9896, limit 9000
> [  899.722881] [Hardware Error]: Machine check events logged
> [ 1172.675987] CPU3: Core temperature above threshold, cpu clock throttled (total events = 78)
> [ 1172.675990] CPU1: Core temperature above threshold, cpu clock throttled (total events = 78)
> [ 1172.677038] CPU1: Core temperature/speed normal
> [ 1172.677042] CPU3: Core temperature/speed normal
> [ 1174.260050] intel ips 0000:00:1f.6: MCP limit exceeded: Avg temp 9676, limit 9000
> [ 1199.339634] [Hardware Error]: Machine check events logged

Jesse, and Matthew,

Is there a way to make the intel_ips.c driver be in a "low-power" state?

My first thought about fixing this was that we could allow the
hypervisor to allow those RDMSR but the Linux kernel has no power to
actually influence the power management (as the hypervisor is in charge
of that) - so would the driver be capable of just sitting back and
not influencing the CPU?

> 
> 
> -- Pasi
> 
> 
> > > 
> > > hmm, according to this bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=470035,
> > > they're related to dom0 kernel acpi-cpufreq ?
> > > 
> > > Also it seems there was discussion about the subject on 2011/08:
> > > http://old-list-archives.xen.org/archives/html/xen-devel/2011-08/msg00561.html
> > > 
> > > 
> > > Xen hypervisor 4.1.2.
> > > dom0 Linux kernel 3.2.2.
> > > 
> > > 
> > > Thanks,
> > > 
> > > -- Pasi
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
