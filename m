Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab1IBUa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:30:28 -0400
Received: from nn7.de ([85.214.94.156]:40914 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755292Ab1IBUaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:30:25 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Sep 2011 16:30:25 EDT
Subject: WARNING: at drivers/gpu/drm/i915/i915_irq.c:649
 ironlake_irq_handler+0x709/0x720()
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HXg1jB1uVYttnNbdV/dU"
Date: Fri, 02 Sep 2011 22:23:43 +0200
Message-ID: <1314995023.21712.10.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HXg1jB1uVYttnNbdV/dU
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Dear all,

I just saw this in my dmesg (kernel 3.0.3) on a DH67BLB3 mainboard (no
addon cards or anything attached):

WARNING: at drivers/gpu/drm/i915/i915_irq.c:649 ironlake_irq_handler+0x709/=
0x720()
Hardware name:        =20
Missed a PM interrupt
Modules linked in:
Pid: 0, comm: swapper Not tainted 3.0.3 #4
Call Trace:
 <IRQ>  [<ffffffff8108286b>] ? warn_slowpath_common+0x7b/0xc0
 [<ffffffff81082965>] ? warn_slowpath_fmt+0x45/0x50
 [<ffffffff8144dde9>] ? ironlake_irq_handler+0x709/0x720
 [<ffffffff8134c175>] ? blk_done_softirq+0x75/0x90
 [<ffffffff810cb13a>] ? handle_irq_event_percpu+0x3a/0x140
 [<ffffffff81040865>] ? read_tsc+0x5/0x20
 [<ffffffff810cb273>] ? handle_irq_event+0x33/0x60
 [<ffffffff810cd75d>] ? handle_edge_irq+0x5d/0x110
 [<ffffffff8103ba35>] ? handle_irq+0x15/0x20
 [<ffffffff8103b1e3>] ? do_IRQ+0x53/0xd0
 [<ffffffff81664c13>] ? common_interrupt+0x13/0x13
 <EOI>  [<ffffffff813b87b7>] ? intel_idle+0xb7/0x120
 [<ffffffff813b879a>] ? intel_idle+0x9a/0x120
 [<ffffffff8158e541>] ? cpuidle_idle_call+0x81/0x100
 [<ffffffff81038fee>] ? cpu_idle+0x5e/0xb0
 [<ffffffff81915cd6>] ? start_kernel+0x438/0x443
 [<ffffffff81915443>] ? x86_64_start_kernel+0x104/0x113


$ cat /proc/cpuinfo | grep Core | sort -u
model name	: Intel(R) Core(TM) i7-2600K CPU @ 3.40GHz

$ lspci
00:00.0 Host bridge: Intel Corporation Sandy Bridge DRAM Controller (rev 09=
)
00:02.0 VGA compatible controller: Intel Corporation Sandy Bridge Integrate=
d Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation Cougar Point HECI Contr=
oller #1 (rev 04)
00:19.0 Ethernet controller: Intel Corporation 82579V Gigabit Network Conne=
ction (rev 05)
00:1a.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host Co=
ntroller #2 (rev 05)
00:1c.0 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 1 =
(rev b5)
00:1c.3 PCI bridge: Intel Corporation Cougar Point PCI Express Root Port 4 =
(rev b5)
00:1d.0 USB Controller: Intel Corporation Cougar Point USB Enhanced Host Co=
ntroller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation Cougar Point LPC Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation Cougar Point 6 port SATA AHCI Co=
ntroller (rev 05)
00:1f.3 SMBus: Intel Corporation Cougar Point SMBus Controller (rev 05)
01:00.0 PCI bridge: Integrated Technology Express, Inc. Device 8892 (rev 10=
)
03:00.0 USB Controller: NEC Corporation uPD720200 USB 3.0 Host Controller (=
rev 04)

$ cat /proc/interrupts=20
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5     =
  CPU6       CPU7      =20
  0:       2459          0          0          0          0          0     =
     0          0   IO-APIC-edge      timer
  1:          2          0          0          0          0          0     =
     0          0   IO-APIC-edge      i8042
  8:          1          0          0          0          0          0     =
     0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0          0          0     =
     0          0   IO-APIC-fasteoi   acpi
 12:          3          0          0          0          0          0     =
     0          0   IO-APIC-edge      i8042
 16: 1175258852          0          0          0          0          0     =
     0          0   IO-APIC-fasteoi   ehci_hcd:usb1
 23:         30          0          0          0          0          0     =
     0          0   IO-APIC-fasteoi   ehci_hcd:usb2
 40:          0          0          0          0          0          0     =
     0          0   PCI-MSI-edge      PCIe PME
 41:          0          0          0          0          0          0     =
     0          0   PCI-MSI-edge      PCIe PME
 42:    5992215          0          0          0          0          0     =
     0          0   PCI-MSI-edge      i915
 43:   95318489          0          0          0          0          0     =
     0          0   PCI-MSI-edge      ahci
 44:   14074153          0          0          0          0          0     =
     0          0   PCI-MSI-edge      eth0
NMI:          0          0          0          0          0          0     =
     0          0   Non-maskable interrupts
LOC: 1164594470  180433546  174024393  165733517  251730525  142586007  140=
662100  144705720   Local timer interrupts
SPU:          0          0          0          0          0          0     =
     0          0   Spurious interrupts
PMI:          0          0          0          0          0          0     =
     0          0   Performance monitoring interrupts
IWI:          0          0          0          0          0          0     =
     0          0   IRQ work interrupts
RES:   10976738   14449620   12484512   10296658   64938540   10026255    8=
551007    7452717   Rescheduling interrupts
CAL:    6753507    4549505    4174293    4569450    6989000    7046680    7=
443517    8433381   Function call interrupts
TLB:    1582967    1484471    1421638    1417115    2112721    1981530    2=
063581    1874732   TLB shootdowns
TRM:          0          0          0          0          0          0     =
     0          0   Thermal event interrupts
THR:          0          0          0          0          0          0     =
     0          0   Threshold APIC interrupts
MCE:          0          0          0          0          0          0     =
     0          0   Machine check exceptions
MCP:       2336       2336       2336       2336       2336       2336     =
  2336       2336   Machine check polls
ERR:          0
MIS:          0

--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-HXg1jB1uVYttnNbdV/dU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJOYTs/AAoJEH82z1Wqh6p37foQAK1KX3Yvus0fOQVA8CT5ge4u
xHCULZUsMQidqmoMIEeLWsCfQFHTuzmwqfAUpLysMhy9iPljH9fyW5Z4bIsa05Jw
sCqZfj+OkGgugsg58uB9wk59r6KhKB82Q4iq4bI1DIKvlvHFhvhrk9Xe2Ne2G0bk
BiLgfEv+YFUPT03JRwLIZ7Wq2BaL1vjTZYrctOkx0H5f5WSCTGxrAU6XNcwhDUEq
txkxZJLBXvZRWUPpAmxVesbkj6eMzi9qIy5gtm1HOjrrGfOhmttFTJJcq4iliNqu
2sqd/zIR6/lB4760ou6uMXZ8qfJnvQZUEIEpRkc2DfjIl2uz3fjb9bvP/7plhLvq
siQwWR/LdFdi73v3+pwWZu2p2hfql3MEco9unVVtED5pxjuWnKhz8tOfUAvpL8F6
1YYNkWsfz+zWUGsqozUK+DUxLr9Lmc2Ixe8i4RBfeA/H7FvLVAAO4AodWbMROUVC
M4rLYDT9P8Ww6PIOllvMVKp8XZur7ocRKdbffoi4LCkxM2Od9CyuzsOyR6NGxXtX
e8Jp8gpbsMgrul6pvg6ofNRH7LHNTWnNYye/TjhnMCldUG0bXBIdc7HeTVxrMvXz
oOwYViSblAq2LD0O06+sMrnl8IuepD1c8xx7s4JamJj9KxaIWTLh0RE862q7I3O1
jfMXgZxcCvJI5bqDVqSz
=8vx2
-----END PGP SIGNATURE-----

--=-HXg1jB1uVYttnNbdV/dU--
