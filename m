Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab0IXTMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:12:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43724 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517Ab0IXTML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:12:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=X1GSC5eThljGdkbjtc2CJ/2MVP1SkMFYZ44p+Fl9VsOi5lE+rgS9yxrZaaTk21MhkY
         kClMbbY8b7AMsqCAW9PEhLyo7U+aO52xLTcCnv44rKclIDLZj2EET0lPMtb28XmdURFV
         3CPuIiRwAvhYUrA28zd4oBed9f0xK0HmyEVJo=
MIME-Version: 1.0
In-Reply-To: <1285189645.14364.55.camel@morgan.silverblock.net>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
	<AANLkTikj4biBS7wQsRM6o3kEmyaPNMaSUBEktMmmOy89@mail.gmail.com>
	<1285023750.30856.99.camel@morgan.silverblock.net>
	<AANLkTi=RCJcQMSWMm6pQgJnJZT9TyfGyFtWmeu8GKHA-@mail.gmail.com>
	<1285090202.19131.77.camel@morgan.silverblock.net>
	<AANLkTi=h=9mvdLMcZZAtg3_eu7wD2Yj0Dn2iWjhF7BiL@mail.gmail.com>
	<AANLkTi=2E4LqbFKd6fq+dn3q+fau1Zt+-4nuigv7VA45@mail.gmail.com>
	<1285189645.14364.55.camel@morgan.silverblock.net>
Date: Fri, 24 Sep 2010 15:12:09 -0400
Message-ID: <AANLkTin1WF86M0D9qMGb47SghJG7D_dnsBUgmCt3kirH@mail.gmail.com>
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS polling
From: Alex Deucher <alexdeucher@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jon Smirl <jonsmirl@gmail.com>,
        =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: multipart/mixed; boundary=001636c5addcc71958049106271f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5addcc71958049106271f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 22, 2010 at 5:07 PM, Andy Walls <awalls@md.metrocast.net> wrote=
:
> On Wed, 2010-09-22 at 09:33 -0400, Jon Smirl wrote:
>> On Wed, Sep 22, 2010 at 1:30 AM, Alex Deucher <alexdeucher@gmail.com> wr=
ote:
>> > On Tue, Sep 21, 2010 at 1:30 PM, Andy Walls <awalls@md.metrocast.net> =
wrote:
>> >> On Tue, 2010-09-21 at 00:26 -0400, Alex Deucher wrote:
>> >>> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
>> >>> > On Mon, 2010-09-20 at 20:29 +0200, Rafa=C5=82 Mi=C5=82ecki wrote:
>> >>> >> 2010/9/20 Andy Walls <awalls@md.metrocast.net>:
>
>> >> The real problem to me is that the radeon and drm modules have a sing=
le,
>> >> standard way of dealing with EDID errors. =C2=A0However, EDID errors =
can
>> >> happen due to a number of different causes, some of which are externa=
l
>> >> (i.e. in the LCD or CRT monitor). =C2=A0Given that, there really is n=
o "right
>> >> thing" the drivers can do without input from the user on what the pol=
icy
>> >> should be when a bad EDID is detected.
>>
>> Andy, this sure looks like a broken VBIOS to me.
>
> Well sure.
>
> But that problem causes other problems in error handling code paths to
> surface. =C2=A0It also brings to light that there are some cases that are
> undecidable, or not worth the effort, for the error handling code paths
> on what the proper action should be.
>
>
>> =C2=A0First thing would be
>> to update your VBIOS if possible to get a correct table for your
>> hardware.
>
> Um, no.
>
> I will not risk taking an operational machine down due to flash write
> failure, however small the probability, due to the high impact.
> The reward of shutting up kernel error messages, is not worth the risk.
>
>
>> =C2=A0Second would be to add a quirk in the kernel.
>
> I have expressed my thoughts on quirks in a previous post.
>
>
>> There are lots of cases where the kernel does odd things when the BIOS
>> feeds it bad information. Do we really want hundreds of switches in
>> sysfs allowing adjustments for broken BIOS features?
>
> I see very little downside in giving the user more control over his
> system. =C2=A0A thousand knobs and switches are worth it for the user, fo=
r
> the one switch that is there when the user needs it to solve a problem.
>
> To dump my VBIOS ROM for Alex, I could have hacked up the radeon driver
> to dump the ROM. =C2=A0That would have consumed a lot of time. =C2=A0Luck=
ily for
> me, there was a switch to turn on the ROM and dump it:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0# echo 1 > /sys/class/drm/card0/device/rom
> =C2=A0 =C2=A0 =C2=A0 =C2=A0# dd if=3D/sys/class/drm/card0/device/rom of=
=3Dmsi7302igprom.bin
> =C2=A0 =C2=A0 =C2=A0 =C2=A0# echo 0 > /sys/class/drm/card0/device/rom
>
> I never used it before and will likely never use it again. =C2=A0But when=
 I
> had a problem I needed to solve, its availability made the solution
> simple and efficient. =C2=A0Time to accomplish tasks is my scarcest resou=
rce;
> time efficiency is very important to me.
>


The attached patch should fix up your board.  Let me know if it works for y=
ou.

Thanks,

Alex


