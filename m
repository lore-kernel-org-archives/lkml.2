Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab0IGOg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:36:26 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57424 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab0IGOfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:35:52 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: Bisecting radeon kms freeze bug: Almost there, please help with choosing next commit
Date: Tue, 7 Sep 2010 16:34:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-tp42-00514-g6ad86c3; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2234222.6Gh7ZQvsFt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009071635.11110.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2234222.6Gh7ZQvsFt
Content-Type: multipart/mixed;
  boundary="Boundary-01=_81khMj+6J2MXyq9"
Content-Transfer-Encoding: 7bit


--Boundary-01=_81khMj+6J2MXyq9
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hello Alex and und Dave,

please excuse typing errors. The machine is abysmally slow with that=20
kernel.

I am almost there with bisecting Bug 16376, random - possibly Radeon DRM=20
KM related - freezes. I think I found the merge where is issue has been=20
introduced and I am now testing

martin@shambhala:~/Computer/Shambhala/Kernel/2.6.33-2.6.34-
bisect/linux-2.6> git log | head
commit 6ad86c311a8b8a6d856527a1b6ba21790ab7054b
Author: Alex Deucher <alexdeucher@gmail.com>
Date:   Thu Feb 11 10:47:52 2010 -0500

    drm/radeon/kms: remove HDP flushes from fence emit (v2)
   =20
    r600_ioctl_wait_idle() now handles this.
   =20
    v2: update blit fence counts

Unfortunately it has some other issues that has been fixed later on prior=20
to 2.6.34 already:

7.9.2010 - 2.6.32-tp42-00514-g6ad86c3
6ad86c311a8b8a6d856527a1b6ba21790ab7054b
=2D Sluggy desktop. Short pauses, locks of about a second.
=2D Slow scroll performance on tty.
=2D No complete freeze yet.
=2D Much CPU time used in system:70-90%

You know the changes in that merge better than me. Can you recommend which=
=20
commits to test next? Som commits may require other ones and thus it might=
=20
be wise to choose the next commits with that in mind. Maybe you already=20
have an idea which one it could be. I thought about the memory controllr=20
v2 changes, but I really don't have the foggiest.


Here is excerpt from atop which shows ridicully high system CPU usage with=
=20
that kernel.=20

ATOP - shambhala          2010/09/07  16:11:22               10 seconds=20
elapsed
PRC | sys   8.66s | user   1.30s | #proc    195 | #zombie    0 | #exit     =
=20
0 |
CPU | sys     85% | user     11% | irq       4% | idle      0% | wait     =
=20
0% |
CPL | avg1   3.39 | avg5    3.80 | avg15   3.25 | csw    18458 | intr  =20
11472 |
MEM | tot    2.0G | free  543.1M | cache 759.6M | buff   95.0M | slab  =20
37.8M |
SWP | tot    3.8G | free    3.8G |              | vmcom   1.3G | vmlim  =20
4.8G |
DSK |         sda | busy      3% | read       1 | write     95 | avio    2=
=20
ms |

I wrote by mail since bugzilla has too many MySQL connections again. Maybe=
=20
bug can be switched to mail?

Rebooting and testing this kernel another time whether it hard freezes,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--Boundary-01=_81khMj+6J2MXyq9
Content-Type: text/plain;
  charset="UTF-8";
  name="git-bisect-log-2010-09-07-2-for-bugreport.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="git-bisect-log-2010-09-07-2-for-bugreport.txt"

# bad: [64ba9926759792cf7b95f823402e2781edd1b5d4] Merge branch 'for-linus' =
of git://git.open-osd.org/linux-open-osd
# good: [60b341b778cc2929df16c0a504c91621b3c6a4ad] Linux 2.6.33
git bisect start '64ba9926759792cf7b95f823402e2781edd1b5d4' 'v2.6.33'
# skip: [d3ae8562d43fe2b97d605dd67dc67bf8fa9b956a] usb: host: ehci: fix mis=
sing kfree in remove path also
git bisect skip d3ae8562d43fe2b97d605dd67dc67bf8fa9b956a
# good: [8bd93a2c5d4cab2ae17d06350daa7dbf546a4634] rcu: Accelerate grace pe=
riod if last non-dynticked CPU
git bisect good 8bd93a2c5d4cab2ae17d06350daa7dbf546a4634
# skip: [5be796f0b842c5852d7397a82f8ebd6be8451872] USB: ch341: use get_unal=
igned_le16 in break_ctl
git bisect skip 5be796f0b842c5852d7397a82f8ebd6be8451872
# good: [6430a5987f8bb9a7c5187b343956aa8ef404d571] sh: Don't perform an icb=
i on a P2 address
git bisect good 6430a5987f8bb9a7c5187b343956aa8ef404d571
# skip: [0534d46848990e8eed7cd0832d745d813e827261] USB: consolidate remote =
wakeup routines
git bisect skip 0534d46848990e8eed7cd0832d745d813e827261
# good: [fad93fdb14f13e7b869a878c0fba3b6e0f91e0b6] V4L/DVB: STV0900 Cut 3.0=
 AGC2 fix for NetUP Dual DVB-S2-CI card
