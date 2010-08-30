Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab0H3Jro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:47:44 -0400
Received: from mx5.orcon.net.nz ([219.88.242.55]:36993 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab0H3Jrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:47:43 -0400
Message-ID: <4C7B7E3B.2060205@orcon.net.nz>
Date: Mon, 30 Aug 2010 21:47:39 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Oops seen in dvb_usb_dib0700 when running 2.6.36-rc3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx5.orcon.net.nz on Mon, 30 Aug 2010 21:47:40 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Aug 30 21:47:40 2010
X-DSPAM-Confidence: 0.6963
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just got up the courage to try the 2.6.36 series (indeed 2.6.36-rc3) and 
saw an oops from the dvb_usb_dib0700 module on startup.  This is a 
Hauppauge Nova-T 500 card in a Compaq Alpha.  Have never seen this when 
running 2.6.35 series or prior kernels.

[   29.259750] dib0700: loaded with support for 15 different device-types
[   29.261703] dvb-usb: found a 'Hauppauge Nova-T 500 Dual DVB-T' in 
warm state.
[   29.261703] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   29.263656] DVB: registering new adapter (Hauppauge Nova-T 500 Dual 
DVB-T)
[   29.290024] PCI: Setting latency timer of device 0000:01:00.1 to 64
[   29.374008] DVB: registering adapter 0 frontend 0 (DiBcom 3000MC/P)...
[   29.416000] MT2060: successfully identified (IF1 = 1217)
[   29.898422] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[   29.899398] DVB: registering new adapter (Hauppauge Nova-T 500 Dual 
DVB-T)
[   29.910140] DVB: registering adapter 1 frontend 0 (DiBcom 3000MC/P)...
[   29.916000] MT2060: successfully identified (IF1 = 1226)
[   30.107406] ieee1394: Host added: ID:BUS[0-00:1023] 
GUID[0000303c0009c6d0]
[   30.423812] dvb-usb: Hauppauge Nova-T 500 Dual DVB-T successfully 
initialized and connected.
[   30.423812] Unable to handle kernel paging request at virtual address 
0000000000000138
[   30.423812] modprobe(617): Oops 1
[   30.423812] pc = [<fffffffc00976d70>]  ra = [<fffffffc00976d34>]  ps 
= 0000    Not tainted
[   30.423812] pc is at dib0700_probe+0xf0/0x150 [dvb_usb_dib0700]
[   30.423812] ra is at dib0700_probe+0xb4/0x150 [dvb_usb_dib0700]
[   30.423812] v0 = 0000000000000010  t0 = 0000000000000000  t1 = 
00000000000001f4
[   30.423812] t2 = 0000000000000000  t3 = 0000000000000000  t4 = 
000000000000a9ba
[   30.423812] t5 = 0000000000000000  t6 = 0000000000000000  t7 = 
fffffc003e260000
[   30.424789] s0 = fffffc003e1ee340  s1 = fffffffc0098a27c  s2 = 
fffffc003f592000
[   30.424789] s3 = fffffffc0097c430  s4 = fffffc003e263d38  s5 = 
fffffffc0097d368
[   30.424789] s6 = 0000000120022080
[   30.424789] a0 = 0000000000000000  a1 = fffffc00010c87a8  a2 = 
fffffc003e047a60
[   30.424789] a3 = fffffffc0031902c  a4 = fffffc003e10c068  a5 = 
0000000000000000
[   30.424789] t8 = ffffffffffffffff  t9 = 0000000000000000  t10= 
0000000000000010
[   30.424789] t11= 0000000000000000  pv = fffffc00003a3e90  at = 
0000000000000003
[   30.424789] gp = fffffffc00982d42  sp = fffffc003e263ce8
[   30.424789] Disabling lock debugging due to kernel taint
[   30.424789] Trace:
[   30.424789] [<fffffc0000513534>] driver_probe_device+0xa4/0x220
[   30.425765] [<fffffc00005137ac>] __driver_attach+0xfc/0x100
[   30.425765] [<fffffc00005125e8>] bus_for_each_dev+0x78/0xd0
[   30.425765] [<fffffc00005136b0>] __driver_attach+0x0/0x100
[   30.425765] [<fffffc00005132dc>] driver_attach+0x2c/0x40
[   30.425765] [<fffffc00005129c8>] bus_add_driver+0xe8/0x350
[   30.425765] [<fffffc00004783b0>] kobj_bcast_filter+0x0/0xa0
[   30.426742] [<fffffc0000513bd8>] driver_register+0x78/0x1b0
[   30.426742] [<fffffc00004783b0>] kobj_bcast_filter+0x0/0xa0
[   30.426742] [<fffffc0000310088>] do_one_initcall+0x38/0x200
[   30.426742] [<fffffc000035efdc>] SyS_init_module+0xfc/0x2b0
[   30.426742] [<fffffc0000310c24>] entSys+0xa4/0xc0
[   30.426742]
[   30.427718] Code: a43e0050  205f0001  384101c0  a43e0050  205f01f4 
a4211c58 <b0410138> a61e0050

Cheers
Michael.
