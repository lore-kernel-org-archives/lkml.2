Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516Ab0JIXiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 19:38:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52799 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324Ab0JIXiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 19:38:19 -0400
Date: Sun, 10 Oct 2010 10:38:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: stable cc's in linux -next was Re: [BUG] x86: bootmem broken on
 SGI UV
Message-Id: <20101010103810.497bb0e6.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
References: <AANLkTinyA=bSeSe7eavUb7fuSgM8m=QQFGqCrNtCGqKa@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__10_Oct_2010_10_38_10_+1100_IclCjblVAgdyS=h9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__10_Oct_2010_10_38_10_+1100_IclCjblVAgdyS=h9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Sun, 10 Oct 2010 07:34:58 +1000 Dave Airlie <airlied@gmail.com> wrote:
>
> On Sun, Oct 10, 2010 at 4:39 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Sat, Oct 9, 2010 at 11:06 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>
> >> It is too late for put in 2.6.36. Linus already had -rc7, and assume h=
e will have final .36 this week.
> >
> > Anything that is worth tagging for stable is worth fixing before the
> > final release (probably Wednesday).
>=20
> Do we track people dong this at all? I wonder how many patches in
> linux-next have cc: stable in them but haven't been submitted to
> Linus,

Good idea.  The "stable" branch of linux-next is just where in Linus'
tree that's day's linux-next was based.

# Friday's linux-next:
$ git log --pretty=3Doneline -i --grep=3D"cc:[ 	]*stable" stable.. | wc -l
71
# origin/master is Linus' current tree
$ git fetch origin
$ git log --pretty=3Doneline -i --grep=3D"cc:[ 	]*stable" origin/master.. |=
 wc -l
70
# so at least one went in over the weekend

Some of these will be false positives because commits get rebased before
being sent to Linus (quilt trees especially).

Here is the result of
"git log --pretty=3Dshort -i --grep=3D"cc:[ 	]*stable" origin/master.."

commit 747f99ecf70ebc265adc50eed19e5fc179715758
Author: Anders Larsen <al@alarsen.net>

    USB: cp210x: Add WAGO 750-923 Service Cable device ID

commit b9e391ee38b9bdddef410603596a4b2769795dcc
Author: Alan Stern <stern@rowland.harvard.edu>

    USB: disable endpoints after unbinding interfaces, not before

commit 28764ad222865cb748be18e5ad8cf908c6c21efa
Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>

    usb: musb: blackfin: call gpio_free() on error path in musb_platform_in=
it()

commit 2cc7db36355791d4da5f852479e15de89aee2672
Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>

    usb: musb: blackfin: call usb_nop_xceiv_unregister() in musb_platform_e=
xit()

commit 91b8a39e1a85dec2ad484b530c550348033ae940
Author: Sergei Shtylyov <sshtylyov@ru.mvista.com>

    USB: MUSB: fix kernel WARNING/oops when unloading module in OTG mode

commit dcbe132d385b3cf0f4da78a30b50df0e694b5d30
Author: Rainer Keller <mail@rainerkeller.de>

    USB: add PID for FTDI based OpenDCC hardware

commit f32cea35e9c43adae3f6789bf2409242ce91d1f1
Author: Johan Hovold <jhovold@gmail.com>

    USB: ftdi_sio: revert "USB: ftdi_sio: fix DTR/RTS line modes"

commit 4fe9ad067d56a50cd95a0eac6d3ebb86816c30d8
Author: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

    USB: atmel_usba_udc: force vbus_pin at -EINVAL when gpio_request failled

commit 10f2196e7ef07d1ae55611f4fc89caa62a85d019
Author: DJ Delorie <dj@delorie.com>

    USB: cp210x: Add Renesas RX-Stick device ID

commit dd022f3a234f943c91e6e5d74691468843e3d04e
Author: Rich Mattes <richmattes@gmail.com>

    USB: ftdi_sio: Add PID for accesio products

commit 5d36016ea57e0897283a8f65aa427a6495e98d99
Author: Mauro Carvalho Chehab <mchehab@redhat.com>

    USB: option: Add more ZTE modem USB id's