>
> The only downside to hundreds of switches and control knobs I can really
> think of is possibly complexity for the end user. =C2=A0But it turns out,
> that ignoring the available controls, or ignoring large subsets of the
> available controls, is how people are going to deal with that
> complexity. =C2=A0Heck, I ignore most of sysfs almost all the time. =C2=
=A0I also
> ignore almost every module option available. =C2=A0My system runs fine
> without me caring about a majority of the existing switches.
>
>
> BTW, we already have thousands of switches and controls for kernel
> internals in linux without sysfs and ioctl()'s:
>
> $ find /lib/modules/`uname -r` -name "*.ko" -exec modinfo {} \; | grep '^=
parm:' | wc -l
> 3387
>
> Why do we have that many? =C2=A0They are low cost in complexity, as they =
can
> easily be ignored. =C2=A0They are high value in utility, as they give the
> user control over his system to deal with unusual circumstances.
>
> </rant>
>
>
>
>
>> =C2=A0We already have
>> the quirk scheme for addressing this.
>>
>> A simpler solution for reducing the log spam would be to only report
>> the error once, instead of every 10 seconds. The driver could remember
>> it has made the error report and then log another message later if the
>> error was cleared.
>
> My sysfs implementation was only 69 changed lines in one file:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0drivers/gpu/drm/drm_sysfs.c =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | =C2=A0 69 +++++++++++
>
> I doubt a solution to add logic to the error paths, to try and divine
> all the sources of EDID errors by saving state and applying rules to
> take the correct action, is going to be less change than that. =C2=A0I kn=
ow
> more than one file will have to change.
>
> Regards,
> Andy
>
>

--001636c5addcc71958049106271f
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-add-quirk-for-MSI-K9A2GM-motherboard.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-add-quirk-for-MSI-K9A2GM-motherboard.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gehfh5al0

RnJvbSAwMDMxYTZiMDc3YThmODFlZDY4MGUyYzFkYzY2YmRkZTczZGRhNzJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogRnJpLCAyNCBTZXAgMjAxMCAxNTowODo0NCAtMDQwMApTdWJqZWN0OiBbUEFUQ0hdIGRy
bS9yYWRlb24va21zOiBhZGQgcXVpcmsgZm9yIE1TSSBLOUEyR00gbW90aGVyYm9hcmQKCkJvYXJk
IGhhcyBubyBkaWdpdGFsIGNvbm5lY3RvcnMKClJlcG9ydGVkLWJ5OiBBbmR5IFdhbGxzIDxhd2Fs
bHNAbWQubWV0cm9jYXN0Lm5ldD4KU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4ZGV1
Y2hlckBnbWFpbC5jb20+CkNjOiBzdGFibGVAa2VybmVsLm9yZwotLS0KIGRyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcmFkZW9uX2F0b21iaW9zLmMgfCAgICA5ICsrKysrKysrKwogMSBmaWxlcyBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXRvbWJpb3MuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vcmFkZW9uX2F0b21iaW9zLmMKaW5kZXggZWJhZTE0Yy4uNjg5MzJiYSAxMDA2NDQKLS0tIGEv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fYXRvbWJpb3MuYworKysgYi9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3JhZGVvbl9hdG9tYmlvcy5jCkBAIC0zMTcsNiArMzE3LDE1IEBAIHN0YXRp
YyBib29sIHJhZGVvbl9hdG9tX2FwcGx5X3F1aXJrcyhzdHJ1Y3QgZHJtX2RldmljZSAqZGV2LAog
CQkJKmNvbm5lY3Rvcl90eXBlID0gRFJNX01PREVfQ09OTkVDVE9SX0RWSUQ7CiAJfQogCisJLyog
TVNJIEs5QTJHTSBWMi9WMyBib2FyZCBoYXMgbm8gSERNSSBvciBEVkkgKi8KKwlpZiAoKGRldi0+
cGRldi0+ZGV2aWNlID09IDB4Nzk2ZSkgJiYKKwkgICAgKGRldi0+cGRldi0+c3Vic3lzdGVtX3Zl
bmRvciA9PSAweDE0NjIpICYmCisJICAgIChkZXYtPnBkZXYtPnN1YnN5c3RlbV9kZXZpY2UgPT0g
MHg3MzAyKSkgeworCQlpZiAoKHN1cHBvcnRlZF9kZXZpY2UgPT0gQVRPTV9ERVZJQ0VfREZQMl9T
VVBQT1JUKSB8fAorCQkgICAgKHN1cHBvcnRlZF9kZXZpY2UgPT0gQVRPTV9ERVZJQ0VfREZQM19T
VVBQT1JUKSkKKwkJCXJldHVybiBmYWxzZTsKKwl9CisKIAkvKiBhLWJpdCBmLWk5MGhkIC0gY2lh
cmFubSBvbiAjcmFkZW9uaGQgLSB0aGlzIGJvYXJkIGhhcyBubyBEVkkgKi8KIAlpZiAoKGRldi0+
cGRldi0+ZGV2aWNlID09IDB4Nzk0MSkgJiYKIAkgICAgKGRldi0+cGRldi0+c3Vic3lzdGVtX3Zl
bmRvciA9PSAweDE0N2IpICYmCi0tIAoxLjcuMS4xCgo=
--001636c5addcc71958049106271f--
