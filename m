Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2BBIii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:38:38 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53813 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab2BBIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:38:36 -0500
Message-ID: <4F2A4B7E.2090503@linux.vnet.ibm.com>
Date: Thu, 02 Feb 2012 14:08:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: linux-kernel@vger.kernel.org, jeff@garzik.org,
        Lin Ming <ming.m.lin@intel.com>, Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume, COMRESET
 failed
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
In-Reply-To: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12020122-1618-0000-0000-000000B09186
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding some Cc's.

On 02/02/2012 10:42 AM, Norbert Preining wrote:

> Dear all,
> 
> (please Cc)
> 
> since going from 3.2 to 3.3-rc1 I see a kind of regression wrt booting
> time, namely the detection of the CD drive hangs for 10sec (both
> dmesg were taken on the same hardware on the same day):
> 
> with 3.3-rc1 and rc2:
> [    3.694012] sd 0:0:0:0: [sda] Attached SCSI disk
> [    9.004013] ata2: link is slow to respond, please be patient (ready=0)
> [   13.652013] ata2: COMRESET failed (errno=-16)
> [   13.972022] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   13.975721] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [   13.977166] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
> [   13.981294] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [   13.982734] ata2.00: configured for UDMA/33
> [   13.987964] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
> [   13.991482] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [   13.992971] cdrom: Uniform CD-ROM driver Revision: 3.20
> [   13.994574] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [   13.994672] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [   14.316021] ata5: SATA link down (SStatus 0 SControl 300)
> [   14.636019] ata6: SATA link down (SStatus 0 SControl 300)
> 
> with 3.2:
> [    3.218156] sd 0:0:0:0: [sda] Attached SCSI disk
> [    3.484023] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [    3.487708] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    3.489156] ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
> [    3.494321] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
> [    3.495761] ata2.00: configured for UDMA/33
> [    3.501057] scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
> [    3.504515] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> [    3.505995] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    3.507611] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    3.507715] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [    3.828025] ata5: SATA link down (SStatus 0 SControl 300)
> [    4.148020] ata6: SATA link down (SStatus 0 SControl 300)
> 
> 
> Is there anything I can do here?
> 