commit 73618fe62631814ec43f99e01b4d01de304c2b10
Author: Roger Quadros <roger.quadros@nokia.com>

    usb gadget: composite: prevent OOPS for non-standard control request

commit eceeff8c20a9598a80f05bdfd5a0e86faea9eed6
Author: Alan Stern <stern@rowland.harvard.edu>

    OHCI: work around for nVidia shutdown problem

commit bdcb0a1ae8665149643b47eab4bd3683851a62bb
Author: Praveena Nadahally <praveen.nadahally@stericsson.com>

    USB: Change acm_iad_descriptor bFunctionProtocol to USB_CDC_ACM_PROTO_A=
T_V25TER

commit 76c1752d0eb0ad6e2fa28baa44b7683b5c749d16
Author: Michal Nazarewicz <m.nazarewicz@samsung.com>

    USB: gadget: g_ffs: fixed vendor and product ID

commit 383b2342376bff61cd6e98c727b664881ebc7b62
Author: Michal Nazarewicz <m.nazarewicz@samsung.com>

    USB: gadget: g_multi: fixed vendor and product ID

commit ed750ab020cbb23852ccaf1412582365f22aa506
Author: Yegor Yefremov <yegor_sub1@visionsystems.de>

    i2c-pca: Fix waitforcompletion() return value

commit b86276e88c60144487a42b124e475446a25c7eec
Author: Trond Myklebust <Trond.Myklebust@netapp.com>

    NFS: Don't SIGBUS if nfs_vm_page_mkwrite races with a cache invalidation

commit d5e8c46a89e22f5d83ce7f68968b785407492f37
Author: Olivier Grenie <olivier.grenie@dibcom.fr>

    V4L/DVB: dib7770: enable the current mirror

commit c1bb0b023a5ff67185baa689087a44b5b5779e9d
Author: Mauro Carvalho Chehab <mchehab@redhat.com>

    V4L/DVB: Don't identify PV SBTVD Hybrid as a DibCom device

commit 3207390a8b58bfc1335750f91cf6783c48ca19ca
Author: Johannes Berg <johannes.berg@intel.com>

    cfg80211: fix BSS double-unlinking

commit 5ae4ef8313c85f443202aa04405fe178e6138a6a
Author: Johannes Weiner <hannes@cmpxchg.org>

    xfs: properly account for reclaimed inodes

commit 713c353be46d7fd26144dded426661c5bd09e452
Author: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

    eCryptfs: Clear LOOKUP_OPEN flag when creating lower file

commit 8a1e6b7d1db71198995ddf980946f58c97d7594d
Author: Roberto Sassu <roberto.sassu@polito.it>

    ecryptfs: call vfs_setxattr() in ecryptfs_setxattr()

commit e42dee9a99a3ecd32b5c027e8f7411fb5bc11eb6
Author: Antonio Ospite <ospite@studenti.unina.it>

    HID: hidraw, fix a NULL pointer dereference in hidraw_write

commit d20d5ffab92f00188f360c44c791a5ffb988247c
Author: Antonio Ospite <ospite@studenti.unina.it>

    HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl

commit 164b796414158eee515a53340456085e0192ea7e
Author: Andy Whitcroft <apw@canonical.com>

    intel_ips -- ensure we do not enable gpu turbo mode without driver link=
age

commit e7480bbb926c5816e4fbfca70748096bbe0e4978
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: fix channel assumption for association done work

commit f209f5298217cf54cd5a9163e18b08d093faf8d9
Author: Felix Fietkau <nbd@openwrt.org>

    ath9k: fix channel flag / regd issues with multiple cards

commit 2234362c427e2ef667595b9b81c0125003ac5607
Author: Johannes Berg <johannes.berg@intel.com>

    cfg80211: fix locking

commit 2a0ee388c38acf30b8b8f38626de56b92feeeef8
Author: Corentin Chary <corentincj@iksaif.net>

    asus-laptop: fix gps rfkill

