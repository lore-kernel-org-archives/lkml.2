Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0GNWRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:17:10 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59023 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab0GNWRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:17:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hg0pBwur/YWhBV+jwkzhFGtlLO1aWi9ZMjCCERp0ksy1i3XNRmGXsBKBZR0KYfs9FG
         GLfM66pOn28Cgcy9AwIAwt927aPnscY8xe3ujQdumgvXckiAmS72FOuYEgeZOtMrQadN
         zRLDxqbpSiX4VAk3xThQfRuShL1El05JcAq4o=
MIME-Version: 1.0
In-Reply-To: <AANLkTinePpZEsWShq8EB-No-CAQQsaDwLUbLVaSmrG5R@mail.gmail.com>
References: <AANLkTimkNg81yzxSHTcAa1QlTE9SYmvzL4eOTVHApWq3@mail.gmail.com>
	<AANLkTilvbOb0n9l6F3EHwQg3VfNNmYB1BdFbzL2Cwg_P@mail.gmail.com>
	<AANLkTinnlhzSGP8sRQ8Pr4CIuwn4d859rvSe1yO_3TEz@mail.gmail.com>
	<AANLkTil58zbo28QL2ncTAXx9iHeQS20W8u0MuDgLaojj@mail.gmail.com>
	<AANLkTim-yNCtMnxzzA8yJnD6CLkF2Mz-aA4E5qbYMBlz@mail.gmail.com>
	<AANLkTim9EQ9nPISuH5wNsrAd8bHM-xBnpgqAi-W_ZCTi@mail.gmail.com>
	<AANLkTikjXiBoR3c5g6QaNfQKfX4vWUW8mt0AdomMa8at@mail.gmail.com>
	<4C3E103A.3030706@freedesktop.org>
	<AANLkTinePpZEsWShq8EB-No-CAQQsaDwLUbLVaSmrG5R@mail.gmail.com>
