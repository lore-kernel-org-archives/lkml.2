Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab0HBQ4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 12:56:06 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35303 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab0HBQ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 12:56:05 -0400
Message-ID: <4C56F983.5080403@cs.wisc.edu>
Date: Mon, 02 Aug 2010 11:59:47 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: build failure after merge of the final tree (scsi-post-merge
 tree related)
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au> <20100803024701.b3dff69a.sfr@canb.auug.org.au>
In-Reply-To: <20100803024701.b3dff69a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 11:47 AM, Stephen Rothwell wrote:
> Hi all,
>
> On Tue, 3 Aug 2010 02:44:45 +1000 Stephen Rothwell<sfr@canb.auug.org.au>  wrote:
>>
>> After merging the final tree, today's linux-next build (powerpc allmodconfig)
>> failed like this:
>>
>> ERROR: ".iscsi_boot_destroy_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
>> ERROR: ".iscsi_boot_create_host_kset" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
>> ERROR: ".iscsi_boot_create_target" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
>> ERROR: ".iscsi_boot_create_initiator" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
>> ERROR: ".iscsi_boot_create_ethernet" [drivers/scsi/be2iscsi/be2iscsi.ko] undefined!
>>
>> Caused by commit a33e2a708b2e83ee6111e45c8d3d49a112c3c887 ("[SCSI]
>> be2iscsi: Add support for iscsi boot").  For some reason, commit
>> ed94aa526655d915076dcdbbf4fc962b2a67fcb5 ("[SCSI] be2iscsi: select
>> ISCSI_BOOT_SYSFS") was not sufficient to make sure that
>> CONFIG_ISCSI_BOOT_SYSFS is defined for this build.
>
> It turns out that drivers/firmware/Kconfig is only included on x86, ia64
> and blackfin.
>

I think the iscsi_boot_sysfs module should just be moved to 
drivers/scsi. It is a generic scsi/iscsi interface to export iscsi boot 
info and is not tied to boot. I will send a patch in a couple minutes.