git bisect good fad93fdb14f13e7b869a878c0fba3b6e0f91e0b6
# skip: [cedf8a78421943441b9011ce7bcdab55f07d2ea6] USB: backlight, appledis=
play: fix incomplete registration failure handling
git bisect skip cedf8a78421943441b9011ce7bcdab55f07d2ea6
# good: [2581b1434ccba6960e0b671927d87c83b5152c9d] b43: N-PHY: implement an=
d add multi-dimensional table writing
git bisect good 2581b1434ccba6960e0b671927d87c83b5152c9d
# skip: [3a90f81872b00a7526c2bb1ed7664fe5af727f39] USB: usblp: Remove check=
s no longer needed with the new runtime PM system
git bisect skip 3a90f81872b00a7526c2bb1ed7664fe5af727f39
# good: [3a86e1807a53b7164c4ca2aec538d8a5d15416f1] pcmcia: do not use resou=
rce manager on !PCMCIA
git bisect good 3a86e1807a53b7164c4ca2aec538d8a5d15416f1
# skip: [124d255382ddd37ffa920e9f5183efa54bbfe4f2] USB: pl2303: remove unne=
cessary reset of usb_device in urbs
git bisect skip 124d255382ddd37ffa920e9f5183efa54bbfe4f2
# skip: [124d255382ddd37ffa920e9f5183efa54bbfe4f2] USB: pl2303: remove unne=
cessary reset of usb_device in urbs
git bisect skip 124d255382ddd37ffa920e9f5183efa54bbfe4f2
# skip: [9fc950d322380dda8e9bc8debe89766085e7a0eb] USB: cxacru: check devic=
e isn't being removed during sysfs calls
git bisect skip 9fc950d322380dda8e9bc8debe89766085e7a0eb
# skip: [124d255382ddd37ffa920e9f5183efa54bbfe4f2] USB: pl2303: remove unne=
cessary reset of usb_device in urbs
git bisect skip 124d255382ddd37ffa920e9f5183efa54bbfe4f2
# skip: [a880830e48e6fb7694de76ebb4a6c6bb0800f758] USB: ftdi_sio: remove ob=
solete check in unthrottle
git bisect skip a880830e48e6fb7694de76ebb4a6c6bb0800f758
# skip: [04b922c41710d770460c4663f69eabb0bf670be9] USB: ftdi_sio: remove un=
used tx_bytes counter
git bisect skip 04b922c41710d770460c4663f69eabb0bf670be9
# skip: [019ccc73201e933fe7d8119c90a812d347e325f9] USB: qcaux: driver for a=
uxiliary serial ports on Qualcomm devices
git bisect skip 019ccc73201e933fe7d8119c90a812d347e325f9
# skip: [67b9946dd07eeef8188e4cab816d2c370bcaa7b2] USB: pl2303: initial TIO=
CGSERIAL support
git bisect skip 67b9946dd07eeef8188e4cab816d2c370bcaa7b2
# skip: [ac7d4ca9e0b27d7705d273f17afd29828db35ee6] USB: option: add Longche=
er/Longsung vendor ID
git bisect skip ac7d4ca9e0b27d7705d273f17afd29828db35ee6
# skip: [8740cc7d0c532e098cc428251c08befd14f087d8] USB: fix I2C API usage i=
n ohci-pnx4008.
git bisect skip 8740cc7d0c532e098cc428251c08befd14f087d8
# skip: [47cb17089c059d24e5da03f2b44ee3a089075b78] USB: usbmon: mask second=
s properly in text API
git bisect skip 47cb17089c059d24e5da03f2b44ee3a089075b78
# skip: [444dc54c28740d90cb2d5f38e8163bcb46c5a885] USB: sisusbvga: no unnec=
essary GFP_ATOMIC
git bisect skip 444dc54c28740d90cb2d5f38e8163bcb46c5a885
# skip: [3756c7c091f4ca8bcaf89ee3855a326d69209716] USB: storage: onetouch: =
unnecessary GFP_ATOMIC
git bisect skip 3756c7c091f4ca8bcaf89ee3855a326d69209716
# skip: [46b72d78cb022714c89a9ebc00b9581b550cfca7] USB: serial: ftdi: add C=
ONTEC vendor and product id
git bisect skip 46b72d78cb022714c89a9ebc00b9581b550cfca7
# skip: [1f87158e44e79e62c8250f278c225ce4ab695f4b] USB: remove references t=
o port->port.count from the serial drivers
git bisect skip 1f87158e44e79e62c8250f278c225ce4ab695f4b
# skip: [a108bfcb372d8c4452701039308fb95747911c59] USB: tty: Prune uses of =
tty_request_room in the USB layer
git bisect skip a108bfcb372d8c4452701039308fb95747911c59
# skip: [2832fc11f1360668482beec06dbcd631ae5f0cf1] USB: tty: Add a function=
 to insert a string of characters with the same flag
git bisect skip 2832fc11f1360668482beec06dbcd631ae5f0cf1
# skip: [e4a3d94658b5760fc947d7f7185c57db47ca362a] USB: don't read past con=
fig->interface[] if usb_control_msg() fails in usb_reset_configuration()
git bisect skip e4a3d94658b5760fc947d7f7185c57db47ca362a
# skip: [b6a2f10ca045c9b0a4732c38485ad6ca1b663bf4] USB: tty: kill request_r=
oom for USB ACM class
git bisect skip b6a2f10ca045c9b0a4732c38485ad6ca1b663bf4
# skip: [67ccbd6f1af3025af3224be5c4f992aaf8811334] USB: tty: sort out the r=
equest_room handling for whiteheat
git bisect skip 67ccbd6f1af3025af3224be5c4f992aaf8811334
# skip: [5d3034ab8faea229942e79d867d18722d5375b12] USB: storage: fix mispla=
ced parenthesis
git bisect skip 5d3034ab8faea229942e79d867d18722d5375b12
# skip: [6d61ae9112960a2b3ed3360602dfb3bfd357954f] USB: vstusb.c: removal o=
f driver for Vernier Software & Technology, Inc., devices and spectrometers
git bisect skip 6d61ae9112960a2b3ed3360602dfb3bfd357954f
# skip: [cd780694920fbf869b23c8afb0bd083e7b0448c7] USB: fix the idProduct v=
alue for USB-3.0 root hubs
git bisect skip cd780694920fbf869b23c8afb0bd083e7b0448c7
# skip: [49d6271b85a3e18062eaf4d6f8d899abe00a7725] usb-storage: use max_hw_=
sectors instead of max_sectors
git bisect skip 49d6271b85a3e18062eaf4d6f8d899abe00a7725
# skip: [efe7daf2231a6beb59f0f641461d19fa62fb83ab] USB: OHCI: DA8xx/OMAP-L1=
x glue layer
git bisect skip efe7daf2231a6beb59f0f641461d19fa62fb83ab
# skip: [bdee2d8432f5af5af953896182a59ec1c5d6fa3a] USB: ehci: omap: Update =
TODO list in comments
git bisect skip bdee2d8432f5af5af953896182a59ec1c5d6fa3a
# skip: [9b43cffbbd3e9f77e16826513f26544cce3b5864] USB: ehci: omap: use def=
ault interrupt threshold
git bisect skip 9b43cffbbd3e9f77e16826513f26544cce3b5864
# skip: [bdb581bd6bd59a3303974977544d679d849214d1] USB: omap: ehci: kill 2 =
compile warnings
git bisect skip bdb581bd6bd59a3303974977544d679d849214d1
# skip: [b87c6e86dac1bb5222279cc8ff7e09529e1c4ed9] USB: serial: sierra driv=
er indat_callback fix
git bisect skip b87c6e86dac1bb5222279cc8ff7e09529e1c4ed9
# skip: [7650cd9678df29b01d1e46a9d2ce7e5d8c72b3ce] USB: serial: sierra driv=
er adding reset_resume function
git bisect skip 7650cd9678df29b01d1e46a9d2ce7e5d8c72b3ce
# skip: [05197921ff3dad52d99fd1647974c57d9c28d40e] USB: xhci: Fix finding e=
xtended capabilities registers
git bisect skip 05197921ff3dad52d99fd1647974c57d9c28d40e
# skip: [cceffe9348f93188d7811bda95924d4bd3040d0f] USB: remove debugging me=
ssage for uevent constructions
git bisect skip cceffe9348f93188d7811bda95924d4bd3040d0f
# skip: [49d3380e3f1297ff7bdc700c0a7fe6c3a036b3ab] tty: Fix various bogus W=
ARN checks in the usb serial layer
git bisect skip 49d3380e3f1297ff7bdc700c0a7fe6c3a036b3ab
# skip: [bd07c551aae5d2200c7b195142e5ba63f26424da] USB: cp210x: Add 81E8 (Z=
ephyr Bioharness)
git bisect skip bd07c551aae5d2200c7b195142e5ba63f26424da
# skip: [efcbd3df079a6f8a8a2d5207c4e8429e02356c79] USB: Extend and neaten d=
bg macros
git bisect skip efcbd3df079a6f8a8a2d5207c4e8429e02356c79
# skip: [f45ba776da4fe6c9a9eddd42b0fd5d1f15c260f3] USB: Convert concatenate=
d __FILE__ to %s, __FILE__
git bisect skip f45ba776da4fe6c9a9eddd42b0fd5d1f15c260f3
# skip: [759f3634267a67ac90f3fa7fc06510dfd43b4e45] USB: serial: Remove unne=
cessary=20
's from dbg uses
git bisect skip 759f3634267a67ac90f3fa7fc06510dfd43b4e45
# skip: [815e173e1d71742f1135fb4d4931e8115a3ca0ef] USB: ehci-dbgp: split PI=
D register updates for IN and OUT pipes
git bisect skip 815e173e1d71742f1135fb4d4931e8115a3ca0ef
# skip: [5272098365514ab232fa6a695d58c3961fec6b7a] USB: serial: Add support=
 for ViVOtech ViVOpay devices.
