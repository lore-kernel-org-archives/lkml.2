Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1HXKRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:17:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659Ab1HXKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:17:12 -0400
MIME-Version: 1.0
In-Reply-To: <CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com>
References: <48dnn9u5x3e4qoh8meht42xk.1313966177259@email.android.com>
	<4E527684.3020206@draigBrady.com>
	<20110822161914.GA9399@redhat.com>
	<CACV3sbJjDhzKq8YQEnrTQPVVw7YsZjLe45G5sWaMRBk3+Vxkcg@mail.gmail.com>
Date: Wed, 24 Aug 2011 18:17:10 +0800
Message-ID: <CACV3sbLJFwajVQuYfAYW9mt6tm8zeMa-ctKGyGq+qnXtWxFeCA@mail.gmail.com>
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
From: Jovi Zhang <bookjovi@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: =?UTF-8?Q?P=C3=A1draig_Brady?= <P@draigbrady.com>,
        Neil Horman <nhorman@tuxdriver.com>, dhowells@redhat.com,
        roland@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=00151747b9ea82541104ab3d9d2f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151747b9ea82541104ab3d9d2f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 24, 2011 at 6:14 PM, Jovi Zhang <bookjovi@gmail.com> wrote:
> 2011/8/23 Oleg Nesterov <oleg@redhat.com>:
>> On 08/22, P=C3=A1draig Brady wrote:
>>>
>>> On 08/21/2011 11:36 PM, Neil Horman wrote:
>>> > Concur. =C2=A0The comment should be changed
>>> > Neil
>>> >
>>> > Oleg Nesterov <oleg@redhat.com> wrote:
>>> >
>>> >> On 08/21, Oleg Nesterov wrote:
>>> >>>
>>> >>> On 08/21, bookjovi@gmail.com wrote:
>>> >>>>
>>> >>>> For non-pipe case, limit 0 also means drop the coredump, so just p=
ut
>>> >>>> the zero limit check at do_coredump function begining.
>>> >>>
>>> >>> Neil, what do you think? Should we change the code or the comment?
>>> >>
>>> >> Personally I think we should fix the comment. I think RLIMIT_CORE
>>> >> doesn't apply in this case, limit =3D=3D 1 check is very special. An=
d
>>> >> this is what linux always did, except between 725eae32 and 898b374a.
>>>
>>> Sorry for jumping in late here.
>>> I would really like `ulimit -c 0` to completely disable core dumps,
>>> including not running core_pattern, as I also mentioned here:
>>> https://bugs.launchpad.net/ubuntu/+source/apport/+bug/62511
>>> I noticed this in a script where ctrl-\ was taking a long
>>> time to be registered as the core_pattern was run unconditionally.
>>
>> May be. As I said, I do not really know and personally I agree with
>> everything. My only point was, this is not the bug, this is what we
>> always did.
>>
>> This is up to Neil, I think.
>>
>> Oleg.
>>
>>
> Well, so here have two questions.
> 1) That comments "but a limit of 0 skips the dump" definitely is wrong
> right now, it don't match with reality.
> 2) In ispipe case, core limit 0 should skip the dump or not? this need
> more discussion.
> =C2=A0 =C2=A0from pipe coredump point of view, core limit is irrelevant, =
it
> doesn't write to file system.
> =C2=A0 =C2=A0from user point of view, there will be a lot of core files i=
f we
> let core limit 0 create core file, user might be boring.
>
> I fix the comments part by below patch(thanks Oleg's comments), please
> use attachment patch when merge.
>

Patch attached.

--00151747b9ea82541104ab3d9d2f
Content-Type: application/octet-stream; 
	name="0001-coredump-fix-wrong-comments-on-core-limits-of-pipe-c.patch"
Content-Disposition: attachment; 
	filename="0001-coredump-fix-wrong-comments-on-core-limits-of-pipe-c.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grq5ex6b0

RnJvbSBkYzdiMDJhMWUwZTQxM2ZiOTZkMjJmMWQ0ZWY0ZGE5ODExNWNmYjlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKb3ZpIFpoYW5nIDxib29ram92aUBnbWFpbC5jb20+CkRhdGU6
IFdlZCwgMTcgQXVnIDIwMTEgMTU6MzQ6MjkgKzA4MDAKU3ViamVjdDogW1BBVENIXSBjb3JlZHVt
cDogZml4IHdyb25nIGNvbW1lbnRzIG9uIGNvcmUgbGltaXRzIG9mIHBpcGUgY29yZWR1bXAgY2Fz
ZQoKSW4gY29tbWl0IDg5OGIzNzRhLCBjb3JlIGxpbWl0cyByZWN1cnNpdmUgY2hlY2sgdmF1bGUg
Y2hhbmdlZCBmcm9tIDAgdG8gMSwKYnV0IHRoZSBjb3JyZXNwb25kaW5nIGNvbW1lbnRzIHdhcyBu
b3QgY2hhbmdlZCBjb3JyZWN0bHkuCgpTaWduZWQtb2ZmLWJ5OiBKb3ZpIFpoYW5nIDxib29ram92
aUBnbWFpbC5jb20+CkNjOiBPbGVnIE5lc3Rlcm92IDxvbGVnQHJlZGhhdC5jb20+CkNjOiBOZWls
IEhvcm1hbiA8bmhvcm1hbkB0dXhkcml2ZXIuY29tPgotLS0KIGZzL2V4ZWMuYyB8ICAgMTUgKysr
KysrKystLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9mcy9leGVjLmMgYi9mcy9leGVjLmMKaW5kZXggMjVkY2JlNS4u
YmE0OTNjYyAxMDA2NDQKLS0tIGEvZnMvZXhlYy5jCisrKyBiL2ZzL2V4ZWMuYwpAQCAtMjE1OCwx
NSArMjE1OCwxNiBAQCB2b2lkIGRvX2NvcmVkdW1wKGxvbmcgc2lnbnIsIGludCBleGl0X2NvZGUs
IHN0cnVjdCBwdF9yZWdzICpyZWdzKQogCQl9CiAKIAkJaWYgKGNwcm0ubGltaXQgPT0gMSkgewot
CQkJLyoKKwkJCS8qIFNlZSB1bWhfcGlwZV9zZXR1cCgpIHdoaWNoIHNldHMgUkxJTUlUX0NPUkUg
PSAxLgorCQkJICoKIAkJCSAqIE5vcm1hbGx5IGNvcmUgbGltaXRzIGFyZSBpcnJlbGV2YW50IHRv
IHBpcGVzLCBzaW5jZQogCQkJICogd2UncmUgbm90IHdyaXRpbmcgdG8gdGhlIGZpbGUgc3lzdGVt
LCBidXQgd2UgdXNlCi0JCQkgKiBjcHJtLmxpbWl0IG9mIDEgaGVyZSBhcyBhIHNwZWFjaWFsIHZh
bHVlLiBBbnkKLQkJCSAqIG5vbi0xIGxpbWl0IGdldHMgc2V0IHRvIFJMSU1fSU5GSU5JVFkgYmVs
b3csIGJ1dAotCQkJICogYSBsaW1pdCBvZiAwIHNraXBzIHRoZSBkdW1wLiAgVGhpcyBpcyBhIGNv
bnNpc3RlbnQKLQkJCSAqIHdheSB0byBjYXRjaCByZWN1cnNpdmUgY3Jhc2hlcy4gIFdlIGNhbiBz
dGlsbCBjcmFzaAotCQkJICogaWYgdGhlIGNvcmVfcGF0dGVybiBiaW5hcnkgc2V0cyBSTElNX0NP
UkUgPSAgITEKLQkJCSAqIGJ1dCBpdCBydW5zIGFzIHJvb3QsIGFuZCBjYW4gZG8gbG90cyBvZiBz
dHVwaWQgdGhpbmdzCisJCQkgKiBjcHJtLmxpbWl0IG9mIDEgaGVyZSBhcyBhIHNwZWFjaWFsIHZh
bHVlLCB0aGlzIGlzIGEKKwkJCSAqIGNvbnNpc3RlbnQgd2F5IHRvIGNhdGNoIHJlY3Vyc2l2ZSBj
cmFzaGVzLgorCQkJICogV2UgY2FuIHN0aWxsIGNyYXNoIGlmIHRoZSBjb3JlX3BhdHRlcm4gYmlu
YXJ5IHNldHMKKwkJCSAqIFJMSU1fQ09SRSA9ICExLCBidXQgaXQgcnVucyBhcyByb290LCBhbmQg
Y2FuIGRvCisJCQkgKiBsb3RzIG9mIHN0dXBpZCB0aGluZ3MuCisJCQkgKgogCQkJICogTm90ZSB0
aGF0IHdlIHVzZSB0YXNrX3RnaWRfdm5yIGhlcmUgdG8gZ3JhYiB0aGUgcGlkCiAJCQkgKiBvZiB0
aGUgcHJvY2VzcyBncm91cCBsZWFkZXIuICBUaGF0IHdheSB3ZSBnZXQgdGhlCiAJCQkgKiByaWdo
dCBwaWQgaWYgYSB0aHJlYWQgaW4gYSBtdWx0aS10aHJlYWRlZAotLSAKMS42LjUuMgoK
--00151747b9ea82541104ab3d9d2f--
