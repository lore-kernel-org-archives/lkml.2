Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab0GTRVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 13:21:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63852 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0GTRVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 13:21:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Yqn4uic9blbcv3FhV/6oTN0y+JqMY3Y//RE9ogdCNEgVhgvtK2/4JpRU4RRiR19Z5K
         WdwW8IKXx4Ybexq68JRprAP+Ew9eaN2P7WmQNv8tjBEVLgA9u6YxevBZ54vUA6XZo4cm
         YnyzbG8rPuTFTD4ZtIlYZ7vYX1g/t7fz3PkoA=
MIME-Version: 1.0
In-Reply-To: <AANLkTiljMvaCttFAI_GoajBHwK9OHS5MPmx1P6_qDOdY@mail.gmail.com>
References: <AANLkTim3VQ7afK91Opco06jzHJ35hHfn13heiXUp7YJ2@mail.gmail.com>
	<AANLkTimAUG9DZpCyFBgf_XV9asj7ClBe2Lrjkh8tM0ll@mail.gmail.com>
	<AANLkTikQ5GE4Ob1IAakEiwyWEGKTAL8Uox12jsSusJJl@mail.gmail.com>
	<AANLkTik87QXCEHgG8ph6ehfFo1yvCvRz7JbvaC_uKWJd@mail.gmail.com>
	<AANLkTiljMvaCttFAI_GoajBHwK9OHS5MPmx1P6_qDOdY@mail.gmail.com>
Date: Tue, 20 Jul 2010 13:21:46 -0400
Message-ID: <AANLkTimuBRwuD0MjtzZyd--2JSUfWejuYb7t-GE6oK3T@mail.gmail.com>
Subject: Re: Blank (disconnected) screen during boot with latest 2.6.35-rcX 
	kernels
From: Alex Deucher <alexdeucher@gmail.com>
To: trapdoor6@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, xorg-driver-ati@lists.x.org,
        trapDoor <trapdoor6@googlemail.com>
Content-Type: multipart/mixed; boundary=0016e6d2820d702e0c048bd4eb28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d2820d702e0c048bd4eb28
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 20, 2010 at 12:47 PM, trapDoor <trapdoor6@gmail.com> wrote:
> Hi Alex,
>
>>
>> Probably the oem made two similar boards one with dual DVI and one
>> with DVI + VGA + HDMI and used the same connector table since the
>> encoder routing is still correct even if the connectors are named
>> wrong. =A0We can add a quirk to fix it.
>>
>
> I plugged my monitor into the other (white) DVI port and now system
> recognises it as DVI:
>
> [ =A0 =A018.418] (II) RADEON(0): Output HDMI-0 disconnected
> [ =A0 =A018.418] (II) RADEON(0): Output VGA-0 disconnected
> [ =A0 =A018.418] (II) RADEON(0): Output DIN disconnected
> [ =A0 =A018.418] (II) RADEON(0): Output DVI-0 connected
>
> As I mentioned before, I guess that on my card HDMI signal is
> supported only on the yellow DVI port (through DVI > HDMI adapter),
> and even if a device is connected to it directly the system will still
> recognise it as HDMI.
>
>>
>> So the patch fixes the issue? =A0I'll send it on then. =A0Looks like you=
r
>> systems needs a connector table quirk. =A0Can you send me the pci ids
>> for your GPU (lspci -vnn) and a copy of your vbios? =A0To dump your
>> vbios (as root):
>> cd /sys/bus/pci/devices/<pci bus id>
>> echo 1 > rom
>> cat rom > /tmp/vbios.rom
>> echo 0 > rom
>>
>
> Yes, I confirm it does fix it.

Good.

> Full lspci output attached and below pasting what's related to my graphic=
s card:
> --------------
> 04:00.0 VGA compatible controller [0300]: ATI Technologies Inc
> Mobility Radeon HD 3600 Series [1002:9598]
> =A0 =A0 =A0 =A0Subsystem: ASUSTeK Computer Inc. Device [1043:01e4]
> =A0 =A0 =A0 =A0Flags: bus master, fast devsel, latency 0, IRQ 43
> =A0 =A0 =A0 =A0Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
> =A0 =A0 =A0 =A0Memory at fbfe0000 (64-bit, non-prefetchable) [size=3D64K]
> =A0 =A0 =A0 =A0I/O ports at e000 [size=3D256]
> =A0 =A0 =A0 =A0Expansion ROM at fbfc0000 [disabled] [size=3D128K]
> =A0 =A0 =A0 =A0Capabilities: <access denied>
> =A0 =A0 =A0 =A0Kernel driver in use: radeon
>
> 04:00.1 Audio device [0403]: ATI Technologies Inc RV635 Audio device
> [Radeon HD 3600 Series] [1002:aa20]
> =A0 =A0 =A0 =A0Subsystem: ASUSTeK Computer Inc. Device [1043:aa20]
> =A0 =A0 =A0 =A0Flags: bus master, fast devsel, latency 0, IRQ 45
> =A0 =A0 =A0 =A0Memory at fbffc000 (64-bit, non-prefetchable) [size=3D16K]
> =A0 =A0 =A0 =A0Capabilities: <access denied>
> =A0 =A0 =A0 =A0Kernel driver in use: HDA Intel
> --------------
>
> Vbios dump for bus ID 0000:04:00.0 attached.
>