commit 3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
Author: Andreas Herrmann <andreas.herrmann3@amd.com>

    x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future AMD =
CPUs

commit f3d531b99fb30945b4a64d6e2e86e1e62605aca5
Author: Tilman Schmidt <tilman@imap.cc>

    isdn/gigaset: correct bas_gigaset rx buffer handling

commit c8701a08d6a4efeae45d84d0aa87172f23b14e3c
Author: Tilman Schmidt <tilman@imap.cc>

    isdn/gigaset: fix bas_gigaset AT read error handling

commit b33ffa5cbf52ee751bb8068218ebb3c742c5a515
Author: Tilman Schmidt <tilman@imap.cc>

    isdn/gigaset: bas_gigaset locking fix

commit 96d6d3b503aaaa50ea07e7384c1a886599654ab6
Author: Mark Brown <broonie@opensource.wolfsonmicro.com>

    mfd: Ignore non-GPIO IRQs when setting wm831x IRQ types

commit 8d4780eb1ece4e8109b4f6b2e5e61f7fc593c3f4
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: fix offchannel assumption upon association

commit 9094537c3a9ef9e127e844254a74186735c9a90b
Author: Vasanthakumar Thiagarajan <vasanth@atheros.com>

    ath9k: Fix tx struck state with paprd

commit efd4f6398dc92b5bf392670df862f42a19f34cf2
Author: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

    viafb: use proper register for colour when doing fill ops

commit 85c5702ac046b14713f776d59768252d8ed8018f
Author: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

    viafb: fix i2c_transfer error handling

commit 6554287b1de0448f1e02e200d02b43914e997d15
Author: Bart Oldeman <bartoldeman@gmail.com>

    x86, vm86: Fix preemption bug for int1 debug and int3 breakpoint handle=
rs.

commit 9f5f9ffe50e90ed73040d2100db8bfc341cee352
Author: Paul Mackerras <paulus@samba.org>

    powerpc/perf: Fix sampling enable for PPC970

commit 584c5b7cf06194464240280483ee0376cdddbbae
Author: Max Vozeler <mvz@vozeler.com>

    staging: usbip: Process event flags without delay

commit 0c9a32f0192e656daa2ff3c9149f6d71b4a1b873
Author: Max Vozeler <mvz@vozeler.com>

    staging: usbip: Notify usb core of port status changes

commit 90fa539ca3f07323da5a90f5c8f4e5cd952875e7
Author: Felix Fietkau <nbd@openwrt.org>

    ath9k: clean up / fix aggregation session flush

commit 231c3a1f0630c07a584905507a1cb7b705a56ab7
Author: Felix Fietkau <nbd@openwrt.org>

    ath9k: fix an aggregation start related race condition

commit 008443def34db1dcc8016763587a288254ea5735
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    ath9k: fix regression which disabled ps on ath9k

commit 3fac6dfdcd2b893c22b20a03dd1bf1af8b627c4b
Author: Senthil Balasubramanian <senthilkumar@atheros.com>

    ath9k: fix regression which prevents chip sleep after CAB data

commit f01a067d9e4598c71e3c9ee3a84859d2e8af4f8e
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: send last 3/5 probe requests as unicast

commit 3bc3c0d748402e8c1f31b8569f5924d25d7b8e30
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: disable beacon monitor while going offchannel

commit d3a910a8e4e846b9a767d35483f4dc7c6de7af82
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: make the beacon monitor available externally

commit 4730d5977f3e12b828d354f7752cffd94bdf39e5
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: reset connection idle when going offchannel

commit 0c699c3a75d4e8d0d2c317f83048d8fd3ffe692a
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: reset probe send counter upon connection timer reset

commit be099e82e9cf6d5d65d044e9ef6fc8bee3c7a113
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    mac80211: add helper for reseting the connection monitor

commit 48a6a468198aadb54bc5d3fdd065364d43ff5197
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    ath9k: fix enabling ANI / tx monitor after bg scan

