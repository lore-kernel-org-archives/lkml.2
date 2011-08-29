Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1H2Py6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 11:54:58 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:14080 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1H2Py5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 11:54:57 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Aug 2011 11:54:56 EDT
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>, Mark Lord <kernel@teksavvy.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Date: Mon, 29 Aug 2011 16:49:29 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: AcwpuHyBwe0WVPgYQteo4mjNL04fIA8qcVGg
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
References: <20110426155229.GM878@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C77554C91@gretna.indigovision.com>
 <20110430140109.GJ29280@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32C777089B2@gretna.indigovision.com>
 <20110525094127.GF10146@htj.dyndns.org> <4DF20E03.9030502@teksavvy.com>
 <20110610140155.GJ15235@htj.dyndns.org> <4DF25526.9010800@teksavvy.com>
 <20110611121957.GA7980@mtj.dyndns.org> <4DF4F30B.70702@teksavvy.com>
 <20110613104856.GC16021@htj.dyndns.org>
In-Reply-To: <20110613104856.GC16021@htj.dyndns.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

While the hotplug is now far more reliable, I have recently been able to coax
it into locking up SATA ports again while the device is heavily loaded.  This
looks very similar to the previous lockups, with the SATA port left frozen.
I have pasted some tracing below; at the end of the trace ata4 is no longer
responsive to hotplug events.  I have attempted to add further tracing to find
out where the freeze is occurring, but so far this has just prevented me from
triggering the condition.  I am currently trying to locate the problem by
inspecting the sources, but you may have some intuition that could shortcut
my efforts.

I should mention that we are now working on kernel 2.6.39.4 (and are choosing
not to go with 3.x to limit changes as we progress towards final testing.)

Kind Regards,

Bruce.


[...]
ata4.00: configured for UDMA/33
ata_eh_recover: EXIT, rc=0
ata4: EH complete
ata_scsi_error: EXIT
ata_scsiop_noop: ENTER
ata_scsiop_read_cap: ENTER
ata_scsiop_mode_sense: ENTER
ata_scsiop_mode_sense: ENTER
ata_scsiop_mode_sense: ENTER
__ata_port_freeze: ata4 port frozen
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_error: ENTER
ata_sff_flush_pio_task: ENTER
ata_eh_link_autopsy: ENTER
ata_eh_link_autopsy: EXIT
ata4.00: exception Emask 0x10 SAct 0x0 SErr 0x190002 action 0xe frozen
ata4.00: edma_err_cause=00000020 pp_flags=00000000, SError=00180000
ata4: SError: { RecovComm PHYRdyChg 10B8B Dispar }
ata4.00: failed command: FLUSH CACHE EXT
ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 50/00:00:30:5a:27/00:08:00:00:00/a0 Emask 0x10 (ATA bus error)
ata4.00: status: { DRDY }
ata_eh_recover: ENTER
__ata_port_freeze: ata4 port frozen
ata4: hard resetting link
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=0
ata_sff_softreset: ENTER
ata_sff_softreset: about to softreset, devmask=1
ata_bus_softreset: ata4: bus reset via SRST
ata_dev_classify: found ATA device by sig
ata_sff_softreset: EXIT, classes[0]=1 [1]=0
ata_eh_thaw_port: ata4 port thawed
ata_std_postreset: ENTER
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata_sff_flush_pio_task: ENTER
ata_sff_flush_pio_task: ENTER
ata_dump_id: 49==0x2f00  53==0x0007  63==0x0007  64==0x0003  75==0x001f
ata_dump_id: 80==0x01f0  81==0x0029  82==0x346b  83==0x7d61  84==0x4133
ata_dump_id: 88==0x047f  93==0x0000
ata_dev_set_xfermode: set features - xfer mode
ata_sff_flush_pio_task: ENTER
ata_dev_set_xfermode: EXIT, err_mask=0
ata_sff_flush_pio_task: ENTER
ata_sff_flush_pio_task: ENTER
ata_dump_id: 49==0x2f00  53==0x0007  63==0x0007  64==0x0003  75==0x001f
ata_dump_id: 80==0x01f0  81==0x0029  82==0x346b  83==0x7d61  84==0x4133
ata_dump_id: 88==0x047f  93==0x0000
ata_dev_set_mode: xfer_shift=12, xfer_mode=0x42
ata4.00: configured for UDMA/33
ata4.00: retrying FLUSH 0xea Emask 0x10
ata_sff_flush_pio_task: ENTER
ata_eh_recover: EXIT, rc=0
ata4: EH complete
ata_scsi_error: EXIT
__ata_port_freeze: ata4 port frozen
ata_port_schedule_eh: port EH scheduled
ata_scsiop_noop: ENTER
ata_scsiop_read_cap: ENTER
ata_scsiop_mode_sense: ENTER
ata_scsiop_mode_sense: ENTER
ata_scsiop_mode_sense: ENTER

Latest News at: http://www.indigovision.com/index.php/en/news.html
