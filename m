Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2FLJgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:36:55 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.255.50]:24982 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab2FLJgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 05:36:54 -0400
X-Env-Sender: satendra.pratap@mindspeed.com
X-Msg-Ref: server-5.tower-172.messagelabs.com!1339493812!2307158!1
X-Originating-IP: [199.33.64.92]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
In-Reply-To: <OF45FACB1C.595B6E12-ON65257A1A.003F5069-65257A1A.003FB93D@LocalDomain>
References: <OFA47B3090.4F32E90D-ON65257A18.003404DE-65257A18.00341A63@LocalDomain> <OF45FACB1C.595B6E12-ON65257A1A.003F5069-65257A1A.003FB93D@LocalDomain>
To: andriy.shevchenko@linux.intel.com
Cc: hskinnemoen@gmail.com, viresh.kumar@st.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Subject: Re: dmatest to use synopsys dma driver (dw_dmac.c)
X-KeepSent: D3A4516E:9240673E-65257A1B:003431C4;
 type=4; flags=0; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.2FP3 July 11, 2011
Message-ID: <OFD3A4516E.9240673E-ON65257A1B.003431C4-65257A1B.0034CFB2@mindspeed.com>
From: satendra.pratap@mindspeed.com
Date: Tue, 12 Jun 2012 15:06:50 +0530
X-MIMETrack: Serialize by Router on IDCLNM1/Server/Mindspeed(Release 8.5.2FP3|July 10, 2011) at
 06/12/2012 03:06:51 PM,
	Serialize complete at 06/12/2012 03:06:51 PM,
	Itemize by SMTP Server on NPBLNH1/Server/Mindspeed(Release 8.5.2FP3|July 10, 2011) at
 06/12/2012 02:36:51 AM,
	Serialize by Router on NPBLNH1/Server/Mindspeed(Release 8.5.2FP3|July 10, 2011) at
 06/12/2012 02:36:52 AM,
	Serialize complete at 06/12/2012 02:36:52 AM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Andy.
Could you please provide those patches and your test code?
I have double checked the dma configuration and it seems fine. What I am 
suspecting
now is that there is no completion interrupt is generated from the dma and 
interrupt
handler is not called. So I am going to check interrupts on our platform.

Thanks,
Satendra

On Mon, 2012-06-11 at 17:06 +0530, satendra.pratap@xxxxxxxxxxxxx wrote: 
> >> 1. dmatest with ported dw_dmac.c (from linux-3.4 to linux-3.2.2):
> 
> >>dmatest started automatically and tries test with all registered 8
> >>channels of our dma engine but we get crashes with every channel as 
> shown
> >>below:
> 
> These crashes are solved but I get same " test timed out" for this 
ported 
> driver too
> as I was getting with original one. After debugging, it seems that after 

> dma transfer is complete no interrupt is 
> generated.......I have verified irq number etc , handler registered 
> properly but I don get any interrupts..
> I am looking into the code to see whether there is any polling mechanism 

> is used in the driver ?

I have few patches to fix this driver for our hardware.
The dw_dmac has few issues, one of them is impossibility to configure
some important parts of the IP-block like block_ts or tr_width.

So, I could send patchset which probably helps you a bit.


-- 
Andy Shevchenko <andriy.shevchenko@xxxxxxxxxxxxxxx>
Intel Finland Oy



From:   Satendra Pratap/Intl/Mindspeed
To:     hskinnemoen@gmail.com, viresh.kumar@st.com
Cc:     linux-kernel@vger.kernel.org
Date:   06/11/2012 05:06 PM
Subject:        Re: dmatest to use synopsys dma driver (dw_dmac.c)


>> 1. dmatest with ported dw_dmac.c (from linux-3.4 to linux-3.2.2):

>>dmatest started automatically and tries test with all registered 8
>>channels of our dma engine but we get crashes with every channel as 
shown
>>below:

These crashes are solved but I get same " test timed out" for this ported 
driver too
as I was getting with original one. After debugging, it seems that after 
dma transfer is complete no interrupt is 
generated.......I have verified irq number etc , handler registered 
properly but I don get any interrupts..
I am looking into the code to see whether there is any polling mechanism 
is used in the driver ?

Thanks,
Satendra





From:   Satendra Pratap/Intl/Mindspeed
To:     linux-kernel@vger.kernel.org
Date:   06/09/2012 02:59 PM
Subject:        dmatest to use synopsys dma driver (dw_dmac.c)


Hi,

We have Synopsys DMAC controller on our SoC and are trying to use open 
source
dw_dmac.c driver. We are using linux-3.2.2 kernel but it seems dw_dmac.c 
does not have any support for command DMA_SLAVE_CONFIG. Later I checked 
out that its been added in later versions of dw_dmac.c so I backported 
dw_dmac from linux-3.4 to linux-3.2.2.
I have tried using dmatest to validate dw_dmac.c driver. I just compile 
kernel with dw_dmac.c and with dmatest support then I test it. (I think I 
need not to modify dmatest in order to work with dw_dmac).
While testing I get crashes with the ported driver (from linux-3.4 to 
linux-3.2.2) but with the original driver in linux-3.2.2 I get no crashes 
but "test timed out"