Date: Wed, 14 Jul 2010 18:16:59 -0400
Message-ID: <AANLkTilWzpu6Re9HG2jTqpHUU7NohULOEgHqGT4yTIaz@mail.gmail.com>
Subject: Re: Regression 2.6.34->2.6.35-rc4: radeaon KMS an RS690 broken
From: Alex Deucher <alexdeucher@gmail.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Jerome Glisse <glisse@freedesktop.org>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: multipart/mixed; boundary=0015174c3c86351e18048b6058a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c3c86351e18048b6058a4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 14, 2010 at 4:05 PM, Torsten Kaiser
<just.for.lkml@googlemail.com> wrote:
> On Wed, Jul 14, 2010 at 9:30 PM, Jerome Glisse <glisse@freedesktop.org> w=
rote:
>> On 07/14/2010 02:51 PM, Torsten Kaiser wrote:
>>>
>>> On Tue, Jul 13, 2010 at 9:10 PM, Alex Deucher<alexdeucher@gmail.com>
>>> =A0wrote:
>>>>
>>>> On Tue, Jul 13, 2010 at 2:29 PM, Torsten Kaiser
>>>> <just.for.lkml@googlemail.com> =A0wrote:
>>>>>
>>>>> But the CP is still broken:
>>>>
>>>> Is this a regression? =A0If so, can you bisect it?
>>>>
>>>> Alex
>>>
>>> I bisected it to this commit:
>>>
>>> d594e46ace22afa1621254f6f669e65430048153 is the first bad commit
>>> commit d594e46ace22afa1621254f6f669e65430048153
>>> Author: Jerome Glisse<jglisse@redhat.com>
>>> Date: =A0 Wed Feb 17 21:54:29 2010 +0000
>>>
>>> =A0 =A0 drm/radeon/kms: simplify memory controller setup V2
>>>
>>> =A0 =A0 Get rid of _location and use _start/_end also simplify the
>>> =A0 =A0 computation of vram_start|end& =A0gtt_start|end. For R1XX-R2XX
>>> =A0 =A0 we place VRAM at the same address of PCI aperture, those GPU
>>> =A0 =A0 shouldn't have much memory and seems to behave better when
>>> =A0 =A0 setup that way. For R3XX and newer we place VRAM at 0. For
>>> =A0 =A0 R6XX-R7XX AGP we place VRAM before or after AGP aperture this
>>> =A0 =A0 might limit to limit the VRAM size but it's very unlikely.
>>> =A0 =A0 For IGP we don't change the VRAM placement.
>>>
>>> =A0 =A0 Tested on (compiz,quake3,suspend/resume):
>>> =A0 =A0 PCI/PCIE:RV280,R420,RV515,RV570,RV610,RV710
>>> =A0 =A0 AGP:RV100,RV280,R420,RV350,RV620(RPB*),RV730
>>> =A0 =A0 IGP:RS480(RPB*),RS690,RS780(RPB*),RS880
>>>
>>> =A0 =A0 RPB: resume previously broken
>>>
>>> =A0 =A0 V2 correct commit message to reflect more accurately the bug
>>> =A0 =A0 and move VRAM placement to 0 for most of the GPU to avoid
>>> =A0 =A0 limiting VRAM.
>>>
>>> =A0 =A0 Signed-off-by: Jerome Glisse<jglisse@redhat.com>
>>> =A0 =A0 Signed-off-by: Dave Airlie<airlied@redhat.com>
>>>
>>> :040000 040000 05c1e456fcf6565aa8711e4933807956d0055cca
>>> 792c6be2bd161a52500c5e8d685ee651cd5af07e M =A0 =A0 drivers
>>>
>>> HTH, Torsten
>>>
>>>>> [ =A0 =A00.426931] Linux agpgart interface v0.103
>>>>> [ =A0 =A00.427092] [drm] Initialized drm 1.1.0 20060810
>>>>> [ =A0 =A00.427196] [drm] radeon defaulting to kernel modesetting.
>>>>> [ =A0 =A00.427255] [drm] radeon kernel modesetting enabled.
>>>>> [ =A0 =A00.427372] radeon 0000:01:05.0: PCI INT A -> =A0GSI 18 (level=
, low) ->
>>>>> =A0IRQ 18
>>>>> [ =A0 =A00.429659] [drm] initializing kernel modesetting (RS690
>>>>> 0x1002:0x791E).
>>>>> [ =A0 =A00.429817] [drm] register mmio base: 0xFE9F0000
>>>>> [ =A0 =A00.429876] [drm] register mmio size: 65536
>>>>> [ =A0 =A00.430457] ATOM BIOS: ATI
>>>>> [ =A0 =A00.430532] radeon 0000:01:05.0: VRAM: 32M 0xDE000000 - 0xDFFF=
FFFF
>>>>> (32M used)
>>>>> [ =A0 =A00.430592] radeon 0000:01:05.0: GTT: 512M 0xBE000000 - 0xDDFF=
FFFF
>>>>> [ =A0 =A00.430675] [drm] radeon: irq initialized.
>>>>> [ =A0 =A00.430737] mtrr: type mismatch for fc000000,2000000 old:
>>>>> write-back new: write-comb
>>>>> ining
>>>>> [ =A0 =A00.430811] [drm] Detected VRAM RAM=3D32M, BAR=3D32M
>>>>> [ =A0 =A00.430868] [drm] RAM width 128bits DDR
>>>>> [ =A0 =A00.431011] [TTM] Zone =A0kernel: Available graphics memory: 2=
010234
>>>>> kiB.
>>>>> [ =A0 =A00.431070] [TTM] Initializing pool allocator.
>>>>> [ =A0 =A00.431147] [drm] radeon: 32M of VRAM memory ready
>>>>> [ =A0 =A00.431205] [drm] radeon: 512M of GTT memory ready.
>>>>> [ =A0 =A00.431266] [drm] GART: num cpu pages 131072, num gpu pages 13=
1072
>>>>> [ =A0 =A00.434654] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
>>>>> [ =A0 =A00.441719] [drm] Loading RS690/RS740 Microcode
>>>>> [ =A0 =A00.441926] [drm] radeon: ring at 0x00000000BE000000
>>>>> [ =A0 =A00.577118] [drm:r100_ring_test] *ERROR* radeon: ring test fai=
led
>>>>> (sracth(0x15E4)=3D0x
>>>>> CAFEDEAD)
>>>>> [ =A0 =A00.577192] [drm:r100_cp_init] *ERROR* radeon: cp isn't workin=
g
>>>>> (-22).
>>>>> [ =A0 =A00.577252] radeon 0000:01:05.0: failled initializing CP (-22)=
.
>>>>> [ =A0 =A00.577310] radeon 0000:01:05.0: Disabling GPU acceleration
>>>>> [ =A0 =A00.577440] [drm] radeon: cp finalized
>>>>> [ =A0 =A00.578078] [drm] Default TV standard: NTSC
>>>>> [ =A0 =A00.578314] [drm] Default TV standard: NTSC
>>>>> [ =A0 =A00.578590] [drm] Radeon Display Connectors
>>>>> [ =A0 =A00.578648] [drm] Connector 0:
>>>>> [ =A0 =A00.578706] [drm] =A0 VGA
>>>>> [ =A0 =A00.578764] [drm] =A0 DDC: 0x7e50 0x7e40 0x7e54 0x7e44 0x7e58 =
0x7e48
>>>>> 0x7e5c 0x7e4c
>>>>> [ =A0 =A00.578837] [drm] =A0 Encoders:
>>>>> [ =A0 =A00.578894] [drm] =A0 =A0 CRT1: INTERNAL_KLDSCP_DAC1
>>>>> [ =A0 =A00.578952] [drm] Connector 1:
>>>>> [ =A0 =A00.579010] [drm] =A0 S-video
>>>>> [ =A0 =A00.579067] [drm] =A0 Encoders:
>>>>> [ =A0 =A00.579124] [drm] =A0 =A0 TV1: INTERNAL_KLDSCP_DAC1
>>>>> [ =A0 =A00.579182] [drm] Connector 2:
>>>>> [ =A0 =A00.579239] [drm] =A0 HDMI-A
>>>>> [ =A0 =A00.579297] [drm] =A0 DDC: 0x7e40 0x7e50 0x7e44 0x7e54 0x7e48 =
0x7e58
>>>>> 0x7e4c 0x7e5c
>>>>> [ =A0 =A00.579369] [drm] =A0 Encoders:
>>>>> [ =A0 =A00.579427] [drm] =A0 =A0 DFP3: INTERNAL_LVTM1
>>>>> [ =A0 =A00.773375] [drm] fb mappable at 0xFC040000
>>>>> [ =A0 =A00.773434] [drm] vram apper at 0xFC000000
>>>>> [ =A0 =A00.773491] [drm] size 786432
>>>>> [ =A0 =A00.773549] [drm] fb depth is 8
>>>>> [ =A0 =A00.773606] [drm] =A0 =A0pitch is 1024
>>>>> [ =A0 =A00.773737] fbcon: radeondrmfb (fb0) is primary device
>>>>> [ =A0 =A00.793240] Console: switching to colour frame buffer device 1=
28x48
>>>>> [ =A0 =A00.794833] fb0: radeondrmfb frame buffer device
>>>>> [ =A0 =A00.794852] drm: registered panic notifier
>>>>> [ =A0 =A00.794871] Slow work thread pool: Starting up
>>>>> [ =A0 =A00.794932] Slow work thread pool: Ready
>>>>> [ =A0 =A00.794953] [drm] Initialized radeon 2.5.0 20080528 for
>>>>> 0000:01:05.0 on minor 0
>>>>>
>>>>>
>>>>> Torsten
>>>>>
>>>>
>>
>> Does the attached patch works ? (try to change the if 0 to if 1 too
>
> The patch doesn't compile, but after changing mc->foo to rdev->mc.foo it =
built.
>

I discussed this with Jerome and I think we found the root cause.
Does this patch help?

Alex


> Result from the original patch ("if 0"):
> [ =A0 =A00.429603] [drm] initializing kernel modesetting (RS690 0x1002:0x=
791E).
> [ =A0 =A00.429751] [drm] register mmio base: 0xFE9F0000
> [ =A0 =A00.429809] [drm] register mmio size: 65536
> [ =A0 =A00.430385] ATOM BIOS: ATI
> [ =A0 =A00.430460] radeon 0000:01:05.0: VRAM: 32M 0xDE000000 - 0xDFFFFFFF=
 (32M used)
> [ =A0 =A00.430520] radeon 0000:01:05.0: GTT: 512M 0xB0000000 - 0xCFFFFFFF
> [ =A0 =A00.430603] [drm] radeon: irq initialized.
> [ =A0 =A00.430666] mtrr: type mismatch for fc000000,2000000 old:
> write-back new: write-combining
> [ =A0 =A00.430739] [drm] Detected VRAM RAM=3D32M, BAR=3D32M
> [ =A0 =A00.430797] [drm] RAM width 128bits DDR
> [ =A0 =A00.430940] [TTM] Zone =A0kernel: Available graphics memory: 20102=
34 kiB.
> [ =A0 =A00.430999] [TTM] Initializing pool allocator.
> [ =A0 =A00.431075] [drm] radeon: 32M of VRAM memory ready
> [ =A0 =A00.431133] [drm] radeon: 512M of GTT memory ready.
> [ =A0 =A00.431194] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [ =A0 =A00.434577] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
> [ =A0 =A00.441645] [drm] Loading RS690/RS740 Microcode
> [ =A0 =A00.441853] [drm] radeon: ring at 0x00000000B0000000
> [ =A0 =A00.576773] [drm:r100_ring_test] *ERROR* radeon: ring test failed
> (sracth(0x15E4)=3D0xCAFEDEAD)
> [ =A0 =A00.576847] [drm:r100_cp_init] *ERROR* radeon: cp isn't working (-=
22).
> [ =A0 =A00.576907] radeon 0000:01:05.0: failled initializing CP (-22).
> [ =A0 =A00.576965] radeon 0000:01:05.0: Disabling GPU acceleration
>
> Result from patch after changing it to "if 1":
> [ =A0 =A00.400348] [drm] initializing kernel modesetting (RS690 0x1002:0x=
791E).
> [ =A0 =A00.400497] [drm] register mmio base: 0xFE9F0000
> [ =A0 =A00.400556] [drm] register mmio size: 65536
> [ =A0 =A00.401097] ATOM BIOS: ATI
> [ =A0 =A00.401171] radeon 0000:01:05.0: VRAM: 32M 0xDE000000 - 0xDFFFFFFF=
 (32M used)
