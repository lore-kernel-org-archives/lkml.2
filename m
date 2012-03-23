Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030377Ab2CWTmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 15:42:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51382 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab2CWTmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 15:42:44 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_NAOOsp6-NrnNc3cSTGM=yNXk8yddBPSxFawuONeAu-_Q@mail.gmail.com>
References: <20120322124919.GG28523@wantstofly.org>
	<CADnq5_O5NFmjG7OJoB=uTjt54Ay2BiyUT0oz0ZR2Pi0GuY3XFA@mail.gmail.com>
	<20120323154446.GK28523@wantstofly.org>
	<CADnq5_NAOOsp6-NrnNc3cSTGM=yNXk8yddBPSxFawuONeAu-_Q@mail.gmail.com>
Date: Fri, 23 Mar 2012 15:42:44 -0400
Message-ID: <CADnq5_Mf4aMYcX07UfNVMDerna0rKeEVwT0mhNLerpUC58K2Yw@mail.gmail.com>
Subject: Re: radeon + DVI->mDP converter + mDP display blank screen issue
 since 3.0
From: Alex Deucher <alexdeucher@gmail.com>
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: multipart/mixed; boundary=e89a8f3ba2a373e9dc04bbee3a32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f3ba2a373e9dc04bbee3a32
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 23, 2012 at 3:34 PM, Alex Deucher <alexdeucher@gmail.com> wrote=
:
> On Fri, Mar 23, 2012 at 11:44 AM, Lennert Buytenhek
> <buytenh@wantstofly.org> wrote:
>> On Fri, Mar 23, 2012 at 10:59:27AM -0400, Alex Deucher wrote:
>>
>>> > Since Linux 3.0, a system with a Radeon HD 5450 (1002:68f9) connected
>>> > to a 27" Apple LED cinema display via an Atlona AT-DP400 Dual Link DV=
I
>>> > to Mini DisplayPort converter has started to stop giving screen
>>> > output on switching from text mode to graphical framebuffer during
>>> > system startup.
>>> >
>>> > I finally had some time to look at this, and it seems to have stopped
>>> > working after this commit:
>>> >
>>> > =A0 =A0 =A0 =A0commit df271bec805b42527d864777ed035fcbb42e76c0
>>> > =A0 =A0 =A0 =A0Author: Alex Deucher <alexdeucher@gmail.com>
>>> > =A0 =A0 =A0 =A0Date: =A0 Fri May 20 04:34:15 2011 -0400
>>> >
>>> > =A0 =A0 =A0 =A0 =A0 =A0drm/radeon/kms: properly handle bpc >8 in atom=
 command tables
>>> >
>>> > =A0 =A0 =A0 =A0 =A0 =A0Signed-off-by: Alex Deucher <alexdeucher@gmail=
.com>
>>> > =A0 =A0 =A0 =A0 =A0 =A0Signed-off-by: Dave Airlie <airlied@redhat.com=
>
>>> >
>>> > ...and with the patch below (i.e. reverting part of the commit above)
>>> > applied to 3.3 I get screen output again.
>>> >
>>> > Even though the monitor seems to have an 8 bit panel, it reports 10
>>> > bits per channel in its EDID:
>>> >
>>> > =A0 =A0 =A0 =A0[...]
>>> > =A0 =A0 =A0 =A0Manufacturer: APP Model 9226 Serial Number 41959462
>>> > =A0 =A0 =A0 =A0Made week 38 of 2010
>>> > =A0 =A0 =A0 =A0EDID version: 1.4
>>> > =A0 =A0 =A0 =A0Digital display
>>> > =A0 =A0 =A0 =A010 bits per primary color channel
>>> > =A0 =A0 =A0 =A0DisplayPort interface
>>> > =A0 =A0 =A0 =A0Maximum image size: 60 cm x 34 cm
>>> > =A0 =A0 =A0 =A0[...]
>>> >
>>> > The (active, dual link) DVI->mDP converter spec sheet says it support=
s
>>> > 24 bit color, and I'm guessing that it can't deal with 30. =A0Is the
>>> > converter at fault here for passing through the EDID unchanged?
>>> >
>>> > Also, what would be the right way to handle this, a kernel command
>>> > line or module option to limit color depth or something like that?
>>> > ("Buy a video card with DP output." is a valid answer, I suppose.)
>>> >
>>> > I have no clue at all about graphics, and I have no idea whatsoever
>>> > what I'm doing here, but I just wanted to post this somewhere for
>>> > Google to find in case someone else runs into this!
>>>
>>> I've inquired with out display team on how to best handle this. =A0In
>>> the meantime, it's probably best to just default to 8 bpc. =A0Does the
>>> attached patch fix your issue?
>>
>> I've been using the patch below in a custom Fedora 17 kernel RPM, and
>> that seems to fix the issue. =A0Your patch seems to be a superset of
>> this patch, so logically, your patch should do the trick as well. :)
>
> Can you try the attached patch on top of my previous one?

