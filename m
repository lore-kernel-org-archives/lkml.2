Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2BOQhG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 11:37:06 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30765 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab2BOQhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 11:37:03 -0500
Date: Wed, 15 Feb 2012 11:33:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Cc: ke.yu@intel.com, kevin.tian@intel.com, JBeulich@novell.com,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [RFC] acpi processor and cpufreq harester - aka pipe
 all of that up to the hypervisor (v3)
Message-ID: <20120215163340.GD4093@phenom.dumpdata.com>
References: <1329196009-25268-1-git-send-email-konrad.wilk@oracle.com>
 <20120214183006.GJ12984@reaktio.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120214183006.GJ12984@reaktio.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090205.4F3BDF20.009A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 08:30:06PM +0200, Pasi Kärkkäinen wrote:
> On Tue, Feb 14, 2012 at 12:06:46AM -0500, Konrad Rzeszutek Wilk wrote:
> > 
> > This "harvester" (I am horrible with names, if you have any suggestions please
> > tell me them) collects the information that the cpufreq drivers and the
> > ACPI processor code save in the 'struct acpi_processor' and then sends it to
> > the hypervisor.
> > 
> 
> Btw there's a typo in the subject line.. "harester".

Duh!
> 
> I'm not very good with names either: collector? passthru? 

"passthru" sounds better.
> 
> 
> > The driver can be either an module or compiled in. In either mode the driver
> > launches a thread that checks whether an cpufreq driver is registered. If so
> > it reads all the 'struct acpi_processor' data for all online CPUs and sends
> > it to hypervisor. The driver also register a CPU hotplug component - so if a new
> > CPU shows up - it would send the data to the hypervisor for it as well.
> > 
> > I've tested this with success on a variety of Intel and AMD hardware (need
> > a patch to the hypervisor to allow the rdmsr to be passed through). The one
> > caveat is that dom0_max_vcpus inhibits the driver from reading the vCPUs
> > that are not present in dom0. One solution is to boot without dom0_max_vcpus
> > and utilize the 'xl vcpu-set' command to offline the vCPUs. Other one that
> > Nakajima Jun suggested was to hotplug vCPUS in - so bootup dom0 and hotplug
> > the vCPUs in - but I am running in difficulties on how to do this in the hypervisor.
> > 
> 
> When using this driver do you need to pass any options to Xen hypervisor? 
> (cpufreq=something) ? 

No need. You only need that if you want to change the default cpufreq driver from
the ondemand to performance (so cpufreq=performance) or want more verbose information:
cpufreq=verbose,performance

By default the Xen hypervisor will take the cpufreq data in account unless you
override that with 'dom0-is-deciding-power-management-and-I-cant-remember-exactly'
parameter.

> 
> It might be good to mention something about that in the patch comments.

I will include cpufreq=verbose and mention that the effect before and after. And also
with xenpm.

Thanks!
> 
> -- Pasi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
