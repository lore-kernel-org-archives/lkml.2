Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2IQOYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:24:25 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:59571
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575Ab2IQOYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:24:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VPS-7(zz98dI9371Ic85fh542M1432Id6f1izz1202h1d1ah1d2ahzz8275dhz2dh668h839hd25hf0ah107ah1288h12a5h12bdh34h1155h)
X-WSS-ID: 0MAI009-02-9QP-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Andres Freund <andres@anarazel.de>
CC: LKML <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: RE: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Topic: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
 allocate a PPLL
Thread-Index: AQHNlMf4cJj+N2GqCk+osvT7J0ZY3JeOgYkggABg+QD//7NwcA==
Date: Mon, 17 Sep 2012 14:24:08 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02C4333B6@sausexdag03.amd.com>
References: <201209171329.15699.andres@anarazel.de>
 <A3397C8B8B789E45844E7EC5DEAD89D02C433367@sausexdag03.amd.com>
 <201209171555.43008.andres@anarazel.de>
In-Reply-To: <201209171555.43008.andres@anarazel.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.224.12.207]
Content-Type: multipart/mixed;
	boundary="_002_A3397C8B8B789E45844E7EC5DEAD89D02C4333B6sausexdag03amdc_"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_A3397C8B8B789E45844E7EC5DEAD89D02C4333B6sausexdag03amdc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> -----Original Message-----
> From: Andres Freund [mailto:andres@anarazel.de]
> Sent: Monday, September 17, 2012 9:56 AM
> To: Deucher, Alexander
> Cc: LKML; David Airlie; dri-devel@lists.freedesktop.org
> Subject: Re: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to
> allocate a PPLL
>=20
> On Monday, September 17, 2012 03:16:56 PM Deucher, Alexander wrote:
> > > -----Original Message-----
> > > From: Andres Freund [mailto:andres@anarazel.de]
> > > Sent: Monday, September 17, 2012 7:29 AM
> > > To: LKML; Deucher, Alexander; David Airlie;
> > > dri-devel@lists.freedesktop.org Subject: radeon: Regression between
> > > v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
> > >
> > > Hi,
> > >
> > > While debugging another issue I upgraded from v3.6-rc4 to latest git
> > > (which exactly is v3.6-rc6). After X started up one of my three monit=
ors
> > > blacked out. A look into the kernel log revealed:
> > > [drm:radeon_atom_pick_pll] *ERROR* unable to allocate a PPLL
> >
> > What 3 monitors are you using (DVI, HDMI, DP, VGA)? Note that there are
> > only 2 PLLs for non-DP monitors, so if you are trying to use more than =
2
> > non-DP monitors, it's not supported right now and if it worked before, =
it
> > was random luck.  If you want to use 3+ monitors, only 2 can be non-DP,
> > the rest need to be DP.  If you use a DP to DVI/HDMI adapter, it must b=
e
> > active (looks like DP to the GPU), passive adapters just pass through
> > native DVI/HDMI.  That said, I've got a set of patches for 3.7 to allow
> > PLL sharing properly for non-DP displays, but it's too invasive for
> > -fixes.
> 2DVI, 1DP via an supposedly active converter. I can try a native DP cable=
, its
> just too short, so I will have to move the monitor to the ground ;)
>=20
> Can I check its really an active connector?

Try the attached debugging patch.  It will tell us what PPLLs are getting a=
llocated and what type of sink we detect on the DP port (DP or non-DP)

>=20
> The patchset you referenced is in alexdeucher/drm-next-3.7-wip if I saw t=
hat
> correctly? Will test it with a passive connector I have lying arround.
>=20

Yes.  Note that PLLs can only be shared for non-DP monitors if the clocks a=
re the same.

Alex


--_002_A3397C8B8B789E45844E7EC5DEAD89D02C4333B6sausexdag03amdc_
Content-Type: application/octet-stream; name="debug_dp.diff"
Content-Description: debug_dp.diff
Content-Disposition: attachment; filename="debug_dp.diff"; size=1228;
	creation-date="Mon, 17 Sep 2012 14:21:23 GMT";
	modification-date="Mon, 17 Sep 2012 14:20:15 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jIGIvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKaW5kZXggZTcyMWUzMC4uZDI4N2Qx
OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKKysr
IGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKQEAgLTE3MzUsNiArMTcz
NSw4IEBAIHN0YXRpYyB2b2lkIGF0b21iaW9zX2NydGNfcHJlcGFyZShzdHJ1Y3QgZHJtX2NydGMg
KmNydGMpCiAJcmFkZW9uX2NydGMtPmluX21vZGVfc2V0ID0gdHJ1ZTsKIAkvKiBwaWNrIHBsbCAq
LwogCXJhZGVvbl9jcnRjLT5wbGxfaWQgPSByYWRlb25fYXRvbV9waWNrX3BsbChjcnRjKTsKKwlE
Uk1fSU5GTygiY3J0YyAlZCB1c2luZyBwbGwgMHgleFxuIiwKKwkJIHJhZGVvbl9jcnRjLT5jcnRj
X2lkLCByYWRlb25fY3J0Yy0+cGxsX2lkKTsKIAogCS8qIGRpc2FibGUgY3J0YyBwYWlyIHBvd2Vy
IGdhdGluZyBiZWZvcmUgcHJvZ3JhbW1pbmcgKi8KIAlpZiAoQVNJQ19JU19EQ0U2KHJkZXYpKQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY29ubmVjdG9ycy5jIGIv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY29ubmVjdG9ycy5jCmluZGV4IDg5NWU2Mjgu
LjQxZmUyZTUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Nvbm5l
Y3RvcnMuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9jb25uZWN0b3JzLmMK
QEAgLTE0MDAsNiArMTQwMCw3IEBAIHJhZGVvbl9kcF9kZXRlY3Qoc3RydWN0IGRybV9jb25uZWN0
b3IgKmNvbm5lY3RvciwgYm9vbCBmb3JjZSkKIAkJfQogCX0gZWxzZSB7CiAJCXJhZGVvbl9kaWdf
Y29ubmVjdG9yLT5kcF9zaW5rX3R5cGUgPSByYWRlb25fZHBfZ2V0c2lua3R5cGUocmFkZW9uX2Nv
bm5lY3Rvcik7CisJCURSTV9JTkZPKCJEUCBzaW5rIHR5cGUgMHgleFxuIiwgcmFkZW9uX2RpZ19j
b25uZWN0b3ItPmRwX3NpbmtfdHlwZSk7CiAJCWlmIChyYWRlb25faHBkX3NlbnNlKHJkZXYsIHJh
ZGVvbl9jb25uZWN0b3ItPmhwZC5ocGQpKSB7CiAJCQlyZXQgPSBjb25uZWN0b3Jfc3RhdHVzX2Nv
bm5lY3RlZDsKIAkJCWlmIChyYWRlb25fZGlnX2Nvbm5lY3Rvci0+ZHBfc2lua190eXBlID09IENP
Tk5FQ1RPUl9PQkpFQ1RfSURfRElTUExBWVBPUlQpCg==

--_002_A3397C8B8B789E45844E7EC5DEAD89D02C4333B6sausexdag03amdc_--