git bisect skip 5272098365514ab232fa6a695d58c3961fec6b7a
# skip: [640e95abdfae9fef5949084c92e80c8f2f8b5ec5] USB: atmel uaba: Adding =
invert vbus_pin
git bisect skip 640e95abdfae9fef5949084c92e80c8f2f8b5ec5
# skip: [90f7976880bbbf9968629500972f8e2f80401217] USB: Remove unsupported =
usb gadget drivers
git bisect skip 90f7976880bbbf9968629500972f8e2f80401217
# skip: [8e7e61dfbf1ec6418bf89505980b158a8d00d877] USB: f_mass_storage: fix=
 crash on bind() error
git bisect skip 8e7e61dfbf1ec6418bf89505980b158a8d00d877
# skip: [2b626dc134d38d0001b98acf8c7293b6bc5ee86d] USB: cdc-acm: fix possib=
le deadlock with multiple openers
git bisect skip 2b626dc134d38d0001b98acf8c7293b6bc5ee86d
# skip: [d7e18a9f2c506467ec7a9c066da45a0f60c6f5a6] USB: g_mass_storage: min=
(...) warning fixed
git bisect skip d7e18a9f2c506467ec7a9c066da45a0f60c6f5a6
# skip: [08e6c972da616d057b63fd3f89ce0eb539952f06] USB: musb: test always e=
valuates to false
git bisect skip 08e6c972da616d057b63fd3f89ce0eb539952f06
# skip: [db8516f61b481e82cec398474ed716d926de7f94] USB: isp1760: Flush the =
D-cache for the pipe-in transfer buffers
git bisect skip db8516f61b481e82cec398474ed716d926de7f94
# skip: [9714080d20f2ec4b671a06ce69367d91fa9e227e] USB: add new ftdi_sio de=
vice ids
git bisect skip 9714080d20f2ec4b671a06ce69367d91fa9e227e
# skip: [bd09a9f5318d0a088605911325d6e6e8530bdc9a] USB: ftdi_sio: Replace B=
KL with a mutex
git bisect skip bd09a9f5318d0a088605911325d6e6e8530bdc9a
# skip: [a79df50bbad3b58efb5f2c730ca20573a674de10] usb: gadgetfs: Convert s=
emaphore to mutex
git bisect skip a79df50bbad3b58efb5f2c730ca20573a674de10
# skip: [b00ce11f00c9e86442de000e8bd3dd42f089c8e1] USB: g_mass_storage: sup=
erfluous and missing packets fixed
git bisect skip b00ce11f00c9e86442de000e8bd3dd42f089c8e1
# skip: [7f1ee82695654faf0a93fc0abf3b08eb354ef1f6] USB: mass_storage: eject=
 LUNs on thread exit
git bisect skip 7f1ee82695654faf0a93fc0abf3b08eb354ef1f6
# skip: [9f445cb29918dc488b7a9a92ef018599cce33df7] USB: musb: disable doubl=
e buffering for older RTL versions
git bisect skip 9f445cb29918dc488b7a9a92ef018599cce33df7
# skip: [0ded2f146acfaf71e5f4c15b80cf89b3af48134c] USB: musb: set version o=
f Blackfin version
git bisect skip 0ded2f146acfaf71e5f4c15b80cf89b3af48134c
# skip: [5e23e90f33888769ffe253663cc5f3ea0bb6da49] USB: pxa27x_udc: Fix dea=
dlocks on request queueing
git bisect skip 5e23e90f33888769ffe253663cc5f3ea0bb6da49
# skip: [fb088e335d78f866be2e56eac6d500112a96aa11] USB: serial: add support=
 for serial port on the moschip 7715
git bisect skip fb088e335d78f866be2e56eac6d500112a96aa11
# skip: [f10718f5b812a2c55e37396518d426f88d5e35fc] USB: io_edgeport: elimin=
ate get_string()
git bisect skip f10718f5b812a2c55e37396518d426f88d5e35fc
# skip: [5b520259ab6d661b8d5eb39dd17cc5e4e4553c62] USB: s3c-hsotg: replace =
deprecated dma_sync_single()
git bisect skip 5b520259ab6d661b8d5eb39dd17cc5e4e4553c62
# skip: [ab3bbfa1af64a978ffff45861a1b694313a03537] USB: musb: only print in=
fo message if probe() is successful
git bisect skip ab3bbfa1af64a978ffff45861a1b694313a03537
# skip: [da5108e1a350c84b185b5f11aa58fea93a204fe0] USB: musb: unmap base if=
 we can't probe
git bisect skip da5108e1a350c84b185b5f11aa58fea93a204fe0
# skip: [3d268645d50989bc874fadf20db6fd6d17b380dc] USB: musb: tusb6010: use=
 resource_size
git bisect skip 3d268645d50989bc874fadf20db6fd6d17b380dc
# skip: [c58bfa6b97731590e42cba6bd13829c4e480992f] USB: musb: deprecate wha=
t we don't use
git bisect skip c58bfa6b97731590e42cba6bd13829c4e480992f
# skip: [ad517e9ed8723363ebff0c5b413cbaa503aeb0ce] USB: musb: we already te=
sted for dyn_fifo
git bisect skip ad517e9ed8723363ebff0c5b413cbaa503aeb0ce
# skip: [8573e6a673fc99bd89a6c08ef9841d8b52f9d3c5] USB: musb: get rid of om=
ap_readl/writel
git bisect skip 8573e6a673fc99bd89a6c08ef9841d8b52f9d3c5
# skip: [4f712e010b2da1cc01c178922f2eb5aaeae461b6] usb: musb: Add context s=
ave and restore support
git bisect skip 4f712e010b2da1cc01c178922f2eb5aaeae461b6
# skip: [8af6096caf8b3fb7ee33e636c44a29f373d27df5] USB: remove obsolete con=
fig in kernel source (USB_HCD_DMA)
git bisect skip 8af6096caf8b3fb7ee33e636c44a29f373d27df5
# skip: [0880aef49e40abd1ed34ab713e8b024e8bc2021e] USB: usbfs_snoop: add da=
ta logging back in
git bisect skip 0880aef49e40abd1ed34ab713e8b024e8bc2021e
# skip: [0978f8c55cdc7c06b2f1440b030e93fda2c53b2b] USB: s3c-hsotg: Staticis=
e non-exported functions
git bisect skip 0978f8c55cdc7c06b2f1440b030e93fda2c53b2b
# skip: [385f690bc058ba2555640740a1957826a40e4615] USB: trivial: missing ne=
wline in usb core warning message
git bisect skip 385f690bc058ba2555640740a1957826a40e4615
# skip: [330e3c4cc7179f9f3916cd147bf289467e16b169] USB: ftdi_sio: correct s=
pelling in implementation file
git bisect skip 330e3c4cc7179f9f3916cd147bf289467e16b169
# skip: [0a2a37752e8c62f7bf160ad196c9384095d347fd] USB: ftdi_sio: correct s=
pelling in header files
git bisect skip 0a2a37752e8c62f7bf160ad196c9384095d347fd
# skip: [a45a1e07aa5e4d3dc952c264f87184c5ac8c0a62] USB: serial: Eliminate u=
seless code
git bisect skip a45a1e07aa5e4d3dc952c264f87184c5ac8c0a62
# skip: [aa7907407adf1358ee39be0e98beaf4c129a78d6] USB: gadget: Add DEVTYPE=
 support for Ethernet functions
