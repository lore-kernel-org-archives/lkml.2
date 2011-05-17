Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab1EQM1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:27:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40684 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab1EQM1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:27:30 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Shiang Tu <shiang_tu@ralinktech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1305635052.19966.142.camel@localhost>
References: <1305635052.19966.142.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 May 2011 13:27:24 +0100
Message-ID: <1305635244.19966.145.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH firmware 3/3] rt2870sta: Use latest firmware for RT3070 and
 RT3071
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ralink's original drivers for RT2800U-family chips used multiple
different versions of the firmware for different chips.  The rt2870sta
driver in staging was briefly converted to load different files for
different chips.  However, the current rt2870.bin provides 2 images
that are supposed to cover all of them, so:

- Replace rt3070.bin with a symlink.  The driver will use the first
  image and ignore the second.
- Replace rt3071.bin with a copy of the second image in the current
  rt2870.bin.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 WHENCE     |   12 +++++++++++-
 rt3070.bin |  Bin 4096 -> 10 bytes
 rt3071.bin |  Bin 4096 -> 4096 bytes
 3 files changed, 11 insertions(+), 1 deletions(-)
 mode change 100644 => 120000 rt3070.bin

diff --git a/WHENCE b/WHENCE
index e28b0cc..f005c0f 100644
--- a/WHENCE
+++ b/WHENCE
@@ -1120,12 +1120,22 @@ This is a link to rt2860.bin for compatibility.
 Driver: rt2800usb - Ralink RT2870, RT3070, RT3071, RT3072, RT5370 wireless MACs
 
 File: rt2870.bin
+
+Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
+
+Binary file supplied by Shiang Tu <shiang_tu@ralinktech.com>. Firmware Version 29
+
+--------------------------------------------------------------------------
+
+Driver: rt2870sta - Ralink RT2870, RT3070, RT3071 wireless MACs
+
 File: rt3070.bin
 File: rt3071.bin
 
 Licence: Redistributable. See LICENCE.ralink-firmware.txt for details
 
-Binary file supplied by Shiang Tu <shiang_tu@ralinktech.com>. Firmware Version 29
+rt3070.bin is a link to rt2870.bin for compatibility.
+rt3071.bin is a copy of bytes 4096-8191 of rt2870.bin for compatibility.
 
 --------------------------------------------------------------------------
 
diff --git a/rt3070.bin b/rt3070.bin
deleted file mode 100644
index cd49e9601489592323d63bfe309dc8c0d18564b7..0000000000000000000000000000000000000000
GIT binary patch
literal 0
HcmV?d00001

literal 4096
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

