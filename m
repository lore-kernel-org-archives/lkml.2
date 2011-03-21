Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab1CURN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:13:27 -0400
Received: from smtp.infotech.no ([82.134.31.41]:35057 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab1CURN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:13:26 -0400
Message-ID: <4D878733.6020700@interlog.com>
Date: Mon, 21 Mar 2011 18:13:23 +0100
From: Douglas Gilbert <dgilbert@interlog.com>
Reply-To: dgilbert@interlog.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: SCSI development list <linux-scsi@vger.kernel.org>
CC: "Martin K. Petersen" <martin.petersen@ORACLE.COM>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] lsscsi 0.25 beta 1, adds --size
References: <4D7A870C.7040809@interlog.com>
In-Reply-To: <4D7A870C.7040809@interlog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-11 09:33 PM, Douglas Gilbert wrote:
> Martin Petersen recently sent me some patches
> to add a --size (or '-s') option to lsscsi:
>
> # lsscsi -s
> [0:0:0:0] disk ATA INTEL SSD 2CV1 /dev/sda 80.0GB
> [10:0:0:0] disk Linux scsi_debug 0004 /dev/sdb 1.09TB
>
> Martin and I had several hacks at this. Getting
> utilities to work reliably with sysfs across various
> kernel versions continues to be a crap shoot. So
> I am putting this out as a beta and hoping that
> anyone with problems will contact me (or Martin).
>
> Note that this logic decodes /sys/block/sda/size
> (for example) so disks that are present but without
> a block interface (e.g. physical disks in a RAID)
> will not have a size shown ('-' is shown instead).
>
> Version 0.25 beta 1 is available at:
> http://sg.danny.cz/scsi/lsscsi.html
> More information can be found on that page including examples
> and a Download section for the tarball:
> http://sg.danny.cz/scsi/lsscsi-0.25b1.tgz
> There are no debian or redhat packages built for this beta.
>
> Version 0.25 2011/03/04 [svn: r91]
> - add sas_port and fc_remote_ports transport information
> - print enclosure_device entry
> - add '--size' option to show size of disks
> - add '--protmode' option to show protection information mode
>
> Version 0.24 2010/06/12 [svn: r83]
> .....

Recent versions of lsscsi will fail to show block
devices with recent kernels (e.g. lk 2.6.37 and
lk 2.6.38) that have these .config settings:
   CONFIG_SYSFS_DEPRECATED=y
   CONFIG_SYSFS_DEPRECATED_V2=y

What will they dream up for _DEPRECATED_V3 ?

Doug Gilbert