git bisect skip aa7907407adf1358ee39be0e98beaf4c129a78d6
# skip: [a8d4211f33a9573f7b1bdcfd9c9c48631d1515ee] USB: remove the berry_ch=
arge driver
git bisect skip a8d4211f33a9573f7b1bdcfd9c9c48631d1515ee
# skip: [2a9d0083f63da961a8cd4fdf9f4e8e6433c36966] USB: BKL removal from io=
ctl path of usbfs
git bisect skip 2a9d0083f63da961a8cd4fdf9f4e8e6433c36966
# skip: [9fd5c675864263e9f0e6bdb2d752bb380b32a01b] USB: BKL removal: fronti=
er
git bisect skip 9fd5c675864263e9f0e6bdb2d752bb380b32a01b
# skip: [eedf1f17d40e24ae80007bcbe7b7e997c32995c8] USB: BKL removal: vstusb
git bisect skip eedf1f17d40e24ae80007bcbe7b7e997c32995c8
# skip: [3c02b1d79e04e86f8bd2ff56da3743c2980f3e34] USB: BKL removal: legous=
btower
git bisect skip 3c02b1d79e04e86f8bd2ff56da3743c2980f3e34
# skip: [6248c52f6abd5783ecdd042f6107bd172168961e] USB: BKL removal: ldusb
git bisect skip 6248c52f6abd5783ecdd042f6107bd172168961e
# skip: [92846fbb861f64b9db21f06d6878ca02c67554dc] USB: BKL removal: ftdi-e=
lan
git bisect skip 92846fbb861f64b9db21f06d6878ca02c67554dc
# skip: [937f7131d7ea7762851c89a410c83e1c4b393234] USB: BKL removal: adutux
git bisect skip 937f7131d7ea7762851c89a410c83e1c4b393234
# skip: [dbdae3bd4af15c32e3b5eb6e608c1e2ea751b07f] USB: BKL removal: idmouse
git bisect skip dbdae3bd4af15c32e3b5eb6e608c1e2ea751b07f
# skip: [511e2d0218d04f544065eb277ad475bf14881efe] USB: BKL removal: rio500
git bisect skip 511e2d0218d04f544065eb277ad475bf14881efe
# skip: [5a207b431174ecc8f995230d19c79242160b8888] USB: BKL removal: mdc800
git bisect skip 5a207b431174ecc8f995230d19c79242160b8888
# skip: [94015f6e6ba11040f75f4b42aada8de23965290e] USB: BKL removal: cdc-wdm
git bisect skip 94015f6e6ba11040f75f4b42aada8de23965290e
# skip: [0022457a5469d328219dfb1ea5bd89d076e28372] USB: BKL removal: usbtmc
git bisect skip 0022457a5469d328219dfb1ea5bd89d076e28372
# skip: [b92a97efe00cf4e3555585f40dbe96512bba8f95] USB: BKL removal: usb-sk=
eleton
git bisect skip b92a97efe00cf4e3555585f40dbe96512bba8f95
# skip: [c8b492a86d71d43fb32e29282e6405663177b9e4] usb: BKL removal: usblp
git bisect skip c8b492a86d71d43fb32e29282e6405663177b9e4
# skip: [4e0961d53020b0fed83168d469ce44e1b3f25898] USB: isight-firmware: de=
clare MODULE_FIRMWARE
git bisect skip 4e0961d53020b0fed83168d469ce44e1b3f25898
# skip: [01412a219cae5f75ced3aacf1cb56cbe386af9ce] USB: Reduce scope of BKL=
 in usb ioctl handling
git bisect skip 01412a219cae5f75ced3aacf1cb56cbe386af9ce
# skip: [86266452f80545285c14e20a8024f79c4fb88a86] USB: Push BKL on open do=
wn into the drivers
git bisect skip 86266452f80545285c14e20a8024f79c4fb88a86
# skip: [f9de332ebf9df71892d52f7eb64af101a647349f] USB: Remove BKL from lse=
ek implementations
git bisect skip f9de332ebf9df71892d52f7eb64af101a647349f
# skip: [063e20eb980f281d8456c3b48f146107f5cb2338] USB: Remove BKL from usb=
dev_open()
git bisect skip 063e20eb980f281d8456c3b48f146107f5cb2338
# skip: [554f76962d3a6eb5110415f1591aca83f96a84ae] USB: Remove BKL from pol=
l()
git bisect skip 554f76962d3a6eb5110415f1591aca83f96a84ae
# skip: [08add0c780b9f5c35de49d83abb7a4e14a9cd457] USB: atm: Use FIELD_SIZE=
OF, trivial cleanup.
git bisect skip 08add0c780b9f5c35de49d83abb7a4e14a9cd457
# skip: [a74171005f2f6474e05bdfccb05c9f0d68224a49] USB: serial: option.c: A=
dd 4G W14 stick to blacklist for option_send_setup
git bisect skip a74171005f2f6474e05bdfccb05c9f0d68224a49
# skip: [cc175ce2c01fc78dbf98a2b00f23d8863de20764] USB: serial: option.c: A=
dd blacklisting infrastructure for special device handling
git bisect skip cc175ce2c01fc78dbf98a2b00f23d8863de20764
# skip: [79da01d79e0f2c8d2d6f1b823fce429877c423a7] USB: serial: option.c: A=
dd chipset information for 4G W14
git bisect skip 79da01d79e0f2c8d2d6f1b823fce429877c423a7
# skip: [1ba2557f298a64af4419ca094c5ecf99dc775354] USB goku_udc: make PCI d=
evice id constant
git bisect skip 1ba2557f298a64af4419ca094c5ecf99dc775354
# skip: [07824d3d69e923a5173f9066469c81d83c8d6eab] USB gadget: make Open Fi=
rmware device id constant
git bisect skip 07824d3d69e923a5173f9066469c81d83c8d6eab
# skip: [c4386ad07c318ae6188190e63b517ecc5ee3c883] USB host: make Open Firm=
ware device id constant
git bisect skip c4386ad07c318ae6188190e63b517ecc5ee3c883
# skip: [1e927d96cb5db0851cc5b9031f476b12a3e05182] USB hub: make USB device=
 id constant
