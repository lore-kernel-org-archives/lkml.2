Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1KYNfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 08:35:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:39236 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab1KYNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 08:35:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mahesh J. Salgaonkar" <mahesh@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v5 1/9] fadump: Add documentation for firmware-assisted
 dump.
Date: Fri, 25 Nov 2011 19:00:50 +0530
Organization: IBM
Message-ID: <4ECF988A.1090203@linux.vnet.ibm.com>
References: <20111115151145.16533.16384.stgit@mars.in.ibm.com> <20111115151334.16533.5790.stgit@mars.in.ibm.com> <20111124223410.GB19828@bloggs.ozlabs.ibm.com>
Reply-To: mahesh.j.salgaonkar@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: kexec@lists.infradead.org, linuxppc-dev@ozlabs.org
X-Gmane-NNTP-Posting-Host: 122.167.75.152
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
In-Reply-To: <20111124223410.GB19828@bloggs.ozlabs.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 04:04 AM, Paul Mackerras wrote:
> On Tue, Nov 15, 2011 at 08:43:34PM +0530, Mahesh J Salgaonkar wrote:
>> From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
>>
>> Documentation for firmware-assisted dump. This document is based on the
>> original documentation written for phyp assisted dump by Linas Vepstas
>> and Manish Ahuja, with few changes to reflect the current implementation.
>>
>> Change in v3:
>> - Modified the documentation to reflect introdunction of fadump_registered
>>   sysfs file and few minor changes.
>>
>> Change in v2:
>> - Modified the documentation to reflect the change of fadump_region
>>   file under debugfs filesystem.
> 
> In general we don't want the changes between successive versions in
> the patch description; this information should go below the "---"
> line.  The patch description should describe how the patch is now and
> give any information that will be useful to someone looking at the
> resulting git commit later on, but it doesn't need to tell us about
> previous versions of the patch that will never appear in the git
> history.

Sure will do that.

> 
>> +-- Once the dump is copied out, the memory that held the dump
>> +   is immediately available to the running kernel. A further
>> +   reboot isn't required.
> 
> I have a general worry about the system making allocations that are
> intended to be node-local while it is running with restricted memory
> (i.e. after the crash and reboot and before the dump has been written
> out and the dump memory freed).  Those allocations will probably all
> come from one node and thus won't necessarily be on the desired node.
> So, for very large systems with significant NUMA characteristics, it
> may be desirable (though not required) to reboot after taking the
> dump.

I have been working on trying to integrate FADUMP with the kdump
infrastructure on distros, which will modify the existing kernel initrd
to capture the vmcore and release the memory at the very early stage
before the switch_root.

However, by default FADUMP will also reboot after capturing vmcore
unless user specifies 'noreboot' option through kdump configuration file.

> 
> What happens about the NUMA information in the kernel -- all the
> memory sections, etc.?  Do they get set up as normal even though the
> second kernel is booting with only a small amount of memory initially?
> 

In FADUMP case, the booting of second kernel after crash is equivalent
to normal kernel bootup and it boots with the knowledge of entire system
RAM with NUMA information. The memblock structure does contain map for
entire system RAM. We just reserve the memory above the bootmem at the
very early stage in the second kernel, so that it remains untouched.

Thanks,
-Mahesh.