commit 52b8ac92496e03d6b5619204d7f3bae6ce6eae45
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    ath9k: fix regression on beacon loss after bgscan

commit 8ab2cd09fecc8819bbaee2d0fd8f3a092d866ce3
Author: Luis R. Rodriguez <lrodriguez@atheros.com>

    ath9k: fix power save race conditions

commit f5521b13880f4f4f612e1d20dd4f565122d16e04
Author: Johannes Berg <johannes.berg@intel.com>

    mac80211: use correct station flags lock

commit 01ea50638bc04ca5259f5711fcdedefcdde1cf43
Author: Signed-off-by: Jan Kara <jack@suse.cz>

    block: Fix race during disk initialization

commit 16d3ea26f82271fef9b1c4523b5e1ea31fa39eec
Author: Martin K. Petersen <martin.petersen@oracle.com>

    [SCSI] Fix VPD inquiry page wrapper

commit 3ae74c33c4f799f6bf6d67240a94a0814a8f1944
Author: Felix Fietkau <nbd@openwrt.org>

    ath9k_hw: handle rx key miss

commit dcb3c5d5d217ee3151917b5947a63f71e7b11bb4
Author: Joerg Roedel <joerg.roedel@amd.com>

    KVM: X86: Report SVM bit to userspace only when supported

commit 1e40975bb8f03de2d96f189863ec96e6a15d856e
Author: Joerg Roedel <joerg.roedel@amd.com>

    KVM: SVM: Restore correct registers after sel_cr0 intercept emulation

commit 7ef8aa72ab176e0288f363d1247079732c5d5792
Author: Andre Przywara <andre.przywara@amd.com>

    x86, cpu: Fix renamed, not-yet-shipping AMD CPUID feature bit

commit 19966754328d99ee003ddfc7a8c31ceb115483ac
Author: Daniel Vetter <daniel.vetter@ffwll.ch>

    drm/i915: die, i915_probe_agp, die

commit e5e408fc94595aab897f613b6f4e2f5b36870a6f
Author: Daniel Vetter <daniel.vetter@ffwll.ch>

    intel-gtt: fix gtt_total_entries detection

commit 0ddc1289f3ffd779779ddd3922f26ae7d0a21604
Author: Chris Wilson <chris@chris-wilson.co.uk>

    drm/i915/overlay: Ensure that the reg_bo is in the GTT prior to writing.

commit c45c3472a9acd7c63464e7b72a716b62cb38c6db
Author: Mimi Zohar <zohar@linux.vnet.ibm.com>

    ima: always maintain counters

commit 56363ddeeed3afc5277ca227209773bc1042cc7b
Author: Felix Fietkau <nbd@openwrt.org>

    ath9k: fix spurious MIC failure reports

commit 3ba06c6fbd651ed3377e584026d1c112b492cc8b
Author: Jouni Malinen <j@w1.fi>

    mac80211: Fix signal strength average initialization for CQM events

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__10_Oct_2010_10_38_10_+1100_IclCjblVAgdyS=h9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMsPziAAoJEDMEi1NhKgbsawUIAI3axhP/EYfchpki+aQ5j1cC
upZFonlrxuDJjEIGWySgxIutnOiY+Hb+9gXmRH++ul7Pn5SKygG1P1cjyC+HFPFj
B3UhzC/ag+UC/vdFczSSjcWjraCKWYVcEgQQunNpRh5A9aoThlUkk/GGfmRdQmuS
Du73E+GrPnv5i8Zx/wsiDUNKRkEp87FUpigyB6ndhX1N5zDQp4IliF6I5v0iB4QJ
o0Tr5/CWrmNvFbB7biMM8U1fjl5k8Psz8WjpI12XAbWFhNPm3H8fcH4ZAJFGb7ED
HHwL/eVO68oOV4L8Yqjjww6XnlNKcxMLjWBixysGQ0zU2knwefKClpWD/+wL+U8=
=OTOZ
-----END PGP SIGNATURE-----

--Signature=_Sun__10_Oct_2010_10_38_10_+1100_IclCjblVAgdyS=h9--