git bisect skip 1e927d96cb5db0851cc5b9031f476b12a3e05182
# skip: [33b9e16243fd69493be3ddda7be73226c8be586a] USB misc: make USB devic=
e id constant
git bisect skip 33b9e16243fd69493be3ddda7be73226c8be586a
# skip: [9052127f631c8d71d5149da08d48014283faff2f] USB image: make USB devi=
ce id constant
git bisect skip 9052127f631c8d71d5149da08d48014283faff2f
# skip: [7d40d7e85a25e01948bcb4dc3eda1355af318337] USB serial: make USB dev=
ice id constant
git bisect skip 7d40d7e85a25e01948bcb4dc3eda1355af318337
# skip: [6ef4852b1326301f6e9657e99b2c3221be1a3a44] USB class: make USB devi=
ce id constant
git bisect skip 6ef4852b1326301f6e9657e99b2c3221be1a3a44
# skip: [1bd4f29d0af5b4b1c022d8fded14665dd5932905] USB skeleton: make USB d=
evice id constant
git bisect skip 1bd4f29d0af5b4b1c022d8fded14665dd5932905
# skip: [94089d56e456d2814c379538919180957a254e4a] USB: musb: don't derefer=
ence NULL tusb_dma in dma_controller_destroy()
git bisect skip 94089d56e456d2814c379538919180957a254e4a
# skip: [f7410ced7f931bb1ad79d1336412cf7b7a33cb14] USB: Move hcd free_dev c=
all into usb_disconnect to fix oops
git bisect skip f7410ced7f931bb1ad79d1336412cf7b7a33cb14
# skip: [d23356da714595b888686d22cd19061323c09190] USB: fix crash in uhci_s=
can_schedule
git bisect skip d23356da714595b888686d22cd19061323c09190
# skip: [9bbdf1e0afe771ca7650f9f476769310bee9d8f3] USB: convert to the runt=
ime PM framework
git bisect skip 9bbdf1e0afe771ca7650f9f476769310bee9d8f3
# skip: [0c590e2361511997430130e10e372217c1128da6] USB: rearrange functions=
 in driver.c
git bisect skip 0c590e2361511997430130e10e372217c1128da6
# skip: [5899f1e020c8d53b2b6fbd6a6cf39c891ccdfade] USB: change handling of =
negative autosuspend delays
git bisect skip 5899f1e020c8d53b2b6fbd6a6cf39c891ccdfade
# skip: [088f7fec8a0e683db72fd8826c5d3ab914e197b1] USB: implement usb_enabl=
e_autosuspend
git bisect skip 088f7fec8a0e683db72fd8826c5d3ab914e197b1
# skip: [0c4db6df915bc470f0cd32fe48287fa6eb6adfb4] USB: use the device lock=
 for persist_enabled
git bisect skip 0c4db6df915bc470f0cd32fe48287fa6eb6adfb4
# skip: [0534d46848990e8eed7cd0832d745d813e827261] USB: consolidate remote =
wakeup routines
git bisect skip 0534d46848990e8eed7cd0832d745d813e827261
# skip: [62e299e61a6ffe8131fa85a984c3058b68586f5d] USB: change locking for =
device-level autosuspend
git bisect skip 62e299e61a6ffe8131fa85a984c3058b68586f5d
# skip: [0f3dda9f7ff2db8dbf4d6fbab4d4438251446002] USB: rearrange code in u=
sb_probe_interface
git bisect skip 0f3dda9f7ff2db8dbf4d6fbab4d4438251446002
# skip: [d837e219daf3bf0cc84fcfb9781807d9fe8d03b5] USB: Use bInterfaceNumbe=
r in bandwidth allocations.
git bisect skip d837e219daf3bf0cc84fcfb9781807d9fe8d03b5
# skip: [46216e4fbe8c62059b5440dec0b236f386248a41] USB: unusual_devs: Add s=
upport for multiple Option 3G sticks
git bisect skip 46216e4fbe8c62059b5440dec0b236f386248a41
# skip: [bce54fed941e03695ab557100a4bd1e457abca42] arm: defconfig: rx51: en=
able phonet and g_nokia
git bisect skip bce54fed941e03695ab557100a4bd1e457abca42
# skip: [f358f5b40af67caf28b627889d007294614170b2] USB: gadget: introduce g=
_nokia gadget driver
git bisect skip f358f5b40af67caf28b627889d007294614170b2
# skip: [9c9a7dbf9a73191a24a13b9a0412355254a122c7] USB: xhci: Fix compile i=
ssues with xhci_get_slot_state()
git bisect skip 9c9a7dbf9a73191a24a13b9a0412355254a122c7
# skip: [c38b94017c74061cabc342d3222387e0a5e8b6cd] USB: c67x00: use resourc=
e_size().
git bisect skip c38b94017c74061cabc342d3222387e0a5e8b6cd
# skip: [4585ef11d23aa9dbbf776b135ba70577df97587b] USB: FHCI: Correct the s=
ize argument to kzalloc
git bisect skip 4585ef11d23aa9dbbf776b135ba70577df97587b
# skip: [0f2c2d7bbb51338fdcda9670795a6c6e348622d9] USB: cypress_m8: use put=
_unaligned_le32() where necessary
git bisect skip 0f2c2d7bbb51338fdcda9670795a6c6e348622d9
# skip: [5be796f0b842c5852d7397a82f8ebd6be8451872] USB: ch341: use get_unal=
igned_le16 in break_ctl
git bisect skip 5be796f0b842c5852d7397a82f8ebd6be8451872
# skip: [d0ef90b49857b403c1cfa62fce229c967dd4be40] USB: serial: fix DMA buf=
fers on stack for io_edgeport.c
git bisect skip d0ef90b49857b403c1cfa62fce229c967dd4be40
# skip: [96679f6bd5e1ccb30671b81636b4fdc326e46d8a] USB: kobil_sct: clean up=
 kobil_set_termios
git bisect skip 96679f6bd5e1ccb30671b81636b4fdc326e46d8a
# skip: [401711cb575bbbdb100bc1a14cb2024dfc9b4869] USB: visor: fix DMA buff=
ers on stack
git bisect skip 401711cb575bbbdb100bc1a14cb2024dfc9b4869
# skip: [d2126326bd71b56fcaa5e86474433d11e253f84d] USB: oti6858: fix DMA bu=
ffer on stack
git bisect skip d2126326bd71b56fcaa5e86474433d11e253f84d
# skip: [9e221a35f82cbef0397d81fed588bafba95b550c] USB: mos7840: fix DMA bu=
ffers on stack and endianess bugs
git bisect skip 9e221a35f82cbef0397d81fed588bafba95b550c
# skip: [eb771e2c6507e0a317e576a3147252ebcb64035a] USB: mos7720: fix DMA bu=
ffers on stack and clean up send_mos_cmd
git bisect skip eb771e2c6507e0a317e576a3147252ebcb64035a
# skip: [abf492e7b3ae74873688cf9960283853a3054471] USB: kl5kusb105: fix DMA=
 buffers on stack