> [ =A0 =A00.401231] radeon 0000:01:05.0: GTT: 512M 0x00000000 - 0x1FFFFFFF
> [ =A0 =A00.401314] [drm] radeon: irq initialized.
> [ =A0 =A00.401377] mtrr: type mismatch for fc000000,2000000 old:
> write-back new: write-combining
> [ =A0 =A00.401451] [drm] Detected VRAM RAM=3D32M, BAR=3D32M
> [ =A0 =A00.401509] [drm] RAM width 128bits DDR
> [ =A0 =A00.401597] [TTM] Zone =A0kernel: Available graphics memory: 20102=
34 kiB.
> [ =A0 =A00.401656] [TTM] Initializing pool allocator.
> [ =A0 =A00.401732] [drm] radeon: 32M of VRAM memory ready
> [ =A0 =A00.401791] [drm] radeon: 512M of GTT memory ready.
> [ =A0 =A00.401852] [drm] GART: num cpu pages 131072, num gpu pages 131072
> [ =A0 =A00.405242] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
> [ =A0 =A00.412298] [drm] Loading RS690/RS740 Microcode
> [ =A0 =A00.412507] [drm] radeon: ring at 0x0000000000000000
> [ =A0 =A00.412582] [drm] ring test succeeded in 1 usecs
> [ =A0 =A00.412726] [drm] radeon: ib pool ready.
> [ =A0 =A00.412792] [drm] ib test succeeded in 0 usecs
>
> Torsten
>