The attached patch should fix the connectors to report properly.
There are a number of similar ASUS cards with the same quirk.

>>
>> As to the performance regressions, 2.6.35 added proper support for the
>> glx vblank stuff, so you are likely seeing apps synchronized to the
>> vrefresh.
>>
>
> I guess you were referring to the glxgears 'test tool' that used to
> show (before 2.6.35-rc) much higher number of fps than it does now
> when it corresponds to vertical-refresh like it's supposed to. I
> noticed the change and assumed it is correct. And I never considered
> glxgears as a proper performance test anyway so I wouldn't rely on the
> results it gives.
>
> Where I see a real 3D performance drop now is for example Armagetron
> Advanced - a game I use just for testing. I enabled certain features
> using 3D in it. Without going into details I just say that with kernel
> 2.6.34.1 the overall 3D performance in AA is about twice better. The
> game runs quite smooth, number of fps doesn't go under 60. With kernel
> 2.6.35-rc5-git3 on the same system, with the same drivers, mesa, drm
> etc., the game runs slower and not so smooth, certain details look
> slightly worse and I won't get more than 35 fps.
>
> Apart from that I don't notice any regressions on my desktop, with
> compiz effects etc. I'd run some other tests if you could recommend
> some tools, but not too complex and rather some specialised software
> just for testing purposes, not games.

If it's just the kernel that changed is there any chance you could
bisect what caused the performance regression?

Alex

--0016e6d2820d702e0c048bd4eb28
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-add-quirk-for-ASUS-HD-3600-board.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-add-quirk-for-ASUS-HD-3600-board.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gbv0evjg2

RnJvbSBlYmRmZmMzODZmYzNkOTBmMjE4NWU5NWQ5NDI5MjQ4MTUxOTM5YzZlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogVHVlLCAyMCBKdWwgMjAxMCAxMzoxNTozNyAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBhZGQgcXVpcmsgZm9yIEFTVVMgSEQgMzYwMCBib2FyZAoKQ29ubmVjdG9y
IGlzIGFjdHVhbGx5IERWSSByYXRoZXIgdGhhbiBIRE1JLgoKUmVwb3J0ZWQtYnk6IHRyYXBEb29y
IDx0cmFwZG9vcjZAZ21haWwuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbGV4IERldWNoZXIgPGFsZXhk
ZXVjaGVyQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hdG9t
Ymlvcy5jIHwgICAgOSArKysrKysrKysKIDEgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCsp
LCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFk
ZW9uX2F0b21iaW9zLmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9hdG9tYmlvcy5j
CmluZGV4IDNmODljOWIuLjBhOTdhZWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vcmFkZW9uX2F0b21iaW9zLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25f
YXRvbWJpb3MuYwpAQCAtMjgwLDYgKzI4MCwxNSBAQCBzdGF0aWMgYm9vbCByYWRlb25fYXRvbV9h
cHBseV9xdWlya3Moc3RydWN0IGRybV9kZXZpY2UgKmRldiwKIAkJfQogCX0KIAorCS8qIEFTVVMg
SEQgMzYwMCBib2FyZCBsaXN0cyB0aGUgRFZJIHBvcnQgYXMgSERNSSAqLworCWlmICgoZGV2LT5w
ZGV2LT5kZXZpY2UgPT0gMHg5NTk4KSAmJgorCSAgICAoZGV2LT5wZGV2LT5zdWJzeXN0ZW1fdmVu
ZG9yID09IDB4MTA0MykgJiYKKwkgICAgKGRldi0+cGRldi0+c3Vic3lzdGVtX2RldmljZSA9PSAw
eDAxZTQpKSB7CisJCWlmICgqY29ubmVjdG9yX3R5cGUgPT0gRFJNX01PREVfQ09OTkVDVE9SX0hE
TUlBKSB7CisJCQkqY29ubmVjdG9yX3R5cGUgPSBEUk1fTU9ERV9DT05ORUNUT1JfRFZJSTsKKwkJ
fQorCX0KKwogCS8qIEFTVVMgSEQgMzQ1MCBib2FyZCBsaXN0cyB0aGUgRFZJIHBvcnQgYXMgSERN
SSAqLwogCWlmICgoZGV2LT5wZGV2LT5kZXZpY2UgPT0gMHg5NUM1KSAmJgogCSAgICAoZGV2LT5w
ZGV2LT5zdWJzeXN0ZW1fdmVuZG9yID09IDB4MTA0MykgJiYKLS0gCjEuNy4xLjEKCg==
--0016e6d2820d702e0c048bd4eb28--