git bisect skip abf492e7b3ae74873688cf9960283853a3054471
# skip: [ca65d256c8f1604f8ec8e258109d23280687186c] USB: keyspan_pda: fix DM=
A buffers on stack
git bisect skip ca65d256c8f1604f8ec8e258109d23280687186c
# skip: [e9305d2f4b5ffa9ea0261212d542956bede2a2ff] USB: io_ti: fix DMA buff=
ers on stack
git bisect skip e9305d2f4b5ffa9ea0261212d542956bede2a2ff
# skip: [974fccb7aba8ca4ff887836e26c0ac4c99d041ca] USB: cypress_m8: fix end=
ianess bug
git bisect skip 974fccb7aba8ca4ff887836e26c0ac4c99d041ca
# skip: [0954644bf5a5a2281746516ce0f5df988d504c31] USB: cypress_m8: fix DMA=
 buffer on stack
git bisect skip 0954644bf5a5a2281746516ce0f5df988d504c31
# skip: [52372ccb5a19d35b68b79118fafdced0c12f0ec9] USB: ch341: use le16_to_=
cpup to be explicit about endianess
git bisect skip 52372ccb5a19d35b68b79118fafdced0c12f0ec9
# skip: [f2b5cc834b69d2999b749144481de9a94f01bc48] USB: ch341: fix DMA buff=
er on stack
git bisect skip f2b5cc834b69d2999b749144481de9a94f01bc48
# skip: [6a9b15fed4dca1f90e41ae0cfe35aaa39a20f495] USB: ch341: replace prin=
tk warnings with dev_err
git bisect skip 6a9b15fed4dca1f90e41ae0cfe35aaa39a20f495
# skip: [881142660697bba0f3ef44f070d80632082c978f] usb: host: ehci: adding =
regulator framework in ehci-omap.c driver.
git bisect skip 881142660697bba0f3ef44f070d80632082c978f
# skip: [d3ae8562d43fe2b97d605dd67dc67bf8fa9b956a] usb: host: ehci: fix mis=
sing kfree in remove path also
git bisect skip d3ae8562d43fe2b97d605dd67dc67bf8fa9b956a
# skip: [5fc4e77911f457b6aa910c704eebe3a58d334116] usb: musb: Add 'extvbus'=
 in musb_hdrc_platform_data
git bisect skip 5fc4e77911f457b6aa910c704eebe3a58d334116
# skip: [51bf0d0e6cc1f9679a973f61d07cb48e71f9c992] usb: musb: save dynfifo =
in musb struct
git bisect skip 51bf0d0e6cc1f9679a973f61d07cb48e71f9c992
# skip: [1c25fda4a09e8229800979986ef399401053b46e] usb: musb: handle irqs i=
n the order dictated by programming guide
git bisect skip 1c25fda4a09e8229800979986ef399401053b46e
# skip: [1ca9e9ca314c4757409a7f4e9c1f12229a175834] usb: musb: clean up comm=
it 'workaround Blackfin FIFO anomalies'
git bisect skip 1ca9e9ca314c4757409a7f4e9c1f12229a175834
# skip: [565969237ab6e73ce7192684d00d5b890ee308fa] usb: musb: Fix cppi_chan=
nel_abort() function to handle Tx abort correctly
git bisect skip 565969237ab6e73ce7192684d00d5b890ee308fa
# skip: [5274dab6cb99c529b2e7f16bbc8ff9a79be46e7f] usb: musb: workaround to=
ggle bug when doing bulk transfer after isoc
git bisect skip 5274dab6cb99c529b2e7f16bbc8ff9a79be46e7f
# skip: [f933a0c0fe0ea5f49a35bcd45e3e4850e0606cba] usb: musb: workaround MU=
SB DMA_INTR sometimes reads zero
git bisect skip f933a0c0fe0ea5f49a35bcd45e3e4850e0606cba
# skip: [452f0394376d2cc882e4c4a593fc290c042799a9] usb: musb: hsdma: add wr=
apper for reading DMA count
git bisect skip 452f0394376d2cc882e4c4a593fc290c042799a9
# skip: [3b151526eda87901532390e11bba0dd59119f667] USB: musb: Add new fifo =
table for a OMAP3 errata
git bisect skip 3b151526eda87901532390e11bba0dd59119f667
# skip: [8f20960cd772fe42a9cdd36312b2247bc2800ffb] usb: otg: twl4030: move =
to request_threaded_irq
git bisect skip 8f20960cd772fe42a9cdd36312b2247bc2800ffb
# skip: [c9188ad25dde86e929bd567166b5a1366a3a9059] USB: Correct CONFIG vari=
able typo.
git bisect skip c9188ad25dde86e929bd567166b5a1366a3a9059
# skip: [3a90f81872b00a7526c2bb1ed7664fe5af727f39] USB: usblp: Remove check=
s no longer needed with the new runtime PM system
git bisect skip 3a90f81872b00a7526c2bb1ed7664fe5af727f39
# skip: [c1284d7726c57c9d2bbc65cd08173fe7f9e637df] USB: ftdi_sio: remove un=
necessary initialisations
git bisect skip c1284d7726c57c9d2bbc65cd08173fe7f9e637df
# skip: [a3f8168b7a3a7d9dfb9bb9caa1e009a5ce2a8493] USB: ftdi_sio: clean up =
modem status handling
git bisect skip a3f8168b7a3a7d9dfb9bb9caa1e009a5ce2a8493
# skip: [66e47e6006a558b33c6f15bd2e072d52c40e0159] USB: ftdi_sio: fix DMA b=
uffers on stack
git bisect skip 66e47e6006a558b33c6f15bd2e072d52c40e0159
# skip: [54f328d0c7221675e3c1647e1918172fec1b92c9] USB: ftdi_sio: fix laten=
cy-timeout endianess bug
git bisect skip 54f328d0c7221675e3c1647e1918172fec1b92c9
# skip: [4357369d024c709d91864af88f02d7ac08d0f470] USB: ftdi_sio: use error=
 code from usb stack in read_latency_timer
