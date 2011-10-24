Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab1JXNng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:43:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46853 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab1JXNnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:43:35 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 24 Oct 2011 15:43:13 +0200
X-Google-Sender-Auth: OW_nViPqG5yh3YmQfoJsP3fI3qQ
Message-ID: <CA+55aFwZdrR+Ynhgx87HDF-hvaD3NL9EYAdx1A7shrQOjMLA0g@mail.gmail.com>
Subject: Linux 3.1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As promised, the kernel summit has started, and Linux-3.1 is out. The
(small) shortlog of changes since -rc10 are appended, we have mostly
some sparc and networking changes, along with some radeon and intel
iommu fixes (mostly for largepages and integrated graphics issues).
Most people probably will not notice the changes.

One big change from -rc10 is that there are tar-balls and patches, so
if you aren't a git user (why?) you can download it now in a
traditional format. On of the things to note is that the files are now
signed by my gpg key, and it's the *uncompressed* version that the
signature is for.

And of course, this means that the merge window for 3.2 is open. I'll
do some merging during the KS, but probably most when I get back home
- but you can still send me the pull request, even if I may not
necessarily pull it for a few days.

NOTE! Because the -rc series was longer than usual, and as a result
linux-next is bigger than usual, I'm going to be much more of a
stickler for "has your patch series been in linux-next" than usual. If
I get a big pull request for things that I can't find in my linux-next
branch, I will simply not pull it - we have enough code that has gone
through the proper channels as it is, and we don't need anything
extra.

Another thing worth mentioning is that I really want the pull request
to be validated some way. With the small changes late in the -rc
series, I could afford to spend the time to look at commits and try to
verify them, but with the merge window (and the 11k commits or so that
I saw pending in the last linux-next tree), that just isn't
reasonable.

So use git.kernel.org or some other host that I can trust is really you.

Have fun,

                       Linus

---

Alasdair G Kergon (1):
      dm kcopyd: fix job_pool leak

Alex Deucher (4):
      drm/radeon/kms/DCE4.1: fix dig encoder to transmitter mapping
      drm/radeon/kms/DCE4.1: ss is not supported on the internal pplls
      drm/radeon/kms/DCE4.1: fix Select_CrtcSource EncodeMode setting
for DP bridges (v2)
      drm/radeon/kms/atom: fix handling of FB scratch indices

Allen Kay (3):
      intel-iommu: fix return value of iommu_unmap() API
      intel-iommu: set iommu_superpage on VM domains to lowest common
denominator
      intel-iommu: fix superpage support in pfn_to_dma_pte()

Antonio Ospite (1):
      [media] videodev: fix a NULL pointer dereference in v4l2_device_release()

Daniel Hellstrom (1):
      sparc32,leon: SRMMU MMU Table probe fix

Daniel Suchy (1):
      ALSA: HDA: conexant support for Lenovo T520/W520

David S. Miller (1):
      sparc: Avoid calling sigprocmask()

David Woodhouse (2):
      intel-iommu: Workaround IOTLB hang on Ironlake GPU
      intel-iommu: Export a flag indicating that the IOMMU is used for iGFX.

Domenico Andreoli (1):
      ARM: S3C24XX: Fix s3c24xx build errors if !CONFIG_PM

Eric Dumazet (3):
      l2tp: fix a potential skb leak in l2tp_xmit_skb()
      pptp: fix skb leak in pptp_xmit()
      pptp: pptp_rcv_core() misses pskb_may_pull() call

Florian Westphal (1):
      netfilter: nf_conntrack: fix event flooding in GRE protocol tracker

Gao feng (1):
      netconsole: enable netconsole can make net_device refcnt incorrent

Gerrit Renker (1):
      udplite: fast-path computation of checksum coverage

Hans Schillstrom (1):
      IPVS netns shutdown/startup dead-lock

Hugh Dickins (1):
      mm: fix race between mremap and removing migration entry

Jean Delvare (1):
      hwmon: (w83627ehf) Fix negative 8-bit temperature values

Jiri Pirko (1):
      tg3: negate USE_PHYLIB flag check

KOVACS Krisztian (1):
      tproxy: copy transparent flag when creating a time wait

Kjetil Oftedal (1):
      sparc: Add alignment flag to PCI expansion resources

Linus Torvalds (1):
      Linux 3.1

Marek Szyprowski (1):
      ARM: S5P: fix offset calculation on gpio-interrupt

Matt Fleming (1):
      sparc: Use set_current_blocked()

Matthew Daley (3):
      x25: Validate incoming call user data lengths
      x25: Handle undersized/fragmented skbs
      x25: Prevent skb overreads when checking call user data

Mitsuo Hayasaka (1):
      bonding: use local function pointer of bond->recv_probe in
bond_handle_frame

Nick Bowler (1):
      crypto: ghash - Avoid null pointer dereference if no key is set

Paul Moore (1):
      bluetooth: Properly clone LSM attributes to newly created child
connections

Peter Zijlstra (1):
      cputimer: Cure lock inversion

Phil Edworthy (1):
      smsc911x: Add support for SMSC LAN89218

Roland Dreier (2):
      intel-iommu: Fix AB-BA lockdep report
      MAINTAINERS: Update VT-d entry for drivers/pci -> drivers/iommu move

Takashi Iwai (2):
      ALSA: hda - Add position_fix quirk for Dell Inspiron 1010
      x86: Fix S4 regression

Thadeu Lima de Souza Cascardo (1):
      ehea: Change maintainer to me

Thomas Hellstrom (1):
      ttm: Fix error-path using an uninitialized value

Yan, Zheng (1):
      fib_rules: fix unresolved_rules counting

françois romieu (1):
      r8169: fix driver shutdown WoL regression.

hayeswang (1):
      r8169: fix wrong eee setting for rlt8111evl

stephen hemminger (1):
      bridge: fix hang on removal of bridge via netlink