diff --git a/rt3070.bin b/rt3070.bin
new file mode 120000
index 0000000..d233a1d
--- /dev/null
+++ b/rt3070.bin
@@ -0,0 +1 @@
+rt2870.bin
\ No newline at end of file
diff --git a/rt3071.bin b/rt3071.bin
index 6db66b3bc3ba367bee086e09adf314982abba71d..b1f44e0207aef4728ec0d401a499512f048a0b7b 100644
GIT binary patch
delta 1625
zcmb7EU2GIp6yCWrv)%s5?Cj52wm<8pEv3co&=!fYT@kkyp@z~9J1Z?_Vj5qJ$$+~w
zC^F+#UW|#i9Ryws*o}!Xnm$P6!5EXp7$1xpjETNo=w2U4v^Ua8j7rxtyMU!n`f|^A
zzx$n^d*;lw<90k%sZ@~EgQNi@y@n!#C^Cei9E$qoC`zE%KGgamQr<z)?^V$sZ|3E;
zi3H}}BI-(<W>q3BJUaGtWB{8oaWhyDh}`h0baSWl?IXd^L~#G1;M8PrYAQIT1<xK1
zu4LpVX62Vm`NA>ztK*?lFNfaCg)i9Q&v2M6_<WIph0hf+GJqm|3qQBt0e=^2z?tXf
zMB!T4?snF>?yWSlX7Z@2#im5u-uwukPj!^t<RTvl+&yx-Q1>183ABBtCYOA~)yr<y
zeHKeRx!fb>vz$F##VTNAt5rM*Sg<>*cvlma5V?FDsDK@;Q4Lkf;qzGu8gbn@j~*U2
zhjKevG1tvX(Xu<^9&x9!sj?z-drJxy!a19ju^D2Uitnr}I_297*Q3_G0<pA%VJVs0
z!>}17n&s+5v#~h<TZvSt{=>yRd$Bo4^%?<?0CkL1Ktm2<(Z^_3+hPcoVk0YvMQ#<!
z;#iJn6}kC4PabCWmzyG7wJuI1|3?U+8UpJ1Z%Lu=cduo!^6lk}-1y;!rX;ZG{DIo7
zleXzy5}FeA?(WWftZ$G)Kj{%xq|>ZiYj3riM%sSN6N8gd9fza$IjKqr|C^m?%+*Ja
z-uo0r9X7j2nq!FsO^sS3MgvVnQf5PB#P-*w3g{67rtJpp^(N~^?owCMEtH4G-FafX
zVx5+wS5~$4G`j7<cWKh{b&>VePM=%IJ(F54;PDSwaTN;AxVmM57zpxbk#y;9;pVQ4
zJHN_Ao$4kMGgr^<uxaKjx96u?)HGj<xglejiAkEg9N=Nroj9*sYSbt#V@ZIi#;AvA
zqN~%HS<ZZj>cFbRPqe?7Es(UpsIK1FDNfUAvrjx?Z-Xs~(HT&g8${LfMmVqYf`Zqz
z<ph>mfA#KA%r(GVwh}jsrFIg(ek*~;r8bXmyq{mrCQ1iN<1`KLLG*W@VhhTtfHET~
z{<zX@D7!EDd`jWWz9-M@-+N~KIXX7$hXyMJ=Og}oF&2`QD^5mmol|1Wc|nXiKY~3k
zrkn#{nHWm9kl6tvymV}FZpmCcLHk1??QyriG<WTUsx(jaGul6T6n-CO`(dT9hxq20
z*By0?uh?j<^7b~T)35G`HPdZt6$EB%w$9iBYrv?7wH~V3`syZ!<NnhfRb^9E(+HZF
zyh*d}FQL|hPN}ZTilw~%X}4JZ5C<HcF#Y-Gc|ch95sf!xD=vcuEfMVt(4d+I1p6^6
z67?5APhnv<nN64{G52QfG{f9EhGoI~2B98;&8=X!gN=dh1DmMw8e>J6aqqB?Xy3p~
zpss}I@EQ*F8Y0wV2c6dgqo}Rb`8v>%YHOvFVWUZa%e1xRC%OD#9t#{vKj6I}4;t-|
rg+MlVXJTNt!<QBTCjj>`h_oJP;nkI>(@{SN5kJxDe?xrR8>N2$&U}#)

delta 653
zcmXYt!A}!G6vlVoPRlN|usgG`)P`kk1hENPHE2i#O~pWj17JZ&j4lR`BrCKLi7AbS
zi}5gI)DSNkt4B!;gqvvi12~`_^x`DA9z5tqs22})3LNHp-@NzxCX-ii3QlLaTn4=j
z^i!bE0%-=~067n&2a^j4u$G~53(PJcv#C(ni7GhuBthjzJhdHP?C$L%HuW$sjZ%a-
zu3po>oYdc)F<{W>95T|wM*518&KM6yjIB}J;^D#DI6sX)&)~lWNh0>*rWGPK5Nq+L
zy>D1lzJK5z%Xg5nWhR&ot#X1*LF>U_369x&DXL4nbd~DBOJhY|8u!OmJ=-5&O|d4W
zosB^hx&4JSyQefEH(5B$mXO1ep&GUw8tq7I^luFKJ>tvcnPj#h^N4C9oh&<K(<R?t
zNRpXc=)1UZIlVA&-S3?Yy9$^|hN@nNth?B}!IrB^tX+$<b+v&N)j0dDcC$~S_GyH<
zT787-C;a0<CFymt=UU3PX8fbOWe}xzvdXO!s=As`O}yOjhyBy?wR^LO8y4LfZ;mZh
zZ$RT3yH?XOZ@r>A;+dTwHzbRmKj?*XHx=P1mUu?-@VtWs121{zy<lLU5x`ptMV|U0
z+#8C{^2vlZN9Bjvd_d)=0mUd=9f++>*Nd%n=-+8b3W`}(9687;!Mu#4eU!BEcqRyn
zTu22o{d2o+SX_4sCM8LBC~^s66Ko>VY{e%0Vbj%+H<cTfb0Z2xGViGk*m@+Uu1+^p
b(gyn)IW72=y67)h`4H`@NM2TqTOa=egDlvf

-- 
1.7.5.1


