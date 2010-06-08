Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab0FHDJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:09:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53066 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0FHDJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:09:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=l7bI41EfWypsBMWxfJUTHZb2hLY6V6FquKol1pnFND2SPX68USjzDrxoMs2tlpb2Jo
         ApJl+6bfOqECu15l/3h1rs5qsksyaMfXN4N1m2BRlrciCX/kOMQHzk0iUbZnACeItlZ7
         4pfodo7mYEzUm1YWHye0RZN6nrFRYby38RjAY=
MIME-Version: 1.0
In-Reply-To: <AANLkTinUe_IF7riVYpCFpciM6-ngudDR8UZ6FiaJBkk3@mail.gmail.com>
References: <AANLkTikEGSZUBy8VZOIUhA8iAPa5p7r9vmN47hiEwSB8@mail.gmail.com>
	<AANLkTinUe_IF7riVYpCFpciM6-ngudDR8UZ6FiaJBkk3@mail.gmail.com>
Date: Tue, 8 Jun 2010 13:09:41 +1000
Message-ID: <AANLkTinvrzcSrjoGCZHUGLq0-qt-1mDM0494j5mES5tX@mail.gmail.com>
Subject: Re: radeon blink during probe regression (was Re: Linux 2.6.35-rc2)
From: Dave Airlie <airlied@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016368e30e5d145e104887c1eff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016368e30e5d145e104887c1eff
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 8, 2010 at 11:50 AM, Alex Deucher <alexdeucher@gmail.com> wrote=
:
> On Mon, Jun 7, 2010 at 8:49 PM, Dave Airlie <airlied@gmail.com> wrote:
>> (changing subject
>>
>> On Tue, Jun 8, 2010 at 3:28 AM, Torsten Kaiser
>> <just.for.lkml@googlemail.com> wrote:
>>> On Mon, Jun 7, 2010 at 8:52 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>> On Mon, Jun 7, 2010 at 4:32 PM, Alex Deucher <alexdeucher@gmail.com> w=
rote:
>>>>> On Mon, Jun 7, 2010 at 2:22 AM, Dave Airlie <airlied@gmail.com> wrote=
:
>>>>>> On Mon, Jun 7, 2010 at 4:09 PM, Torsten Kaiser
>>>>>> <just.for.lkml@googlemail.com> wrote:
>>>>>>> The switchoff intervall is ~10 seconds, not 1..2 as I guessed in th=
e first mail.
>>>>>>> Any idea if there is something in the KMS code that triggers at thi=
s intervall?
>>>>>>
>>>>>> The new mode probing code happens every 10 seconds, though we
>>>>>> shouldn't be turning anything on or off with it.
>>>>>>
>>>>>> So I suspect the DAC detection table might be doing bad things on yo=
ur
>>>>>> hardware, we have had a problem where the dac detect table on one DA=
C
>>>>>> would turn the other one off which clearly wasn't what we wanted to
>>>>>> see.
>>>>>> ,
>>>>>
>>>>> The x300 is a non-atom card, so it uses the legacy load detection
>>>>> routines which do mess with some of the crtc regs.
>>>>>
>>>>
>>>> Okay I see it now, I'm amazed that I was seeing this issue last week
>>>> and blaming it on something complete different and only seeing it on
>>>> one card.
>>>>
>>>> I expect its the same problem I'll try and track down a proper fix for
>>>> it tomorrow.
>>>
>>> It really seems to be this polling code.
>>> After the fix to drivers/char/vt.c the 2.6.35-rc2 kernel now works for
>>> me without crashing.
>>>
>>> I also changed #define DRM_OUTPUT_POLL_PERIOD (10*HZ) to
>>> #define DRM_OUTPUT_POLL_PERIOD (3*HZ) and now the flickering before X
>>> starts is at a three second interval. That should prove, that the
>>> polling from drm_crtc_helper.c is the cause.
>>>
>>> After X starts the LCD is stable, but the secondary CRT still flickers
>>> every 3 seconds.
>>>
>>> My hardware is an X300-PCIe card with a VGA-, a DVI-I- and a video outp=
ut.
>>> I have a 1280x1024 LCD attached to the DVI-I and an old CRT to the
>>> VGA. The video output is unused.
>>> The CRT is normally switched off, but its still detected correctly.
>>>
>>> The kernel output from 2.6.34 and 2.6.35-rc2 is here:
>>> http://lkml.org/lkml/2010/6/6/126
>>>
>>> xrandr says:
>>> Screen 0: minimum 320 x 200, current 2080 x 1024, maximum 4096 x 4096
>>> DVI-0 connected 1280x1024+0+0 (normal left inverted right x axis y
>>> axis) 338mm x 270mm
>>> =A0 1280x1024 =A0 =A0 =A060.0*+ =A0 75.0
>>> =A0 1280x960 =A0 =A0 =A0 60.0
>>> =A0 1152x864 =A0 =A0 =A0 75.0
>>> =A0 1024x768 =A0 =A0 =A0 75.1 =A0 =A0 70.1 =A0 =A0 60.0
>>> =A0 832x624 =A0 =A0 =A0 =A074.6
>>> =A0 800x600 =A0 =A0 =A0 =A072.2 =A0 =A0 75.0 =A0 =A0 60.3 =A0 =A0 56.2
>>> =A0 640x480 =A0 =A0 =A0 =A072.8 =A0 =A0 75.0 =A0 =A0 66.7 =A0 =A0 60.0
>>> =A0 720x400 =A0 =A0 =A0 =A070.1
>>> =A0 640x400 =A0 =A0 =A0 =A070.0
>>> VGA-0 connected 800x600+1280+150 (normal left inverted right x axis y
>>> axis) 280mm x 210mm
>>> =A0 800x600 =A0 =A0 =A0 =A072.2*+ =A0 75.0 =A0 =A0 60.3 =A0 =A0 56.2
>>> =A0 1280x1024 =A0 =A0 =A060.0
>>> =A0 1024x768 =A0 =A0 =A0 75.1 =A0 =A0 70.1 =A0 =A0 60.0
>>> =A0 640x480 =A0 =A0 =A0 =A072.8 =A0 =A0 75.0 =A0 =A0 60.0
>>> =A0 720x400 =A0 =A0 =A0 =A087.8 =A0 =A0 70.1
>>> S-video disconnected (normal left inverted right x axis y axis)
>>>
>>> If you have something for me to try, just send it. :-)
>>>
>>> Torsten
>>>
>>
>> Okay here is a patch that seems to work on my test system, but I want
>> to give it a bit more playing around with before I sent it onwards.
>>
>> Alex, seem sane to you?
>
> Seems sane.
>