Scratch that.  Try this one instead.

Alex

>
> Alex
>
>>
>>
>> thanks,
>> Lennert
>>
>>
>> diff -up linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.=
c.orig linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c
>> --- linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c.ori=
g =A0 =A0 =A0 2012-03-22 14:52:20.538854547 +0100
>> +++ linux-3.3.0-1.fc17.x86_64/drivers/gpu/drm/radeon/atombios_crtc.c =A0=
 =A02012-03-22 14:55:39.740794113 +0100
>> @@ -550,8 +550,6 @@ static u32 atombios_adjust_pll(struct dr
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (encoder->crtc =3D=3D crtc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0radeon_encoder =3D to_rad=
eon_encoder(encoder);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0connector =3D radeon_get_=
connector_for_encoder(encoder);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (connector && connector=
->display_info.bpc)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D co=
nnector->display_info.bpc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0encoder_mode =3D atombios=
_get_encoder_mode(encoder);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0is_duallink =3D radeon_di=
g_monitor_is_duallink(encoder, mode->clock);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((radeon_encoder->devi=
ces & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
>> @@ -922,7 +920,6 @@ static void atombios_crtc_set_pll(struct
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct radeon_connector_atom_dig *dig_con=
nector =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0radeon_connector->con_pri=
v;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int dp_clock;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (encoder_mode) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case ATOM_ENCODER_MODE_DP_MST:
>>
>>
>>
>>> From 22ca454eb749968f266d6788a5f4778acc08cc66 Mon Sep 17 00:00:00 2001
>>> From: Alex Deucher <alexander.deucher@amd.com>
>>> Date: Fri, 23 Mar 2012 10:54:45 -0400
>>> Subject: [PATCH] drm/radeon/kms/atom: force bpc to 8 for now
>>>
>>> Using the bpc (bits per color) specified by the monitor
>>> can cause problems in some cases. =A0Until we get a better
>>> handle on how to deal with those cases, just use a bpc of 8.
>>>
>>> Reported-by: Lennert Buytenhek <buytenh@wantstofly.org>
>>> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
>>> Cc: stable@kernel.org
>>> ---
>>> =A0drivers/gpu/drm/radeon/atombios_crtc.c =A0 =A0 | =A0 =A08 +++++---
>>> =A0drivers/gpu/drm/radeon/atombios_dp.c =A0 =A0 =A0 | =A0 =A03 +++
>>> =A0drivers/gpu/drm/radeon/atombios_encoders.c | =A0 =A04 ++--
>>> =A03 files changed, 10 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/r=
adeon/atombios_crtc.c
>>> index 083b3ea..b5ff1f7 100644
>>> --- a/drivers/gpu/drm/radeon/atombios_crtc.c
>>> +++ b/drivers/gpu/drm/radeon/atombios_crtc.c
>>> @@ -588,8 +588,8 @@ static u32 atombios_adjust_pll(struct drm_crtc *crt=
c,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (encoder->crtc =3D=3D crtc) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 radeon_encoder =3D to_radeo=
n_encoder(encoder);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 connector =3D radeon_get_co=
nnector_for_encoder(encoder);
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (connector && connector->d=
isplay_info.bpc)
>>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D conne=
ctor->display_info.bpc;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if (connector && connector=
->display_info.bpc)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D conne=
ctor->display_info.bpc; */
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 encoder_mode =3D atombios_g=
et_encoder_mode(encoder);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_duallink =3D radeon_dig_=
monitor_is_duallink(encoder, mode->clock);
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((radeon_encoder->device=
s & (ATOM_DEVICE_LCD_SUPPORT | ATOM_DEVICE_DFP_SUPPORT)) ||
>>> @@ -965,7 +965,9 @@ static void atombios_crtc_set_pll(struct drm_crtc *=
crtc, struct drm_display_mode
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct radeon_connector_atom_dig *dig_conne=
ctor =3D
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 radeon_connector->con_priv;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int dp_clock;
>>> - =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0 /* if (connector->display_info.bpc)
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_in=
fo.bpc; */
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (encoder_mode) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 case ATOM_ENCODER_MODE_DP_MST:
>>> diff --git a/drivers/gpu/drm/radeon/atombios_dp.c b/drivers/gpu/drm/rad=
eon/atombios_dp.c
>>> index 6c62be2..c57d856 100644
>>> --- a/drivers/gpu/drm/radeon/atombios_dp.c
>>> +++ b/drivers/gpu/drm/radeon/atombios_dp.c
>>> @@ -405,10 +405,13 @@ static void dp_get_adjust_train(u8 link_status[DP=
_LINK_STATUS_SIZE],
>>> =A0/* get bpc from the EDID */
>>> =A0static int convert_bpc_to_bpp(int bpc)
>>> =A0{
>>> +#if 0
>>> =A0 =A0 =A0 if (bpc =3D=3D 0)
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 24;
>>> =A0 =A0 =A0 else
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return bpc * 3;
>>> +#endif
>>> + =A0 =A0 return 24;
>>> =A0}
>>>
>>> =A0/* get the max pix clock supported by the link rate and lane num */
>>> diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/d=
rm/radeon/atombios_encoders.c
>>> index 468b874..e607c4d 100644
>>> --- a/drivers/gpu/drm/radeon/atombios_encoders.c
>>> +++ b/drivers/gpu/drm/radeon/atombios_encoders.c
>>> @@ -541,7 +541,7 @@ atombios_dig_encoder_setup(struct drm_encoder *enco=
der, int action, int panel_mo
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dp_clock =3D dig_connector->dp_clock;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dp_lane_count =3D dig_connector->dp_lane_co=
unt;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 hpd_id =3D radeon_connector->hpd.hpd;
>>> - =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 /* bpc =3D connector->display_info.bpc; */
>>> =A0 =A0 =A0 }
>>>
>>> =A0 =A0 =A0 /* no dig encoder assigned */
>>> @@ -1159,7 +1159,7 @@ atombios_external_encoder_setup(struct drm_encode=
r *encoder,
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 dp_lane_count =3D dig_connector->dp_lane_co=
unt;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 connector_object_id =3D
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (radeon_connector->connecto=
r_object_id & OBJECT_ID_MASK) >> OBJECT_ID_SHIFT;
>>> - =A0 =A0 =A0 =A0 =A0 =A0 bpc =3D connector->display_info.bpc;
>>> + =A0 =A0 =A0 =A0 =A0 =A0 /* bpc =3D connector->display_info.bpc; */
>>> =A0 =A0 =A0 }
>>>
>>> =A0 =A0 =A0 memset(&args, 0, sizeof(args));
>>> --
>>> 1.7.7.5
>>>

--e89a8f3ba2a373e9dc04bbee3a32
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-improve-bpc-handling-v2.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-improve-bpc-handling-v2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h05n01me1

RnJvbSA5ZTJkYTNiYzU1OGE3ZGFiNGE5YmQ0OTdkZTVjZmYxOWRjMjBhMGI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IEZyaSwgMjMgTWFyIDIwMTIgMTU6NDE6MTEgLTA0MDAKU3ViamVjdDogW1BBVENI
XSBkcm0vcmFkZW9uL2ttczogaW1wcm92ZSBicGMgaGFuZGxpbmcgKHYyKQoKSW1wcm92ZSBoYW5k
bGluZyBvZiBicGMgKGJpdHMgcGVyIGNvbG9yKSBpbiByYWRlb24uCkluIG1vc3QgY2FzZXMgd2Ug
d2FudCA4IGV4Y2VwdCBmb3IgSERNSSwgRFAsIExWRFMsIGFuZCBlRFAuCgp2MjogaGFuZGxlIERQ
IGJldHRlci4KClNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJA
YW1kLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYyAgICAg
fCAgICA3ICstLQogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19kcC5jICAgICAgIHwg
ICAgNyArLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYyB8ICAg
IDQgKy0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Nvbm5lY3RvcnMuYyB8ICAgNTYg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKwogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRl
b25fbW9kZS5oICAgICAgIHwgICAgMSArCiA1IGZpbGVzIGNoYW5nZWQsIDYzIGluc2VydGlvbnMo
KyksIDEyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
YXRvbWJpb3NfY3J0Yy5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMK
aW5kZXggYjVmZjFmNy4uMmZhYjM4ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9hdG9tYmlvc19jcnRjLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19j
cnRjLmMKQEAgLTU4OCw4ICs1ODgsNyBAQCBzdGF0aWMgdTMyIGF0b21iaW9zX2FkanVzdF9wbGwo
c3RydWN0IGRybV9jcnRjICpjcnRjLAogCQlpZiAoZW5jb2Rlci0+Y3J0YyA9PSBjcnRjKSB7CiAJ
CQlyYWRlb25fZW5jb2RlciA9IHRvX3JhZGVvbl9lbmNvZGVyKGVuY29kZXIpOwogCQkJY29ubmVj
dG9yID0gcmFkZW9uX2dldF9jb25uZWN0b3JfZm9yX2VuY29kZXIoZW5jb2Rlcik7Ci0JCQkvKiBp
ZiAoY29ubmVjdG9yICYmIGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYykKLQkJCQlicGMgPSBj
b25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGM7ICovCisJCQlicGMgPSByYWRlb25fZ2V0X21vbml0
b3JfYnBjKGNvbm5lY3Rvcik7CiAJCQllbmNvZGVyX21vZGUgPSBhdG9tYmlvc19nZXRfZW5jb2Rl
cl9tb2RlKGVuY29kZXIpOwogCQkJaXNfZHVhbGxpbmsgPSByYWRlb25fZGlnX21vbml0b3JfaXNf
ZHVhbGxpbmsoZW5jb2RlciwgbW9kZS0+Y2xvY2spOwogCQkJaWYgKChyYWRlb25fZW5jb2Rlci0+
ZGV2aWNlcyAmIChBVE9NX0RFVklDRV9MQ0RfU1VQUE9SVCB8IEFUT01fREVWSUNFX0RGUF9TVVBQ
T1JUKSkgfHwKQEAgLTk2NSw5ICs5NjQsNyBAQCBzdGF0aWMgdm9pZCBhdG9tYmlvc19jcnRjX3Nl
dF9wbGwoc3RydWN0IGRybV9jcnRjICpjcnRjLCBzdHJ1Y3QgZHJtX2Rpc3BsYXlfbW9kZQogCQlz
dHJ1Y3QgcmFkZW9uX2Nvbm5lY3Rvcl9hdG9tX2RpZyAqZGlnX2Nvbm5lY3RvciA9CiAJCQlyYWRl
b25fY29ubmVjdG9yLT5jb25fcHJpdjsKIAkJaW50IGRwX2Nsb2NrOwotCi0JCS8qIGlmIChjb25u
ZWN0b3ItPmRpc3BsYXlfaW5mby5icGMpCi0JCQlicGMgPSBjb25uZWN0b3ItPmRpc3BsYXlfaW5m
by5icGM7ICovCisJCWJwYyA9IHJhZGVvbl9nZXRfbW9uaXRvcl9icGMoY29ubmVjdG9yKTsKIAog
CQlzd2l0Y2ggKGVuY29kZXJfbW9kZSkgewogCQljYXNlIEFUT01fRU5DT0RFUl9NT0RFX0RQX01T
VDoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZHAuYyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZHAuYwppbmRleCBjNTdkODU2Li5jYWRiYjEw
IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2RwLmMKKysrIGIv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19kcC5jCkBAIC00MDUsMTMgKzQwNSwxMCBA
QCBzdGF0aWMgdm9pZCBkcF9nZXRfYWRqdXN0X3RyYWluKHU4IGxpbmtfc3RhdHVzW0RQX0xJTktf
U1RBVFVTX1NJWkVdLAogLyogZ2V0IGJwYyBmcm9tIHRoZSBFRElEICovCiBzdGF0aWMgaW50IGNv
bnZlcnRfYnBjX3RvX2JwcChpbnQgYnBjKQogewotI2lmIDAKIAlpZiAoYnBjID09IDApCiAJCXJl
dHVybiAyNDsKIAllbHNlCiAJCXJldHVybiBicGMgKiAzOwotI2VuZGlmCi0JcmV0dXJuIDI0Owog
fQogCiAvKiBnZXQgdGhlIG1heCBwaXggY2xvY2sgc3VwcG9ydGVkIGJ5IHRoZSBsaW5rIHJhdGUg
YW5kIGxhbmUgbnVtICovCkBAIC00NjMsNyArNDYwLDcgQEAgc3RhdGljIGludCByYWRlb25fZHBf
Z2V0X2RwX2xhbmVfbnVtYmVyKHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3IsCiAJCQkJ
CXU4IGRwY2RbRFBfRFBDRF9TSVpFXSwKIAkJCQkJaW50IHBpeF9jbG9jaykKIHsKLQlpbnQgYnBw
ID0gY29udmVydF9icGNfdG9fYnBwKGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYyk7CisJaW50
IGJwcCA9IGNvbnZlcnRfYnBjX3RvX2JwcChyYWRlb25fZ2V0X21vbml0b3JfYnBjKGNvbm5lY3Rv
cikpOwogCWludCBtYXhfbGlua19yYXRlID0gZHBfZ2V0X21heF9saW5rX3JhdGUoZHBjZCk7CiAJ
aW50IG1heF9sYW5lX251bSA9IGRwX2dldF9tYXhfbGFuZV9udW1iZXIoZHBjZCk7CiAJaW50IGxh
bmVfbnVtOwpAQCAtNDgyLDcgKzQ3OSw3IEBAIHN0YXRpYyBpbnQgcmFkZW9uX2RwX2dldF9kcF9s
aW5rX2Nsb2NrKHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3IsCiAJCQkJICAgICAgIHU4
IGRwY2RbRFBfRFBDRF9TSVpFXSwKIAkJCQkgICAgICAgaW50IHBpeF9jbG9jaykKIHsKLQlpbnQg
YnBwID0gY29udmVydF9icGNfdG9fYnBwKGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYyk7CisJ
aW50IGJwcCA9IGNvbnZlcnRfYnBjX3RvX2JwcChyYWRlb25fZ2V0X21vbml0b3JfYnBjKGNvbm5l
Y3RvcikpOwogCWludCBsYW5lX251bSwgbWF4X3BpeF9jbG9jazsKIAogCWlmIChyYWRlb25fY29u
bmVjdG9yX2VuY29kZXJfZ2V0X2RwX2JyaWRnZV9lbmNvZGVyX2lkKGNvbm5lY3RvcikgPT0KZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfZW5jb2RlcnMuYwppbmRleCBlNjA3YzRkLi4w
NmIyMDliIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2VuY29k
ZXJzLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19lbmNvZGVycy5jCkBA
IC01NDEsNyArNTQxLDcgQEAgYXRvbWJpb3NfZGlnX2VuY29kZXJfc2V0dXAoc3RydWN0IGRybV9l
bmNvZGVyICplbmNvZGVyLCBpbnQgYWN0aW9uLCBpbnQgcGFuZWxfbW8KIAkJZHBfY2xvY2sgPSBk
aWdfY29ubmVjdG9yLT5kcF9jbG9jazsKIAkJZHBfbGFuZV9jb3VudCA9IGRpZ19jb25uZWN0b3It
PmRwX2xhbmVfY291bnQ7CiAJCWhwZF9pZCA9IHJhZGVvbl9jb25uZWN0b3ItPmhwZC5ocGQ7Ci0J
CS8qIGJwYyA9IGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYzsgKi8KKwkJYnBjID0gcmFkZW9u
X2dldF9tb25pdG9yX2JwYyhjb25uZWN0b3IpOwogCX0KIAogCS8qIG5vIGRpZyBlbmNvZGVyIGFz
c2lnbmVkICovCkBAIC0xMTU5LDcgKzExNTksNyBAQCBhdG9tYmlvc19leHRlcm5hbF9lbmNvZGVy
X3NldHVwKHN0cnVjdCBkcm1fZW5jb2RlciAqZW5jb2RlciwKIAkJZHBfbGFuZV9jb3VudCA9IGRp
Z19jb25uZWN0b3ItPmRwX2xhbmVfY291bnQ7CiAJCWNvbm5lY3Rvcl9vYmplY3RfaWQgPQogCQkJ
KHJhZGVvbl9jb25uZWN0b3ItPmNvbm5lY3Rvcl9vYmplY3RfaWQgJiBPQkpFQ1RfSURfTUFTSykg
Pj4gT0JKRUNUX0lEX1NISUZUOwotCQkvKiBicGMgPSBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5i
cGM7ICovCisJCWJwYyA9IHJhZGVvbl9nZXRfbW9uaXRvcl9icGMoY29ubmVjdG9yKTsKIAl9CiAK
IAltZW1zZXQoJmFyZ3MsIDAsIHNpemVvZihhcmdzKSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3JhZGVvbl9jb25uZWN0b3JzLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JhZGVvbl9jb25uZWN0b3JzLmMKaW5kZXggYmQwNTE1Ni4uNzFmYTM4OSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fY29ubmVjdG9ycy5jCisrKyBiL2RyaXZlcnMv
Z3B1L2RybS9yYWRlb24vcmFkZW9uX2Nvbm5lY3RvcnMuYwpAQCAtODQsNiArODQsNjIgQEAgc3Rh
dGljIHZvaWQgcmFkZW9uX3Byb3BlcnR5X2NoYW5nZV9tb2RlKHN0cnVjdCBkcm1fZW5jb2RlciAq
ZW5jb2RlcikKIAkJCQkJIGNydGMtPngsIGNydGMtPnksIGNydGMtPmZiKTsKIAl9CiB9CisKK2lu
dCByYWRlb25fZ2V0X21vbml0b3JfYnBjKHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3Ip
Cit7CisJc3RydWN0IGRybV9kZXZpY2UgKmRldiA9IGNvbm5lY3Rvci0+ZGV2OworCXN0cnVjdCBy
YWRlb25fZGV2aWNlICpyZGV2ID0gZGV2LT5kZXZfcHJpdmF0ZTsKKwlzdHJ1Y3QgcmFkZW9uX2Nv
bm5lY3RvciAqcmFkZW9uX2Nvbm5lY3RvciA9IHRvX3JhZGVvbl9jb25uZWN0b3IoY29ubmVjdG9y
KTsKKwlzdHJ1Y3QgcmFkZW9uX2Nvbm5lY3Rvcl9hdG9tX2RpZyAqZGlnX2Nvbm5lY3RvcjsKKwlp
bnQgYnBjID0gODsKKworCXN3aXRjaCAoY29ubmVjdG9yLT5jb25uZWN0b3JfdHlwZSkgeworCWNh
c2UgRFJNX01PREVfQ09OTkVDVE9SX0RWSUk6CisJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfSERN
SUI6CisJCWlmIChyYWRlb25fY29ubmVjdG9yLT51c2VfZGlnaXRhbCkgeworCQkJaWYgKGRybV9k
ZXRlY3RfaGRtaV9tb25pdG9yKHJhZGVvbl9jb25uZWN0b3ItPmVkaWQpKSB7CisJCQkJaWYgKGNv
bm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYykKKwkJCQkJYnBjID0gY29ubmVjdG9yLT5kaXNwbGF5
X2luZm8uYnBjOworCQkJfQorCQl9CisJCWJyZWFrOworCWNhc2UgRFJNX01PREVfQ09OTkVDVE9S
X0RWSUQ6CisJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfSERNSUE6CisJCWlmIChkcm1fZGV0ZWN0
X2hkbWlfbW9uaXRvcihyYWRlb25fY29ubmVjdG9yLT5lZGlkKSkgeworCQkJaWYgKGNvbm5lY3Rv
ci0+ZGlzcGxheV9pbmZvLmJwYykKKwkJCQlicGMgPSBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5i
cGM7CisJCX0KKwkJYnJlYWs7CisJY2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfRGlzcGxheVBvcnQ6
CisJCWRpZ19jb25uZWN0b3IgPSByYWRlb25fY29ubmVjdG9yLT5jb25fcHJpdjsKKwkJaWYgKChk
aWdfY29ubmVjdG9yLT5kcF9zaW5rX3R5cGUgPT0gQ09OTkVDVE9SX09CSkVDVF9JRF9ESVNQTEFZ
UE9SVCkgfHwKKwkJICAgIChkaWdfY29ubmVjdG9yLT5kcF9zaW5rX3R5cGUgPT0gQ09OTkVDVE9S
X09CSkVDVF9JRF9lRFApIHx8CisJCSAgICBkcm1fZGV0ZWN0X2hkbWlfbW9uaXRvcihyYWRlb25f
Y29ubmVjdG9yLT5lZGlkKSkgeworCQkJaWYgKGNvbm5lY3Rvci0+ZGlzcGxheV9pbmZvLmJwYykK
KwkJCQlicGMgPSBjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGM7CisJCX0KKwkJYnJlYWs7CisJ
Y2FzZSBEUk1fTU9ERV9DT05ORUNUT1JfZURQOgorCWNhc2UgRFJNX01PREVfQ09OTkVDVE9SX0xW
RFM6CisJCWlmIChjb25uZWN0b3ItPmRpc3BsYXlfaW5mby5icGMpCisJCQlicGMgPSBjb25uZWN0
b3ItPmRpc3BsYXlfaW5mby5icGM7CisJCWVsc2UgaWYgKEFTSUNfSVNfRENFNDEocmRldikgfHwg
QVNJQ19JU19EQ0U1KHJkZXYpKSB7CisJCQlzdHJ1Y3QgZHJtX2Nvbm5lY3Rvcl9oZWxwZXJfZnVu
Y3MgKmNvbm5lY3Rvcl9mdW5jcyA9CisJCQkJY29ubmVjdG9yLT5oZWxwZXJfcHJpdmF0ZTsKKwkJ
CXN0cnVjdCBkcm1fZW5jb2RlciAqZW5jb2RlciA9IGNvbm5lY3Rvcl9mdW5jcy0+YmVzdF9lbmNv
ZGVyKGNvbm5lY3Rvcik7CisJCQlzdHJ1Y3QgcmFkZW9uX2VuY29kZXIgKnJhZGVvbl9lbmNvZGVy
ID0gdG9fcmFkZW9uX2VuY29kZXIoZW5jb2Rlcik7CisJCQlzdHJ1Y3QgcmFkZW9uX2VuY29kZXJf
YXRvbV9kaWcgKmRpZyA9IHJhZGVvbl9lbmNvZGVyLT5lbmNfcHJpdjsKKworCQkJaWYgKGRpZy0+
bGNkX21pc2MgJiBBVE9NX1BBTkVMX01JU0NfVjEzXzZCSVRfUEVSX0NPTE9SKQorCQkJCWJwYyA9
IDY7CisJCQllbHNlIGlmIChkaWctPmxjZF9taXNjICYgQVRPTV9QQU5FTF9NSVNDX1YxM184QklU
X1BFUl9DT0xPUikKKwkJCQlicGMgPSA4OworCQl9CisJCWJyZWFrOworCX0KKwlyZXR1cm4gYnBj
OworfQorCiBzdGF0aWMgdm9pZAogcmFkZW9uX2Nvbm5lY3Rvcl91cGRhdGVfc2NyYXRjaF9yZWdz
KHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3IsIGVudW0gZHJtX2Nvbm5lY3Rvcl9zdGF0
dXMgc3RhdHVzKQogewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25f
bW9kZS5oIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fbW9kZS5oCmluZGV4IGY3ZWI1
ZDguLmIyY2NhNmEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX21v
ZGUuaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9tb2RlLmgKQEAgLTQ3Niw2
ICs0NzYsNyBAQCBleHRlcm4gdTE2IHJhZGVvbl9lbmNvZGVyX2dldF9kcF9icmlkZ2VfZW5jb2Rl
cl9pZChzdHJ1Y3QgZHJtX2VuY29kZXIgKmVuY29kZXIpOwogZXh0ZXJuIHUxNiByYWRlb25fY29u
bmVjdG9yX2VuY29kZXJfZ2V0X2RwX2JyaWRnZV9lbmNvZGVyX2lkKHN0cnVjdCBkcm1fY29ubmVj
dG9yICpjb25uZWN0b3IpOwogZXh0ZXJuIGJvb2wgcmFkZW9uX2Nvbm5lY3Rvcl9lbmNvZGVyX2lz
X2hicjIoc3RydWN0IGRybV9jb25uZWN0b3IgKmNvbm5lY3Rvcik7CiBleHRlcm4gYm9vbCByYWRl
b25fY29ubmVjdG9yX2lzX2RwMTJfY2FwYWJsZShzdHJ1Y3QgZHJtX2Nvbm5lY3RvciAqY29ubmVj
dG9yKTsKK2V4dGVybiBpbnQgcmFkZW9uX2dldF9tb25pdG9yX2JwYyhzdHJ1Y3QgZHJtX2Nvbm5l
Y3RvciAqY29ubmVjdG9yKTsKIAogZXh0ZXJuIHZvaWQgcmFkZW9uX2Nvbm5lY3Rvcl9ob3RwbHVn
KHN0cnVjdCBkcm1fY29ubmVjdG9yICpjb25uZWN0b3IpOwogZXh0ZXJuIGludCByYWRlb25fZHBf
bW9kZV92YWxpZF9oZWxwZXIoc3RydWN0IGRybV9jb25uZWN0b3IgKmNvbm5lY3RvciwKLS0gCjEu
Ny43LjUKCg==
--e89a8f3ba2a373e9dc04bbee3a32--
