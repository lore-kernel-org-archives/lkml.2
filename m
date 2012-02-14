Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab2BNSaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:30:12 -0500
Received: from smtp.tele.fi ([192.89.123.25]:49570 "EHLO smtp.tele.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab2BNSaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:30:10 -0500
X-Originating-Ip: [194.89.68.22]
Date: Tue, 14 Feb 2012 20:30:06 +0200
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: ke.yu@intel.com, kevin.tian@intel.com, JBeulich@novell.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [RFC] acpi processor and cpufreq harester - aka
	pipe all of that up to the hypervisor (v3)
Message-ID: <20120214183006.GJ12984@reaktio.net>
References: <1329196009-25268-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329196009-25268-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 12:06:46AM -0500, Konrad Rzeszutek Wilk wrote:
> 
> This "harvester" (I am horrible with names, if you have any suggestions please
> tell me them) collects the information that the cpufreq drivers and the
> ACPI processor code save in the 'struct acpi_processor' and then sends it to
> the hypervisor.
> 

Btw there's a typo in the subject line.. "harester".

I'm not very good with names either: collector? passthru? 


> The driver can be either an module or compiled in. In either mode the driver
> launches a thread that checks whether an cpufreq driver is registered. If so
> it reads all the 'struct acpi_processor' data for all online CPUs and sends
> it to hypervisor. The driver also register a CPU hotplug component - so if a new
> CPU shows up - it would send the data to the hypervisor for it as well.
> 
> I've tested this with success on a variety of Intel and AMD hardware (need
> a patch to the hypervisor to allow the rdmsr to be passed through). The one
> caveat is that dom0_max_vcpus inhibits the driver from reading the vCPUs
> that are not present in dom0. One solution is to boot without dom0_max_vcpus
> and utilize the 'xl vcpu-set' command to offline the vCPUs. Other one that
> Nakajima Jun suggested was to hotplug vCPUS in - so bootup dom0 and hotplug
> the vCPUs in - but I am running in difficulties on how to do this in the hypervisor.
> 

When using this driver do you need to pass any options to Xen hypervisor? 
(cpufreq=something) ? 

It might be good to mention something about that in the patch comments.

-- Pasi