--0015174c3c86351e18048b6058a4
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-fix-gtt-MC-base-alignment-on-rs4xx-rs.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-fix-gtt-MC-base-alignment-on-rs4xx-rs.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbmqby170

RnJvbSBkOWE0MDFlODdlNzcwOTQ5ZWJlYmYxZTc0MWNkNzRhY2M5ZmJhYmFmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCAxNCBKdWwgMjAxMCAxNzo1ODoxNSAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBmaXggZ3R0IE1DIGJhc2UgYWxpZ25tZW50IG9uIHJzNHh4L3JzNjkwL3Jz
NzQwIGFzaWNzCgpUaGUgYXNpY3MgaW4gcXVlc3Rpb24gaGF2ZSB0aGUgZm9sbG93aW5nIHJlcXVp
cmVtZW50cyB3aXRoIHJlZ2FyZCB0bwp0aGVpciBnYXJ0IHNldHVwczoKCjEuIFRoZSBHQVJUIGFw
ZXJ0dXJlIHNpemUgaGFzIHRvIGJlIGluIHRoZSBmb3JtIG9mIDJeWCBieXRlcywgd2hlcmUgWCBp
cyBmcm9tIDI1IHRvIDMxCjIuIFRoZSBHQVJUIGFwZXJ0dXJlIE1DIGJhc2UgaGFzIHRvIGJlIGFs
aWduZWQgdG8gYSBib3VuZGFyeSBlcXVhbCB0byB0aGUgc2l6ZSBvZiB0aGUKYXBlcnR1cmUuCjMu
IFRoZSBHQVJUIHBhZ2UgdGFibGUgaGFzIHRvIGJlIGFsaWduZWQgdG8gdGhlIGJvdW5kYXJ5IGVx
dWFsIHRvIHRoZSBzaXplIG9mIHRoZSB0YWJsZS4KNC4gVGhlIEdBUlQgcGFnZSB0YWJsZSBzaXpl
IGlzOiB0YWJsZV9lbnRyeV9zaXplICogKGFwZXJ0dXJlX3NpemUgLyBwYWdlX3NpemUpCjUuIFRo
ZSBHQVJUIHBhZ2UgdGFibGUgaGFzIHRvIGJlIGFsbG9jYXRlZCBpbiBub24tcGFnZWQsIG5vbi1j
YWNoZWQsIGNvbnRpZ3VvdXMgc3lzdGVtCm1lbW9yeS4KClRoaXMgcGF0Y2ggdGFrZXMgY2FyZSAy
LiAgVGhlIHJlc3Qgc2hvdWxkIGFscmVhZHkgYmUgaGFuZGxlZCBwcm9wZXJseS4KClRoaXMgc2hv
dWxkIGZpeCBhIHJlZ3Jlc3Npb24gbm90aWNlZCBieTogVG9yc3RlbiBLYWlzZXIgPGp1c3QuZm9y
LmxrbWxAZ29vZ2xlbWFpbC5jb20+CgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhk
ZXVjaGVyQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3IxMDAuYyAgICAg
ICAgICB8ICAgIDEgKwogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMzAwLmMgICAgICAgICAgfCAg
ICAxICsKIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUyMC5jICAgICAgICAgIHwgICAgMSArCiBk
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYyAgICAgICAgICB8ICAgIDEgKwogZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9yYWRlb24uaCAgICAgICAgfCAgICAxICsKIGRyaXZlcnMvZ3B1L2RybS9y
YWRlb24vcmFkZW9uX2RldmljZS5jIHwgICAgOCArKysrLS0tLQogZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yczQwMC5jICAgICAgICAgfCAgICA1ICsrKystCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JzNjAwLmMgICAgICAgICB8ICAgIDEgKwogZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczY5MC5j
ICAgICAgICAgfCAgICAxICsKIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnY1MTUuYyAgICAgICAg
IHwgICAgMSArCiAxMCBmaWxlcyBjaGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjEwMC5jIGIvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yMTAwLmMKaW5kZXggMzY2YmNkOC4uYTc3MjZmMSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMTAwLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yMTAwLmMKQEAgLTIzNTQsNiArMjM1NCw3IEBAIHZvaWQgcjEwMF9tY19pbml0KHN0cnVj
dCByYWRlb25fZGV2aWNlICpyZGV2KQogCWlmIChyZGV2LT5mbGFncyAmIFJBREVPTl9JU19JR1Ap
CiAJCWJhc2UgPSAoUlJFRzMyKFJBREVPTl9OQl9UT00pICYgMHhmZmZmKSA8PCAxNjsKIAlyYWRl
b25fdnJhbV9sb2NhdGlvbihyZGV2LCAmcmRldi0+bWMsIGJhc2UpOworCXJkZXYtPm1jLmd0dF9i
YXNlX2FsaWduID0gMDsKIAlpZiAoIShyZGV2LT5mbGFncyAmIFJBREVPTl9JU19BR1ApKQogCQly
YWRlb25fZ3R0X2xvY2F0aW9uKHJkZXYsICZyZGV2LT5tYyk7CiAJcmFkZW9uX3VwZGF0ZV9iYW5k
d2lkdGhfaW5mbyhyZGV2KTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjMw
MC5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMzAwLmMKaW5kZXggN2U4MWRiNS4uMGExNjM4
YyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yMzAwLmMKKysrIGIvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yMzAwLmMKQEAgLTQ4MSw2ICs0ODEsNyBAQCB2b2lkIHIzMDBfbWNf
aW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAlpZiAocmRldi0+ZmxhZ3MgJiBSQURF
T05fSVNfSUdQKQogCQliYXNlID0gKFJSRUczMihSQURFT05fTkJfVE9NKSAmIDB4ZmZmZikgPDwg
MTY7CiAJcmFkZW9uX3ZyYW1fbG9jYXRpb24ocmRldiwgJnJkZXYtPm1jLCBiYXNlKTsKKwlyZGV2
LT5tYy5ndHRfYmFzZV9hbGlnbiA9IDA7CiAJaWYgKCEocmRldi0+ZmxhZ3MgJiBSQURFT05fSVNf
QUdQKSkKIAkJcmFkZW9uX2d0dF9sb2NhdGlvbihyZGV2LCAmcmRldi0+bWMpOwogCXJhZGVvbl91
cGRhdGVfYmFuZHdpZHRoX2luZm8ocmRldik7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL3I1MjAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUyMC5jCmluZGV4IDM0MzMw
ZGYuLjY5NGFmN2MgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUyMC5jCisr
KyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjUyMC5jCkBAIC0xMjUsNiArMTI1LDcgQEAgdm9p
ZCByNTIwX21jX2luaXQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpCiAJcjUyMF92cmFtX2dl
dF90eXBlKHJkZXYpOwogCXIxMDBfdnJhbV9pbml0X3NpemVzKHJkZXYpOwogCXJhZGVvbl92cmFt
X2xvY2F0aW9uKHJkZXYsICZyZGV2LT5tYywgMCk7CisJcmRldi0+bWMuZ3R0X2Jhc2VfYWxpZ24g
PSAwOwogCWlmICghKHJkZXYtPmZsYWdzICYgUkFERU9OX0lTX0FHUCkpCiAJCXJhZGVvbl9ndHRf
bG9jYXRpb24ocmRldiwgJnJkZXYtPm1jKTsKIAlyYWRlb25fdXBkYXRlX2JhbmR3aWR0aF9pbmZv
KHJkZXYpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yNjAwLmMgYi9kcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYwppbmRleCBmMmY1MDljLi5hZDM4Y2E4IDEwMDY0NAot
LS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYworKysgYi9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL3I2MDAuYwpAQCAtMTE5NCw2ICsxMTk0LDcgQEAgdm9pZCByNjAwX3ZyYW1fZ3R0X2xv
Y2F0aW9uKHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2LCBzdHJ1Y3QgcmFkZW9uX21jICptYykK
IAkJaWYgKHJkZXYtPmZsYWdzICYgUkFERU9OX0lTX0lHUCkKIAkJCWJhc2UgPSAoUlJFRzMyKE1D
X1ZNX0ZCX0xPQ0FUSU9OKSAmIDB4RkZGRikgPDwgMjQ7CiAJCXJhZGVvbl92cmFtX2xvY2F0aW9u
KHJkZXYsICZyZGV2LT5tYywgYmFzZSk7CisJCXJkZXYtPm1jLmd0dF9iYXNlX2FsaWduID0gMDsK
IAkJcmFkZW9uX2d0dF9sb2NhdGlvbihyZGV2LCBtYyk7CiAJfQogfQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb24uaCBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFk
ZW9uLmgKaW5kZXggNWY0YTJjMC4uZTdiNmU4OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJt
L3JhZGVvbi9yYWRlb24uaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbi5oCkBA
IC0zNTQsNiArMzU0LDcgQEAgc3RydWN0IHJhZGVvbl9tYyB7CiAJaW50CQkJdnJhbV9tdHJyOwog
CWJvb2wJCQl2cmFtX2lzX2RkcjsKIAlib29sCQkJaWdwX3NpZGVwb3J0X2VuYWJsZWQ7CisJdTY0
ICAgICAgICAgICAgICAgICAgICAgZ3R0X2Jhc2VfYWxpZ247CiB9OwogCiBib29sIHJhZGVvbl9j
b21iaW9zX3NpZGVwb3J0X3ByZXNlbnQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJkZXYpOwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fZGV2aWNlLmMgYi9kcml2ZXJz
L2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kZXZpY2UuYwppbmRleCA5YjA5MmI2Li4zZmNhOTIwIDEw
MDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kZXZpY2UuYworKysgYi9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kZXZpY2UuYwpAQCAtMjI2LDIwICsyMjYsMjAg
QEAgdm9pZCByYWRlb25fZ3R0X2xvY2F0aW9uKHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2LCBz
dHJ1Y3QgcmFkZW9uX21jICptYykKIHsKIAl1NjQgc2l6ZV9hZiwgc2l6ZV9iZjsKIAotCXNpemVf
YWYgPSAweEZGRkZGRkZGIC0gbWMtPnZyYW1fZW5kOwotCXNpemVfYmYgPSBtYy0+dnJhbV9zdGFy
dDsKKwlzaXplX2FmID0gKCgweEZGRkZGRkZGIC0gbWMtPnZyYW1fZW5kKSArIG1jLT5ndHRfYmFz
ZV9hbGlnbikgJiB+bWMtPmd0dF9iYXNlX2FsaWduOworCXNpemVfYmYgPSBtYy0+dnJhbV9zdGFy
dCAmIH5tYy0+Z3R0X2Jhc2VfYWxpZ247CiAJaWYgKHNpemVfYmYgPiBzaXplX2FmKSB7CiAJCWlm
IChtYy0+Z3R0X3NpemUgPiBzaXplX2JmKSB7CiAJCQlkZXZfd2FybihyZGV2LT5kZXYsICJsaW1p
dGluZyBHVFRcbiIpOwogCQkJbWMtPmd0dF9zaXplID0gc2l6ZV9iZjsKIAkJfQotCQltYy0+Z3R0
X3N0YXJ0ID0gbWMtPnZyYW1fc3RhcnQgLSBtYy0+Z3R0X3NpemU7CisJCW1jLT5ndHRfc3RhcnQg
PSAobWMtPnZyYW1fc3RhcnQgJiB+bWMtPmd0dF9iYXNlX2FsaWduKSAtIG1jLT5ndHRfc2l6ZTsK
IAl9IGVsc2UgewogCQlpZiAobWMtPmd0dF9zaXplID4gc2l6ZV9hZikgewogCQkJZGV2X3dhcm4o
cmRldi0+ZGV2LCAibGltaXRpbmcgR1RUXG4iKTsKIAkJCW1jLT5ndHRfc2l6ZSA9IHNpemVfYWY7
CiAJCX0KLQkJbWMtPmd0dF9zdGFydCA9IG1jLT52cmFtX2VuZCArIDE7CisJCW1jLT5ndHRfc3Rh
cnQgPSAobWMtPnZyYW1fZW5kICsgMSArIG1jLT5ndHRfYmFzZV9hbGlnbikgJiB+bWMtPmd0dF9i
YXNlX2FsaWduOwogCX0KIAltYy0+Z3R0X2VuZCA9IG1jLT5ndHRfc3RhcnQgKyBtYy0+Z3R0X3Np
emUgLSAxOwogCWRldl9pbmZvKHJkZXYtPmRldiwgIkdUVDogJWxsdU0gMHglMDhsbFggLSAweCUw
OGxsWFxuIiwKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM0MDAuYyBiL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcnM0MDAuYwppbmRleCA5ZTQyNDBiLi5mNDU0YzlhIDEwMDY0
NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNDAwLmMKKysrIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9yczQwMC5jCkBAIC01Nyw3ICs1Nyw5IEBAIHZvaWQgcnM0MDBfZ2FydF9hZGp1
c3Rfc2l6ZShzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAl9CiAJaWYgKHJkZXYtPmZhbWls
eSA9PSBDSElQX1JTNDAwIHx8IHJkZXYtPmZhbWlseSA9PSBDSElQX1JTNDgwKSB7CiAJCS8qIEZJ
WE1FOiBSUzQwMCAmIFJTNDgwIHNlZW1zIHRvIGhhdmUgaXNzdWUgd2l0aCBHQVJUIHNpemUKLQkJ
ICogaWYgNEcgb2Ygc3lzdGVtIG1lbW9yeSAobmVlZHMgbW9yZSB0ZXN0aW5nKSAqLworCQkgKiBp
ZiA0RyBvZiBzeXN0ZW0gbWVtb3J5IChuZWVkcyBtb3JlIHRlc3RpbmcpCisJCSAqLworCQkvKiBY
WFggaXMgdGhpcyBzdGlsbCBhbiBpc3N1ZSB3aXRoIHByb3BlciBhbGlnbm1lbnQ/ICovCiAJCXJk
ZXYtPm1jLmd0dF9zaXplID0gMzIgKiAxMDI0ICogMTAyNDsKIAkJRFJNX0VSUk9SKCJGb3JjaW5n
IHRvIDMyTSBHQVJUIHNpemUgKGJlY2F1c2Ugb2YgQVNJQyBidWcgPylcbiIpOwogCX0KQEAgLTI2
Myw2ICsyNjUsNyBAQCB2b2lkIHJzNDAwX21jX2luaXQoc3RydWN0IHJhZGVvbl9kZXZpY2UgKnJk
ZXYpCiAJcjEwMF92cmFtX2luaXRfc2l6ZXMocmRldik7CiAJYmFzZSA9IChSUkVHMzIoUkFERU9O
X05CX1RPTSkgJiAweGZmZmYpIDw8IDE2OwogCXJhZGVvbl92cmFtX2xvY2F0aW9uKHJkZXYsICZy
ZGV2LT5tYywgYmFzZSk7CisJcmRldi0+bWMuZ3R0X2Jhc2VfYWxpZ24gPSByZGV2LT5tYy5ndHRf
c2l6ZSAtIDE7CiAJcmFkZW9uX2d0dF9sb2NhdGlvbihyZGV2LCAmcmRldi0+bWMpOwogCXJhZGVv
bl91cGRhdGVfYmFuZHdpZHRoX2luZm8ocmRldik7CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3JzNjAwLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JzNjAwLmMKaW5k
ZXggN2JiNGMzZS4uNmRjMTVlYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9y
czYwMC5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2MDAuYwpAQCAtNjk4LDYgKzY5
OCw3IEBAIHZvaWQgcnM2MDBfbWNfaW5pdChzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldikKIAli
YXNlID0gR18wMDAwMDRfTUNfRkJfU1RBUlQoYmFzZSkgPDwgMTY7CiAJcmRldi0+bWMuaWdwX3Np
ZGVwb3J0X2VuYWJsZWQgPSByYWRlb25fYXRvbWJpb3Nfc2lkZXBvcnRfcHJlc2VudChyZGV2KTsK
IAlyYWRlb25fdnJhbV9sb2NhdGlvbihyZGV2LCAmcmRldi0+bWMsIGJhc2UpOworCXJkZXYtPm1j
Lmd0dF9iYXNlX2FsaWduID0gMDsKIAlyYWRlb25fZ3R0X2xvY2F0aW9uKHJkZXYsICZyZGV2LT5t
Yyk7CiAJcmFkZW9uX3VwZGF0ZV9iYW5kd2lkdGhfaW5mbyhyZGV2KTsKIH0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcnM2OTAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24v
cnM2OTAuYwppbmRleCBmNGYwYTYxLi5jZTRlY2JlIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL3JzNjkwLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yczY5MC5jCkBA
IC0xNjIsNiArMTYyLDcgQEAgdm9pZCByczY5MF9tY19pbml0KHN0cnVjdCByYWRlb25fZGV2aWNl
ICpyZGV2KQogCXJzNjkwX3BtX2luZm8ocmRldik7CiAJcmRldi0+bWMuaWdwX3NpZGVwb3J0X2Vu
YWJsZWQgPSByYWRlb25fYXRvbWJpb3Nfc2lkZXBvcnRfcHJlc2VudChyZGV2KTsKIAlyYWRlb25f
dnJhbV9sb2NhdGlvbihyZGV2LCAmcmRldi0+bWMsIGJhc2UpOworCXJkZXYtPm1jLmd0dF9iYXNl
X2FsaWduID0gcmRldi0+bWMuZ3R0X3NpemUgLSAxOwogCXJhZGVvbl9ndHRfbG9jYXRpb24ocmRl
diwgJnJkZXYtPm1jKTsKIAlyYWRlb25fdXBkYXRlX2JhbmR3aWR0aF9pbmZvKHJkZXYpOwogfQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9ydjUxNS5jIGIvZHJpdmVycy9ncHUv
ZHJtL3JhZGVvbi9ydjUxNS5jCmluZGV4IDdkOWE3YjAuLjBjOWMxNjkgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcnY1MTUuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3J2NTE1LmMKQEAgLTE5NSw2ICsxOTUsNyBAQCB2b2lkIHJ2NTE1X21jX2luaXQoc3RydWN0IHJh
ZGVvbl9kZXZpY2UgKnJkZXYpCiAJcnY1MTVfdnJhbV9nZXRfdHlwZShyZGV2KTsKIAlyMTAwX3Zy
YW1faW5pdF9zaXplcyhyZGV2KTsKIAlyYWRlb25fdnJhbV9sb2NhdGlvbihyZGV2LCAmcmRldi0+
bWMsIDApOworCXJkZXYtPm1jLmd0dF9iYXNlX2FsaWduID0gMDsKIAlpZiAoIShyZGV2LT5mbGFn
cyAmIFJBREVPTl9JU19BR1ApKQogCQlyYWRlb25fZ3R0X2xvY2F0aW9uKHJkZXYsICZyZGV2LT5t
Yyk7CiAJcmFkZW9uX3VwZGF0ZV9iYW5kd2lkdGhfaW5mbyhyZGV2KTsKLS0gCjEuNy4xLjEKCg==
--0015174c3c86351e18048b6058a4--