While discussing this with Alex we realised this code should never
have been reached so it showed a bug higher up.

Looks like we were defining i2c lines for tv-out which doesn't have
any, the attached patch makes sure the tv-out on legacy radeon hw
doesn't get an i2c line attach so doesn't trigger the polling on it.

Torsten can you test this patch instead of the previous one, though I
think I'll send both to Linus for safety sakes.

Dave.

--0016368e30e5d145e104887c1eff
Content-Type: application/mbox; 
	name="0001-drm-radeon-reset-i2c-valid-to-avoid-incorrect-tv-out.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-reset-i2c-valid-to-avoid-incorrect-tv-out.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ga65d37c0

RnJvbSBkZTY3MDYyYjdlZDg4NzY2YzJmMTQxZWNkMTNjYmM1NTAzMWNjMGQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpEYXRl
OiBUdWUsIDggSnVuIDIwMTAgMTM6MDQ6NTAgKzEwMDAKU3ViamVjdDogW1BBVENIXSBkcm0vcmFk
ZW9uOiByZXNldCBpMmMgdmFsaWQgdG8gYXZvaWQgaW5jb3JyZWN0IHR2LW91dCBwb2xsaW5nLgoK
V2UgcmVhbGx5IGRvbid0IHdhbnQgdG8gYmUgcG9sbGluZyB0di1vdXQgYnV0IHNpbmNlIHdlIHdl
cmVuJ3QgZm9yY2luZyB0aGUKaTJjIGxpbmVzIHRvIGludmFsaWQgKHR2LW91dCBoYXMgbm8gRERD
KSwgd2Ugd2VyZSBhZGRpbmcgdHYgY29ubmVjdG9ycyB0byB0aGUKcG9sbGluZyBzZXR1cCBhbmQg
dGhpcyB3YXMgY2F1c2luZyBibGlua2luZyBvbiBzZWNvbmRhcnkgZGlzcGxheXMuCgpUaGlzIG1h
eSBhbHNvIGZpeCB0aGUgcmVncmVzc2lvbiBUb3JzdGVuIHJlcG9ydGVkLgoKUmVwb3J0ZWQtYnk6
IFRvcnN0ZW4gS2Fpc2VyIDxqdXN0LmZvci5sa21sQGdvb2dsZW1haWwuY29tPgpTaWduZWQtb2Zm
LWJ5OiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgotLS0KIGRyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcmFkZW9uX2NvbWJpb3MuYyB8ICAgIDIgKysKIDEgZmlsZXMgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9yYWRlb24vcmFkZW9uX2NvbWJpb3MuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9u
X2NvbWJpb3MuYwppbmRleCBmNmY5MDdlLi4xYmVlMmY5IDEwMDY0NAotLS0gYS9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL3JhZGVvbl9jb21iaW9zLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9yYWRlb25fY29tYmlvcy5jCkBAIC0yMDI2LDYgKzIwMjYsNyBAQCBib29sIHJhZGVvbl9nZXRf
bGVnYWN5X2Nvbm5lY3Rvcl9pbmZvX2Zyb21fYmlvcyhzdHJ1Y3QgZHJtX2RldmljZSAqZGV2KQog
CQkJCQljb21iaW9zX3NldHVwX2kyY19idXMocmRldiwgUkFERU9OX0dQSU9fQ1JUMl9EREMpOwog
CQkJCWJyZWFrOwogCQkJZGVmYXVsdDoKKwkJCQlkZGNfaTJjLnZhbGlkID0gZmFsc2U7CiAJCQkJ
YnJlYWs7CiAJCQl9CiAKQEAgLTIzMzksNiArMjM0MCw3IEBAIGJvb2wgcmFkZW9uX2dldF9sZWdh
Y3lfY29ubmVjdG9yX2luZm9fZnJvbV9iaW9zKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpCiAJCQlp
ZiAoUkJJT1M4KHR2X2luZm8gKyA2KSA9PSAnVCcpIHsKIAkJCQlpZiAocmFkZW9uX2FwcGx5X2xl
Z2FjeV90dl9xdWlya3MoZGV2KSkgewogCQkJCQlocGQuaHBkID0gUkFERU9OX0hQRF9OT05FOwor
CQkJCQlkZGNfaTJjLnZhbGlkID0gZmFsc2U7CiAJCQkJCXJhZGVvbl9hZGRfbGVnYWN5X2VuY29k
ZXIoZGV2LAogCQkJCQkJCQkgIHJhZGVvbl9nZXRfZW5jb2Rlcl9pZAogCQkJCQkJCQkgIChkZXYs
Ci0tIAoxLjcuMC4xCgo=
--0016368e30e5d145e104887c1eff--