git bisect skip 4357369d024c709d91864af88f02d7ac08d0f470
# skip: [551cdbbeb118bd5ed301f8749aef69219284399b] USB: rename USB_SPEED_VA=
RIABLE to USB_SPEED_WIRELESS
git bisect skip 551cdbbeb118bd5ed301f8749aef69219284399b
# skip: [16985408b5c48585762ec3b9b7bae1dec4ad7437] USB: retain USB device p=
ower/wakeup setting across reconfiguration
git bisect skip 16985408b5c48585762ec3b9b7bae1dec4ad7437
# skip: [ce126644aa10bf1d8f1c1929b65adab026095761] USB: cdc_acm: Silence "I=
t is not a modem." error for pbLua devices
git bisect skip ce126644aa10bf1d8f1c1929b65adab026095761
# skip: [7c5d8c394a077a686cfa646cd85dc159a2a940cc] USB: cdc_acm: Add suppor=
t for pbLua console port
git bisect skip 7c5d8c394a077a686cfa646cd85dc159a2a940cc
# skip: [2bc0d109326e9f2b25fa1dfcc9de2489e1e00e36] usbmon: add bus number t=
o text API
git bisect skip 2bc0d109326e9f2b25fa1dfcc9de2489e1e00e36
# skip: [7ed069c12c866c5c06e4e05d26878797e3731829] USB: musb: remove some o=
f the never defined defines
git bisect skip 7ed069c12c866c5c06e4e05d26878797e3731829
# skip: [94375751d1d8af70df08beebdc32595f9e4537e1] USB: musb: move to sysfs=
_groups
git bisect skip 94375751d1d8af70df08beebdc32595f9e4537e1
# skip: [b3b1cc3ba62374e71155ba8c09ee481c3c2d923e] USB: musb: move two prin=
tk to dev_err
git bisect skip b3b1cc3ba62374e71155ba8c09ee481c3c2d923e
# skip: [195e9e4691ad0544746540852e03d7c8c6c877ea] USB: musb: use resource_=
size()
git bisect skip 195e9e4691ad0544746540852e03d7c8c6c877ea
# skip: [767ffec15e25b34c7194e47f0ad1fbf63a568d44] USB: gadget: add INT sup=
port for Blackfin musb
git bisect skip 767ffec15e25b34c7194e47f0ad1fbf63a568d44
# skip: [3a8a3b1cee6c525661732b8bcf29ac63d42945ed] USB: gadget: use ep5 for=
 bulk-in and ep6 for bulk-out for Blackfin MUSB
git bisect skip 3a8a3b1cee6c525661732b8bcf29ac63d42945ed
# skip: [ca0e9485afb8db3abf58235abf6afded2df0db17] USB: host: SL811: allow =
the hcd on Blackfin systems
git bisect skip ca0e9485afb8db3abf58235abf6afded2df0db17
# skip: [8ca5bfab154487fd75a946e6e95d3519eb74be6a] USB: host: SL811: fix un=
aligned accesses
git bisect skip 8ca5bfab154487fd75a946e6e95d3519eb74be6a
# skip: [6ebb7d1b4b98162e332ff43a8739c2c1c690b140] USB: isp1362: Use kzallo=
c for allocating only one thing
git bisect skip 6ebb7d1b4b98162e332ff43a8739c2c1c690b140
# skip: [c312659c5ff1e54bac2d91e1ce1005d58784a7b5] USB: cypress_m8: allow u=
nstable baud rates
git bisect skip c312659c5ff1e54bac2d91e1ce1005d58784a7b5
# skip: [2805eb13c3b5be7bd6ec7380502bc054b570afd5] USB: cypress_m8: unify c=
onfusing new baudrate check
git bisect skip 2805eb13c3b5be7bd6ec7380502bc054b570afd5
# skip: [64319dd74f3d45f13b6d0aafa91104eb105f1829] USB: cypress_m8: stop us=
ing USB debug driver config
git bisect skip 64319dd74f3d45f13b6d0aafa91104eb105f1829
# skip: [ef955341f692475236f0fbe6853f49337dff77a5] USB: Export QUIRK_RESET_=
MORPHS through sysfs
git bisect skip ef955341f692475236f0fbe6853f49337dff77a5
# skip: [5d3987796c7a747e5ed3ded1eb64a9632d52a1a4] USB: storage: Never rese=
t devices that will morph to an old mode
git bisect skip 5d3987796c7a747e5ed3ded1eb64a9632d52a1a4
# skip: [d1b5b5c0a8a8204f0c51d5eb99736ecfb2fd5b4e] USB: otg: twl4030: add s=
upport for notifier
git bisect skip d1b5b5c0a8a8204f0c51d5eb99736ecfb2fd5b4e
# skip: [e9a20171dfa0aa134d2211126d1310f2daea52cf] USB: otg: add notifier s=
upport
git bisect skip e9a20171dfa0aa134d2211126d1310f2daea52cf
# skip: [8bc1d21776bb012e41ed062c6d842cfe7c82998a] USB: wusb: check CHID is=
 all zeros before stopping the host
git bisect skip 8bc1d21776bb012e41ed062c6d842cfe7c82998a
# skip: [319c3ea451e19f72b578661e26fb33739af5ae1c] USB: xhci: No GFP_KERNEL=
 in block error handling
git bisect skip 319c3ea451e19f72b578661e26fb33739af5ae1c
# skip: [97d35f95552c9a0ee4777a7f04431a9fd1260478] USB: cdc-acm: Update to =
new autopm API
git bisect skip 97d35f95552c9a0ee4777a7f04431a9fd1260478
# skip: [1f141ca2b1f40088203fba061cc7b1f8da7c38ab] USB: ehci-au1xxx.c: use =
platform_get_resource() and resource_size()
git bisect skip 1f141ca2b1f40088203fba061cc7b1f8da7c38ab
# skip: [f65c3540d316982c906e6ece7ccad00bba84574e] USB: ehci-atmel.c: use r=
esource_size()
git bisect skip f65c3540d316982c906e6ece7ccad00bba84574e
# skip: [5672b7e6a99a91838c1b595a80d43006bcd9a178] USB: ehci-orion.c: use r=
esource_size()
git bisect skip 5672b7e6a99a91838c1b595a80d43006bcd9a178
# skip: [d8bb0fd26b555f505019b9b68b6d581fb9f80348] USB: at91_udc.c: use res=
ource_size()
git bisect skip d8bb0fd26b555f505019b9b68b6d581fb9f80348
# skip: [3ba37bdaef3bea9fa166eae6051949d629e7ea83] USB: atmel_usba_udc.c: u=
se resource_size()
git bisect skip 3ba37bdaef3bea9fa166eae6051949d629e7ea83
# skip: [5c90e314a62f09bf4dda4ec5cf50b904540ffa34] USB: pxa27x_udc.c: use r=
esource_size()
git bisect skip 5c90e314a62f09bf4dda4ec5cf50b904540ffa34
# skip: [1af107744253b01b4cf119a9bb3369376b01658b] USB: ehci-fsl: Add power=
 management support
git bisect skip 1af107744253b01b4cf119a9bb3369376b01658b
# skip: [dad3843f035a273f9b64e133467e8dcbfaf0ce60] USB: ehci-fsl: Fix spars=
e warnings
git bisect skip dad3843f035a273f9b64e133467e8dcbfaf0ce60
# skip: [22e186948a262c9cd377fb43aa50bb3c3f01c468] USB: ehci: fix audio rec=
ord functionality for some Full speed sound blaster devices
git bisect skip 22e186948a262c9cd377fb43aa50bb3c3f01c468
# skip: [d63c66d2d08f52487f3ef32f1c9b1231d848966b] USB: ehci: add call of f=
ree_cached_itd_list() function in disable_periodic()
git bisect skip d63c66d2d08f52487f3ef32f1c9b1231d848966b
# skip: [a5f0efaba4c2b644e6248648f75b0a8a522359f6] USB: Add call to notify =
xHC of a device reset.
git bisect skip a5f0efaba4c2b644e6248648f75b0a8a522359f6
# skip: [2a8f82c4ceaffcfd64531dbdee1d1bc227387882] USB: xhci: Notify the xH=
C when a device is reset.
git bisect skip 2a8f82c4ceaffcfd64531dbdee1d1bc227387882
# skip: [6219c047d3fe18dee4916d6898fc94f5a7ffd156] USB: xhci: Allow roothub=
 ports to be disabled.
