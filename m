Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab2IHOFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 10:05:35 -0400
Received: from nm17-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.93]:41030 "HELO
	nm17-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751776Ab2IHOFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 10:05:31 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sat, 08 Sep 2012 10:05:30 EDT
X-Yahoo-Newman-Id: 727559.31602.bm@omp1001.bt.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=DKIM-Signature:X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:Content-Type:Content-Transfer-Encoding;
  b=5AxHqv37Wc2fjCOxMR3HMDQmKLmUANOJ8PtFqdHDctAwPtmT9Y0IcCl1POWgpAyP88uZUdh4xjkfamimAyi01JF/S8KT0I0qTKryRXhBhoYggDdhES9bANs7wt2X0TgiARHA9RUce9yLyuq8S8drcDaQ6ExJSMTUh6gA0Oh9g1M=  ;
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mqJbtwcVM1kkIy7q9JgSaiNNAypELpIcQAXxvlPhPsKPKSI
 zArUF1JYo1nqL8JM0GmXM3mwARR9eeGlbwqhXjT2vBkGOVaGwO53_38CP_P7
 lmuANvEj4VQG4sXPCHHkEzVZufkmPn7nMa.0c2edorZxLHNh8TxLsMIzq6A8
 IhGfoVNltBJTkIJ5DYMG6ZexaaDjwWGa4DyJkclIR9zqPH_XbJznadWj7e0G
 obf3xjzfNU7F5mYs3m99Y9VzLdd2ZwkpYmFUsXJaxacTfvc7SbHLk.WnEGdl
 edwpB0nm6s3BemWmeeT9BWEspRcG6e5BsLWBXqJ2ZxLpkulmJIVNL8Tx8AlL
 4EoDMYyq1yuaUPwYI5CF91Br1Up3UQKfCYozgEPbt3__Xm14aOjcRGnvJfY.
 SwBEDpiLWjMWRRIO7H1QJ6aq3lpskooNpCqnFQH2H6T.HTSx3bGLAjGXofZe
 guCw5CQ--
X-Yahoo-SMTP: dMK34oyswBBlfKesWTI5ovDjFOUFE6shtILt.ZXnUEjQHhWq
Message-ID: <504B4F2D.40002@yahoo.com>
Date: Sat, 08 Sep 2012 14:59:09 +0100
From: Chris Rankin <rankincj@yahoo.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: alsa-devel@alsa-project.org
CC: linux-kernel@vger.kernel.org
Subject: snd-intel-hda: screaming IRQ with 3.5.3 kernel (HDMI)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have recently added a Radeon HD4670 to one of my older PCs, and have noticed 
that it has IRQ trouble when I try to enable the HDMI audio:

irq 17: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper/0 Not tainted 3.5.3 #2
Call Trace:
  [<c1063806>] ? __report_bad_irq+0x11/0x94
  [<c1063a2d>] ? note_interrupt+0x120/0x19b
  [<c1062325>] ? handle_irq_event_percpu+0xe8/0xfb
  [<c1062361>] ? handle_irq_event+0x29/0x40
  [<c10640fc>] ? handle_level_irq+0x93/0x93
  [<c1064163>] ? handle_fasteoi_irq+0x67/0x90
  <IRQ>  [<c1003625>] ? do_IRQ+0x2e/0x83
  [<c1229829>] ? common_interrupt+0x29/0x30
  [<c106007b>] ? audit_update_watch+0x59/0x285
  [<c1007479>] ? default_idle+0x23/0x3b
  [<c1007b38>] ? cpu_idle+0x4b/0x7e
  [<c1314877>] ? start_kernel+0x2a4/0x2a7
handlers:
[<f8c97b75>] azx_interrupt [snd_hda_intel]
Disabling IRQ #17

This is frequently followed by KMS trouble too:

irq 16: nobody cared (try booting with the "irqpoll" option)
Pid: 0, comm: swapper/0 Not tainted 3.5.3 #2
Call Trace:
  [<c1063806>] ? __report_bad_irq+0x11/0x94
  [<c1063a2d>] ? note_interrupt+0x120/0x19b
  [<c1062325>] ? handle_irq_event_percpu+0xe8/0xfb
  [<c1062361>] ? handle_irq_event+0x29/0x40
  [<c10640fc>] ? handle_level_irq+0x93/0x93
  [<c1064163>] ? handle_fasteoi_irq+0x67/0x90
  <IRQ>  [<c1003625>] ? do_IRQ+0x2e/0x83
  [<c1229829>] ? common_interrupt+0x29/0x30
  [<c106007b>] ? audit_update_watch+0x59/0x285
  [<c1007479>] ? default_idle+0x23/0x3b
  [<c1007b38>] ? cpu_idle+0x4b/0x7e
  [<c1314877>] ? start_kernel+0x2a4/0x2a7
handlers:
[<f818bfb3>] radeon_driver_irq_handler_kms [radeon]
[<f81fe55f>] usb_hcd_irq [usbcore]
Disabling IRQ #16

The PCI entries are:

01:00.1 Audio device: ATI Technologies Inc RV710/730
         Subsystem: ATI Technologies Inc RV710/730
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 64 (2000ns min), Cache Line Size: 64 bytes
         Interrupt: pin B routed to IRQ 17
         Region 0: Memory at ff8ec000 (32-bit, non-prefetchable) [size=16K]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Kernel driver in use: snd_hda_intel

and:

01:00.0 VGA compatible controller: ATI Technologies Inc RV730 Pro AGP [Radeon HD 
4600 Series] (prog-if 00 [VGA controller])
         Subsystem: ATI Technologies Inc Device 0028
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx+
         Latency: 64 (2000ns min), Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 16
         Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
         Region 1: I/O ports at ec00 [size=256]
         Region 2: Memory at ff8f0000 (32-bit, non-prefetchable) [size=64K]
         Expansion ROM at ff800000 [disabled] [size=128K]
         Capabilities: [50] Power Management version 3
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] AGP version 3.0
                 Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 
64bit- FW+ AGP3+ Rate=x4,x8
                 Command: RQ=32 ArqSz=2 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x8
         Kernel driver in use: radeon

Does anyone have any suggestions, please?

Thanks,
Chris