Below are the logs:

1. dmatest with ported dw_dmac.c (from linux-3.4 to linux-3.2.2):

dmatest started automatically and tries test with all registered 8
channels of our dma engine but we get crashes with every channel as shown
below:

=============================================================

[    0.830000] private_candidate: Checking for channel=0
[    0.830000] private_candidate: Got channel=0
[    0.840000] dmatest: Started 1 threads using dma0chan0
[    0.840000] Unable to handle kernel NULL pointer dereference at virtual
address 00000000
[    0.840000] pgd = c0004000
[    0.840000] [00000000] *pgd=00000000
[    0.840000] Internal error: Oops: 5 [#1] SMP
[    0.840000] Modules linked in:
[    0.840000] CPU: 1    Not tainted  (3.2.2+ #176)
[    0.840000] PC is at dwc_prep_dma_memcpy+0x60/0x1d0
[    0.840000] LR is at dmatest_func+0x660/0xc1c
[    0.840000] pc : [<c0188720>]    lr : [<c018622c>]    psr: 60000013
[    0.840000] sp : df9a9e98  ip : df9a9ed8  fp : df9a9ed4
[    0.840000] r10: 000017c7  r9 : df8a308c  r8 : 00000000
[    0.840000] r7 : 000021c0  r6 : df8a308c  r5 : 00000000  r4 : 00000000
[    0.840000] r3 : 000017c7  r2 : 00000000  r1 : c02f69a1  r0 : df8a308c
[    0.840000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
 Segment
kernel
[    0.840000] Control: 10c53c7d  Table: 0000404a  DAC: 00000015
[    0.840000] Process dma0chan0-copy0 (pid: 240, stack limit = 
0xdf9a8270)
[    0.840000] Stack: (0xdf9a9e98 to 0xdf9aa000)
[    0.840000] 9e80:                                                      
00000000 003f3f00
[    0.840000] 9ea0: 1f9f61c0 1f9fa1da c000f960 dfa01220 000017c7 00000001
000021c0 00000000
[    0.840000] 9ec0: 000021da df8a308c df9a9fbc df9a9ed8 c018622c c01886cc
0000001b 00000001
[    0.840000] 9ee0: c03ef6a8 00000000 1f9f8000 df9a9ef8 c0186664 c0043b84
1f9f61c0 df9a8000
[    0.840000] 9f00: df9a9fac df9a9f10 c02df464 c001d7bc df9a9f7c df9a9f20
c0843f00 df9a9f6c
[    0.840000] 9f20: 00000010 df9a9f08 df9a9ef8 00000001 00000004 df9a9ee8
00000000 000017c7
[    0.840000] 9f40: df9a9ef8 df9a9eec df96e644 00000000 df9a9ef8 00000000
00000001 00000001
[    0.840000] 9f60: df9a9ee8 df8a3000 00000000 df82def8 00000013 df82def4
00000013 00000001
[    0.840000] 9f80: 00000000 df82dee4 dfa01220 c0185bcc 00000013 df82dee4
dfa01220 c0185bcc
[    0.840000] 9fa0: 00000013 00000000 00000000 00000000 df9a9ff4 df9a9fc0
c0043f80 c0185bd8
[    0.840000] 9fc0: 00000000 dfa01220 00000000 00000000 df9a9fd0 df9a9fd0
00000000 df82dee4
[    0.840000] 9fe0: c0043ef0 c0029f18 00000000 df9a9ff8 c0029f18 c0043efc
7ddfd75b effffffd
[    0.840000] Backtrace:
[    0.840000] [<c01886c0>] (dwc_prep_dma_memcpy+0x0/0x1d0) from 
[<c018622c>]
(dmatest_func+0x660/0x
c1c)
[    0.840000] [<c0185bcc>] (dmatest_func+0x0/0xc1c) from [<c0043f80>]
(kthread+0x90/0x98)
[    0.840000] [<c0043ef0>] (kthread+0x0/0x98) from [<c0029f18>]
(do_exit+0x0/0x6d8)
[    0.840000]  r6:c0029f18 r5:c0043ef0 r4:df82dee4
[    0.840000] Code: e1a09006 e59f116c e3540000 e1a02004 (e5943000)
[    0.840000] ---[ end trace cfbc40eba3a6e5e5 ]---
[    1.070000] private_candidate: Checking for channel=0
[    1.080000] private_candidate: Checking for channel=1
[    1.080000] private_candidate: Got channel=1
[    1.090000] dmatest: Started 1 threads using dma0chan1
[    1.090000] Unable to handle kernel NULL pointer dereference at virtual
address 00000000
[    1.090000] pgd = c0004000
[    1.090000] [00000000] *pgd=00000000
[    1.090000] Internal error: Oops: 5 [#2] SMP
[    1.090000] Modules linked in:
[    1.090000] CPU: 1    Tainted: G      D       (3.2.2+ #176)
[    1.090000] PC is at dwc_prep_dma_memcpy+0x60/0x1d0
[    1.090000] LR is at dmatest_func+0x660/0xc1c
[    1.090000] pc : [<c0188720>]    lr : [<c018622c>]    psr: 60000013
[    1.090000] sp : df951e98  ip : df951ed8  fp : df951ed4
[    1.090000] r10: 00001c5a  r9 : df8a3108  r8 : 00000000
[    1.090000] r7 : 000000e7  r6 : df8a3108  r5 : 00000000  r4 : 00000000
[    1.090000] r3 : 00001c5a  r2 : 00000000  r1 : c02f69a1  r0 : df8a3108
[    1.090000] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM 
 Segment
kernel
[    1.090000] Control: 10c53c7d  Table: 0000404a  DAC: 00000015
[    1.090000] Process dma0chan1-copy0 (pid: 242, stack limit = 
0xdf950270)
[    1.090000] Stack: (0xdf951e98 to 0xdf952000)
[    1.090000] 1e80:                                                      
00000000 003f3f80
[    1.090000] 1ea0: 1f9f00e7 1f9fcc98 c000f960 dfa011e0 00001c5a 00000001
000000e7 00000000
[    1.090000] 1ec0: 00000c98 df8a3108 df951fbc df951ed8 c018622c c01886cc
0000001b 00000001
[    1.090000] 1ee0: c03ef6a8 00000000 1f9fc000 df951ef8 c0186664 c0043b84
1f9f00e7 df950000
[    1.090000] 1f00: df951fac df951f10 c02df464 c001d7bc df951f7c df951f20
c0843f80 df951f6c
[    1.090000] 1f20: 00000010 df951f08 df951ef8 00000001 00000004 df951ee8
00000000 00001c5a
[    1.090000] 1f40: df951ef8 df951eec dfa0fd64 00000000 df951ef8 00000000
00000001 00000001
[    1.090000] 1f60: df951ee8 df8a3000 00000000 df82def8 00000013 df82def4
00000013 00000001
[    1.090000] 1f80: 00000000 df82dee4 dfa011e0 c0185bcc 00000013 df82dee4
dfa011e0 c0185bcc
[    1.090000] 1fa0: 00000013 00000000 00000000 00000000 df951ff4 df951fc0
c0043f80 c0185bd8
[    1.090000] 1fc0: 00000000 dfa011e0 00000000 00000000 df951fd0 df951fd0
00000000 df82dee4
[    1.090000] 1fe0: c0043ef0 c0029f18 00000000 df951ff8 c0029f18 c0043efc
7ddfd77b effdffdd
[    1.090000] Backtrace:
[    1.090000] [<c01886c0>] (dwc_prep_dma_memcpy+0x0/0x1d0) from 
[<c018622c>]
(dmatest_func+0x660/0x
c1c)
[    1.090000] [<c0185bcc>] (dmatest_func+0x0/0xc1c) from [<c0043f80>]
(kthread+0x90/0x98)
[    1.090000] [<c0043ef0>] (kthread+0x0/0x98) from [<c0029f18>]
(do_exit+0x0/0x6d8)
[    1.090000]  r6:c0029f18 r5:c0043ef0 r4:df82dee4
[    1.090000] Code: e1a09006 e59f116c e3540000 e1a02004 (e5943000)
[    1.090000] ---[ end trace cfbc40eba3a6e5e6 ]---


2. dmatest with original dw_dma.c in linux-3.2.2:

I tried using dmatest with the original (linux-3.2.2) dma driver 
(dw_dmac.c)
and got the below results (timeout for tests):

[    0.800000] Bridge firewalling registered
[    0.810000] 8021q: 802.1Q VLAN Support v1.8
[    0.810000] dmatest: Started 1 threads using dma0chan0
[    0.820000] dmatest: Started 1 threads using dma0chan1
[    0.820000] dmatest: Started 1 threads using dma0chan2
[    0.830000] dmatest: Started 1 threads using dma0chan3
[    0.830000] dmatest: Started 1 threads using dma0chan4
[    0.840000] dmatest: Started 1 threads using dma0chan5
[    0.840000] dmatest: Started 1 threads using dma0chan6
[    0.850000] dmatest: Started 1 threads using dma0chan7
[    3.810000] dma0chan0-copy0: #0: test timed out
[    3.820000] dma0chan1-copy0: #0: test timed out
[    3.820000] dma0chan2-copy0: #0: test timed out
[    3.830000] dma0chan3-copy0: #0: test timed out
[    3.830000] dma0chan4-copy0: #0: test timed out
[    3.840000] dma0chan5-copy0: #0: test timed out

Any help is greatly appreciated. It would be of very much help is some one 
could share their code to use dw_dmac.c.

Thanks,
Satendra