git bisect skip 6219c047d3fe18dee4916d6898fc94f5a7ffd156
# skip: [34fb562a436ca50e13c05e7584c9d62f151052bf] USB: xhci: Refactor code=
 to clear port change bits.
git bisect skip 34fb562a436ca50e13c05e7584c9d62f151052bf
# skip: [b45b506911247008f694dcaf1d8220a4942ebc4f] USB: xhci: Refactor test=
 for vendor-specific completion codes.
git bisect skip b45b506911247008f694dcaf1d8220a4942ebc4f
# skip: [a1d78c16bd31a715785e21967ac6110b386a3c1f] USB: xhci: Allow allocat=
ion of commands without input contexts.
git bisect skip a1d78c16bd31a715785e21967ac6110b386a3c1f
# skip: [412566bd716397e28e81fc9b20804bc6a6daf14d] USB: xhci: Refactor code=
 to free or cache endpoint rings.
git bisect skip 412566bd716397e28e81fc9b20804bc6a6daf14d
# skip: [c01591bd6ece72e1c099cbc25ed812e1add579dc] USB: xhci: Fix error pat=
h when configuring endpoints.
git bisect skip c01591bd6ece72e1c099cbc25ed812e1add579dc
# skip: [f661c6f8c67bd55e93348f160d590ff9edf08904] USB: check the endpoint =
type against the pipe type
git bisect skip f661c6f8c67bd55e93348f160d590ff9edf08904
# skip: [a91b0c502285fd0c569fae1222fdd945ef739233] cdc_acm: add reset_resum=
e method
git bisect skip a91b0c502285fd0c569fae1222fdd945ef739233
# skip: [af2ac1a091bc8bee73d7837b73ebfb00b917aece] USB: serial mct_usb232: =
move DMA buffers to heap
git bisect skip af2ac1a091bc8bee73d7837b73ebfb00b917aece
# skip: [4fdb31d9665a9106190d9f8888cf06252c20f3ce] USB: pxa27x_udc: avoid c=
ompiler warnings and misbehavior on buggy hardware
git bisect skip 4fdb31d9665a9106190d9f8888cf06252c20f3ce
# skip: [2f0e40aba1cafe3a834bfcbac8f1e704d496dab9] USB: fix occasional ULPI=
 timeouts with ehci-mxc
git bisect skip 2f0e40aba1cafe3a834bfcbac8f1e704d496dab9
# skip: [cabe6cc2be287d0020d70944e8d0d0304e484a6c] USB: ftdi_sio: remove su=
pport for 5 and 6 data bits
git bisect skip cabe6cc2be287d0020d70944e8d0d0304e484a6c
# skip: [8c4f99cd54469d643e27a743045da848f7b63fe5] USB: ftdi_sio: fix initi=
alisation of latency timeout
git bisect skip 8c4f99cd54469d643e27a743045da848f7b63fe5
# skip: [b4fc2aeef23b4b35809054ddf495f9efdc3ac9d6] USB: serial: fix typo in=
 debug message
git bisect skip b4fc2aeef23b4b35809054ddf495f9efdc3ac9d6
# skip: [0076b4bec5cffff856ec4a91830c902fbd7870df] USB: ftdi_sio: remove ob=
solete comment
git bisect skip 0076b4bec5cffff856ec4a91830c902fbd7870df
# skip: [e2b5cbfe77ecbbeccc38a486e054a59aaaf028c8] USB: ftdi_sio: fix error=
 message on close
git bisect skip e2b5cbfe77ecbbeccc38a486e054a59aaaf028c8
# skip: [30fa3d8ed0a61703281bde948f7590d843308b4a] USB: cxacru: increment d=
river version
git bisect skip 30fa3d8ed0a61703281bde948f7590d843308b4a
# skip: [817db5b34e70650c488f22b072b7efb950812adb] USB: cxacru: remove cxac=
ru-cf.bin loader
git bisect skip 817db5b34e70650c488f22b072b7efb950812adb
# skip: [4ac37208e9b30b36b615ed22a79b4ee787fdc9b5] USB: cxacru: add write-o=
nly sysfs attribute for modem configuration
git bisect skip 4ac37208e9b30b36b615ed22a79b4ee787fdc9b5
# skip: [885582c48e5fbf47ccc4273aaa5f2f56ad513253] USB: cxacru: firmware wr=
ites on OHCI are slow, log progress
git bisect skip 885582c48e5fbf47ccc4273aaa5f2f56ad513253
# skip: [c68bb0d738897ed39b90c7ccb22e01c938117051] USB: cxacru: document ho=
w to interact with the flash memory
git bisect skip c68bb0d738897ed39b90c7ccb22e01c938117051
# skip: [36706005d90642bccabfaacbb24d135155e984a8] ALSA: hda - Add support =
for IDT 92HD88 family codecs
git bisect skip 36706005d90642bccabfaacbb24d135155e984a8
# good: [11b897cf84c37e6522db914793677e933ef311fb] MIPS: Alchemy: use 36bit=
 addresses for PCMCIA resources.
git bisect good 11b897cf84c37e6522db914793677e933ef311fb
# good: [2507c05ff55fbf38326b08ed27eaed233bc75042] virtio_net: remove forgo=
tten assignment
git bisect good 2507c05ff55fbf38326b08ed27eaed233bc75042
# good: [a27341cd5fcb7cf2d2d4726e9f324009f7162c00] Prioritize synchronous s=
ignals over 'normal' signals
git bisect good a27341cd5fcb7cf2d2d4726e9f324009f7162c00
# bad: [68de7745822f0dc2eea940e3c1fc65896d7afc88] Merge branch 'drm-radeon-=
testing' of /ssd/git/drm-radeon-next into drm-next-stage
git bisect bad 68de7745822f0dc2eea940e3c1fc65896d7afc88
# bad: [eb6b6d7cdd5548fa03a919d14615195600013be2] Merge remote branch 'korg=
/drm-radeon-testing' into drm-next-stage
git bisect bad eb6b6d7cdd5548fa03a919d14615195600013be2

--Boundary-01=_81khMj+6J2MXyq9--

--nextPart2234222.6Gh7ZQvsFt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkyGTX4ACgkQmRvqrKWZhMetKQCfb98zRwWxbL/91p0NeKhfFLIm
ZRYAn1sjWjQjx+qdx3iu9Jugus7YMoNp
=XCqQ
-----END PGP SIGNATURE-----

--nextPart2234222.6Gh7ZQvsFt--
