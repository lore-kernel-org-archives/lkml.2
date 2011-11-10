Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab1KJKkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:40:49 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42949 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab1KJKkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:40:47 -0500
Date: Thu, 10 Nov 2011 16:10:36 +0530
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
To: Cong Wang <amwang@redhat.com>
Cc: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ananth Narayan <ananth@in.ibm.com>, Milton Miller <miltonm@bga.com>,
        Haren Myneni <hbabu@us.ibm.com>, Anton Blanchard <anton@samba.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC PATCH v4 01/10] fadump: Add documentation for
 firmware-assisted dump.
Message-ID: <20111110104036.GA5145@in.ibm.com>
Reply-To: mahesh@linux.vnet.ibm.com
References: <20111107095215.1997.14866.stgit@mars.in.ibm.com>
 <20111107095521.1997.34844.stgit@mars.in.ibm.com>
 <4EBB9D76.80601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EBB9D76.80601@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11111010-2000-0000-0000-0000011FCA37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-10 17:46:30 Thu, Cong Wang wrote:
> 于 2011年11月07日 17:55, Mahesh J Salgaonkar 写道:
> >From: Mahesh Salgaonkar<mahesh@linux.vnet.ibm.com>
> >
> >Documentation for firmware-assisted dump. This document is based on the
> >original documentation written for phyp assisted dump by Linas Vepstas
> >and Manish Ahuja, with few changes to reflect the current implementation.
> >
> >Change in v3:
> >- Modified the documentation to reflect introdunction of fadump_registered
> >   sysfs file and few minor changes.
> >
> >Change in v2:
> >- Modified the documentation to reflect the change of fadump_region
> >   file under debugfs filesystem.
> >
> >Signed-off-by: Mahesh Salgaonkar<mahesh@linux.vnet.ibm.com>
> 
> 
> Please Cc Randy Dunlap <rdunlap@xenotime.net> for kernel documentation
> patch.
> 
> I have some inline comments below.
> 

Thanks for your review. I will incorporate all your comments.

<...>
> >+with minor modifications. The kdump script requires following
> >+modifications:
> >+-- During service kdump start if /proc/vmcore entry is not present,
> >+   look for the existence of /sys/kernel/fadump_enabled and read
> >+   value exported by it. If value is set to '0' then fallback to
> >+   existing kexec based kdump. If value is set to '1' then check the
> >+   value exported by /sys/kernel/fadump_registered. If value it set
> >+   to '1' then print success otherwise register for fadump by
> >+   echo'ing 1>  /sys/kernel/fadump_registered file.
> >+
> >+-- During service kdump start if /proc/vmcore entry is present,
> >+   execute the existing routine to save the dump. Once the dump
> >+   is saved, echo 1>  /sys/kernel/fadump_release_mem (if the
> >+   file exists) to release the reserved memory for general use
> >+   and continue without rebooting. At this point the memory
> >+   reservation map will look like as shown in Fig. 1. If the file
> >+   /sys/kernel/fadump_release_mem is not present then follow
> >+   the existing routine to reboot into new kernel.
> >+
> >+-- During service kdump stop echo 0>  /sys/kernel/fadump_registered
> >+   to un-register the fadump.
> >+
> 
> I don't think you need to document kdump script changes in a kernel
> doc.
> 

Agree. I will remove it.

> >+
> >+TODO:
> >+-----
> >+ o Need to come up with the better approach to find out more
> >+   accurate boot memory size that is required for a kernel to
> >+   boot successfully when booted with restricted memory.
> >+ o The fadump implementation introduces a fadump crash info structure
> >+   in the scratch area before the ELF core header. The idea of introducing
> >+   this structure is to pass some important crash info data to the second
> >+   kernel which will help second kernel to populate ELF core header with
> >+   correct data before it gets exported through /proc/vmcore. The current
> >+   design implementation does not address a possibility of introducing
> >+   additional fields (in future) to this structure without affecting
> >+   compatibility. Need to come up with the better approach to address this.
> >+   The possible approaches are:
> >+	1. Introduce version field for version tracking, bump up the version
> >+	whenever a new field is added to the structure in future. The version
> >+	field can be used to find out what fields are valid for the current
> >+	version of the structure.
> >+	2. Reserve the area of predefined size (say PAGE_SIZE) for this
> >+	structure and have unused area as reserved (initialized to zero)
> >+	for future field additions.
> >+   The advantage of approach 1 over 2 is we don't need to reserve extra space.
> >+---
> 
> Why do we keep TODO in this doc?
> 

I see most of the kernel doc do contain TODO, hence I added it here.

Thanks,
-Mahesh.

-- 
Mahesh J Salgaonkar

