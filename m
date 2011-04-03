Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1DCXHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:07:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55131 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1DCXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=n0Fv8QBauivrsHGiG3hab0OXG23nirGELApxDemA2eDXl8CkSE9rTG7QklXPkWzWoW
         KiSp1z/YQEI6G98xJ95WhzxK/Oi4GZ7FEHt2tVd9yLU5EXV50BLgcrOOfcC1Y1L16SHy
         tRKcr40mkoE7uzm04AL/92O1A2f1qJgtAY0c4=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D98F66D.9040808@fusionio.com>
References: <AANLkTimhD_cu46Bhtt9v8MjKMVCnVMT6Es+Ys9RNPOp1@mail.gmail.com>
	<20110402112037.ca288d7b.sfr@canb.auug.org.au>
	<BANLkTim_y-=rU8r0_LKEMjPco6TXrEpBvw@mail.gmail.com>
	<BANLkTimfCtqTA5aPYGRMZ1Ndz6eU8HnyJA@mail.gmail.com>
	<4D98F1DA.1060203@fusionio.com>
	<BANLkTin4T0CZPK_Vmk=UEh63+6CXM2f7Mg@mail.gmail.com>
	<4D98F2FF.7090201@fusionio.com>
	<BANLkTinMznekjV+6bG4+=2Y8cZ=jVGfJtQ@mail.gmail.com>
	<4D98F66D.9040808@fusionio.com>
Date: Mon, 4 Apr 2011 01:07:10 +0200
Message-ID: <BANLkTin_tLVnFg8Ec-R-YxPk2FQKp1Dw0A@mail.gmail.com>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when CONFIG_DEBUG_SECTION_MISMATCH=y]s
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0015175cddfae75ea304a00bb329
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175cddfae75ea304a00bb329
Content-Type: text/plain; charset=UTF-8

On Mon, Apr 4, 2011 at 12:36 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-04-04 00:33, Sedat Dilek wrote:
>> On Mon, Apr 4, 2011 at 12:21 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> On 2011-04-04 00:19, Sedat Dilek wrote:
>>>> On Mon, Apr 4, 2011 at 12:16 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>>> On 2011-04-02 13:02, Sedat Dilek wrote:
>>>>>> On Sat, Apr 2, 2011 at 12:14 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>>>> On Sat, Apr 2, 2011 at 2:20 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>>>>> cc'ing Jens ...
>>>>>>>>
>>>>>>>> On Fri, 1 Apr 2011 20:22:41 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>>>>>>
>>>>>>>>> On Fri, Apr 1, 2011 at 7:02 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>>>>>>>>>> On Fri, 2011-04-01 at 18:10 +0200, Sedat Dilek wrote:
>>>>>>>>>>> On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>>>>>>>>>> Cc'ing Artem,
>>>>>>>>>>>>
>>>>>>>>>>>> On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>> With CONFIG_DEBUG_SECTION_MISMATCH=y set, I see in my build.log:
>>>>>>>>>>>>> ...
>>>>>>>>>>>>> MODPOST 2742 modules
>>>>>>>>>>>>> ...
>>>>>>>>>>>>> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
>>>>>>>>>>>>> make[5]: *** [__modpost] Error 1
>>>>>>>>>>>>> make[4]: *** [modules] Error 2
>>>>>>>>>>>>> make[3]: *** [sub-make] Error 2
>>>>>>>>>>>>> make[2]: *** [all] Error 2
>>>>>>>>>>>>> make[2]: Leaving directory
>>>>>>>>>>>>> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_none_686-iniza'
>>>>>>>>>>>>>
>>>>>> [...]
>>>>>>> Just FYI:
>>>>>>> I contacted Jens last night and he refreshed his for-linus GIT branch.
>>>>>>> Adding missing include <linux/fs.h> did not fix the issue.
>>>>>>> I am trying with the attached one.
>>>>>>>
>>>>>>> - Sedat -
>>>>>>>
>>>>>>
>>>>>> I have split the single patch into two, first reflects ther build-error.
>>>>>> The second considers {inode,file}_operations have also undefined
>>>>>> functions by using "unified" empty_{iops,fops} as used in other fs/*
>>>>>> files.
>>>>>
>>>>> What are these patches against? Not for-next nor my for-linus.
>>>>>
>>>>
>>>> I tested with linux-next (next-20110401) as base and pulled-in your
>>>> for-linus GIT branch.
>>>
>>> Then perhaps there was some merge error. There's no empty_aops defined
>>> in my tree in nilfs_mapping_init(), for instance.
>>>
>>> Are you using an old for-linus?
>>>
>>
>> I dropped the idea of exporting empty_aops via include/linux/fs.h (&
>> changes in fs/inode.c) as it did not work as intended.
>> As an alternative I used empty_{aops,iops,fops} only in
>> fs/nilfs2/page.c and fs/ubifs/xattr.c where it is only needed (for
>> example for aops: static const struct address_space_operations
>> empty_aops {}; etc.)
>
> I'm asking one thing, you are replying with something else. The patches
> you sent do NOT apply to for-linus.
>

Oh, I forgot the revert patch.
Here all 3 patches.

- Sedat -

--0015175cddfae75ea304a00bb329
Content-Type: text/x-patch; charset=US-ASCII; name="0001-Revert-fs-export-empty_aops.patch"
Content-Disposition: attachment; 
	filename="0001-Revert-fs-export-empty_aops.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gm2kz7tu0

RnJvbSBhZmRiYWQyODI4MjdjZDVlZmU0ODMyMTg5Yzg3OTg1MzgzZTFhMGI3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBNb24sIDQgQXByIDIwMTEgMDE6MDI6NTUgKzAyMDAKU3ViamVjdDogW1BBVENIIDEvM10g
UmV2ZXJ0ICJmczogZXhwb3J0IGVtcHR5X2FvcHMiCgpUaGlzIHJldmVydHMgY29tbWl0IDUyZGM3
NWFiYmZjOGMzNTI4NzVkOGU5YTkwMDZiMzI1YzEzNmJkNTguCgpTaWduZWQtb2ZmLWJ5OiBTZWRh
dCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgotLS0KIGZzL2lub2RlLmMgICAgICAgICB8
ICAgIDggKy0tLS0tLS0KIGZzL25pbGZzMi9wYWdlLmMgICB8ICAgIDIgKysKIGZzL3ViaWZzL3hh
dHRyLmMgICB8ICAgIDQgKystLQogaW5jbHVkZS9saW51eC9mcy5oIHwgICAgMiAtLQogNCBmaWxl
cyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2ZzL2lub2RlLmMgYi9mcy9pbm9kZS5jCmluZGV4IGI4MTg3MzAuLjVmNGUxMWEgMTAwNjQ0Ci0t
LSBhL2ZzL2lub2RlLmMKKysrIGIvZnMvaW5vZGUuYwpAQCAtMTI1LDEzICsxMjUsNiBAQCBfX2Nh
Y2hlbGluZV9hbGlnbmVkX2luX3NtcCBERUZJTkVfU1BJTkxPQ0soaW5vZGVfd2JfbGlzdF9sb2Nr
KTsKIHN0YXRpYyBERUNMQVJFX1JXU0VNKGlwcnVuZV9zZW0pOwogCiAvKgotICogRW1wdHkgYW9w
cy4gQ2FuIGJlIHVzZWQgZm9yIHRoZSBjYXNlcyB3aGVyZSB0aGUgdXNlciBkb2VzIG5vdAotICog
ZGVmaW5lIGFueSBvZiB0aGUgYWRkcmVzc19zcGFjZSBvcGVyYXRpb25zLgotICovCi1jb25zdCBz
dHJ1Y3QgYWRkcmVzc19zcGFjZV9vcGVyYXRpb25zIGVtcHR5X2FvcHMgPSB7Ci19OwotCi0vKgog
ICogU3RhdGlzdGljcyBnYXRoZXJpbmcuLgogICovCiBzdHJ1Y3QgaW5vZGVzX3N0YXRfdCBpbm9k
ZXNfc3RhdDsKQEAgLTE4Myw2ICsxNzYsNyBAQCBpbnQgcHJvY19ucl9pbm9kZXMoY3RsX3RhYmxl
ICp0YWJsZSwgaW50IHdyaXRlLAogICovCiBpbnQgaW5vZGVfaW5pdF9hbHdheXMoc3RydWN0IHN1
cGVyX2Jsb2NrICpzYiwgc3RydWN0IGlub2RlICppbm9kZSkKIHsKKwlzdGF0aWMgY29uc3Qgc3Ry
dWN0IGFkZHJlc3Nfc3BhY2Vfb3BlcmF0aW9ucyBlbXB0eV9hb3BzOwogCXN0YXRpYyBjb25zdCBz
dHJ1Y3QgaW5vZGVfb3BlcmF0aW9ucyBlbXB0eV9pb3BzOwogCXN0YXRpYyBjb25zdCBzdHJ1Y3Qg
ZmlsZV9vcGVyYXRpb25zIGVtcHR5X2ZvcHM7CiAJc3RydWN0IGFkZHJlc3Nfc3BhY2UgKmNvbnN0
IG1hcHBpbmcgPSAmaW5vZGUtPmlfZGF0YTsKZGlmZiAtLWdpdCBhL2ZzL25pbGZzMi9wYWdlLmMg
Yi9mcy9uaWxmczIvcGFnZS5jCmluZGV4IDExNjgwNTkuLjlkMmRjNmIgMTAwNjQ0Ci0tLSBhL2Zz
L25pbGZzMi9wYWdlLmMKKysrIGIvZnMvbmlsZnMyL3BhZ2UuYwpAQCAtNDk1LDYgKzQ5NSw4IEBA
IHVuc2lnbmVkIG5pbGZzX3BhZ2VfY291bnRfY2xlYW5fYnVmZmVycyhzdHJ1Y3QgcGFnZSAqcGFn
ZSwKIHZvaWQgbmlsZnNfbWFwcGluZ19pbml0KHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5n
LAogCQkJc3RydWN0IGJhY2tpbmdfZGV2X2luZm8gKmJkaSkKIHsKKwlzdGF0aWMgY29uc3Qgc3Ry
dWN0IGFkZHJlc3Nfc3BhY2Vfb3BlcmF0aW9ucyBlbXB0eV9hb3BzOworCiAJbWFwcGluZy0+aG9z
dCA9IE5VTEw7CiAJbWFwcGluZy0+ZmxhZ3MgPSAwOwogCW1hcHBpbmdfc2V0X2dmcF9tYXNrKG1h
cHBpbmcsIEdGUF9OT0ZTKTsKZGlmZiAtLWdpdCBhL2ZzL3ViaWZzL3hhdHRyLmMgYi9mcy91Ymlm
cy94YXR0ci5jCmluZGV4IDMyOTlmNDYuLmM3NDQwMGYgMTAwNjQ0Ci0tLSBhL2ZzL3ViaWZzL3hh
dHRyLmMKKysrIGIvZnMvdWJpZnMveGF0dHIuYwpAQCAtNTYsNyArNTYsNiBAQAogICovCiAKICNp
bmNsdWRlICJ1Ymlmcy5oIgotI2luY2x1ZGUgPGxpbnV4L2ZzLmg+CiAjaW5jbHVkZSA8bGludXgv
c2xhYi5oPgogI2luY2x1ZGUgPGxpbnV4L3hhdHRyLmg+CiAjaW5jbHVkZSA8bGludXgvcG9zaXhf
YWNsX3hhdHRyLmg+CkBAIC04MSw2ICs4MCw3IEBAIGVudW0gewogfTsKIAogc3RhdGljIGNvbnN0
IHN0cnVjdCBpbm9kZV9vcGVyYXRpb25zIG5vbmVfaW5vZGVfb3BlcmF0aW9uczsKK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgYWRkcmVzc19zcGFjZV9vcGVyYXRpb25zIG5vbmVfYWRkcmVzc19vcGVyYXRp
b25zOwogc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgbm9uZV9maWxlX29wZXJh
dGlvbnM7CiAKIC8qKgpAQCAtMTMwLDcgKzEzMCw3IEBAIHN0YXRpYyBpbnQgY3JlYXRlX3hhdHRy
KHN0cnVjdCB1Ymlmc19pbmZvICpjLCBzdHJ1Y3QgaW5vZGUgKmhvc3QsCiAJfQogCiAJLyogUmUt
ZGVmaW5lIGFsbCBvcGVyYXRpb25zIHRvIGJlICJub3RoaW5nIiAqLwotCWlub2RlLT5pX21hcHBp
bmctPmFfb3BzID0gJmVtcHR5X2FvcHM7CisJaW5vZGUtPmlfbWFwcGluZy0+YV9vcHMgPSAmbm9u
ZV9hZGRyZXNzX29wZXJhdGlvbnM7CiAJaW5vZGUtPmlfb3AgPSAmbm9uZV9pbm9kZV9vcGVyYXRp
b25zOwogCWlub2RlLT5pX2ZvcCA9ICZub25lX2ZpbGVfb3BlcmF0aW9uczsKIApkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9mcy5oIGIvaW5jbHVkZS9saW51eC9mcy5oCmluZGV4IDFiOTVhZjMu
LjUyZjI4M2MgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvZnMuaAorKysgYi9pbmNsdWRlL2xp
bnV4L2ZzLmgKQEAgLTYxMyw4ICs2MTMsNiBAQCBzdHJ1Y3QgYWRkcmVzc19zcGFjZV9vcGVyYXRp
b25zIHsKIAlpbnQgKCplcnJvcl9yZW1vdmVfcGFnZSkoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKiwg
c3RydWN0IHBhZ2UgKik7CiB9OwogCi1leHRlcm4gY29uc3Qgc3RydWN0IGFkZHJlc3Nfc3BhY2Vf
b3BlcmF0aW9ucyBlbXB0eV9hb3BzOwotCiAvKgogICogcGFnZWNhY2hlX3dyaXRlX2JlZ2luL3Bh
Z2VjYWNoZV93cml0ZV9lbmQgbXVzdCBiZSB1c2VkIGJ5IGdlbmVyYWwgY29kZQogICogdG8gd3Jp
dGUgaW50byB0aGUgcGFnZWNhY2hlLgotLSAKMS43LjQuMwoK
--0015175cddfae75ea304a00bb329
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0002-nilfs2-ubifs-Fix-error-empty_aops-undefined.patch"
Content-Disposition: attachment; 
	filename="0002-nilfs2-ubifs-Fix-error-empty_aops-undefined.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gm2kzf0m1

RnJvbSA0MzU4N2NjNWJkZDY2YmQzY2VhOWM1NWJhYWUxZmRjYmQzZjlmNzU4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDIgQXByIDIwMTEgMTI6Mjg6MzcgKzAyMDAKU3ViamVjdDogW1BBVENIIDIvM10g
bmlsZnMyLHViaWZzOiBGaXggZXJyb3IgZW1wdHlfYW9wcyB1bmRlZmluZWQKCldpdGggdGhlIC0+
c3luY19wYWdlKCkgaG9vayBnb25lLCB3ZSBoYXZlIGEgZmV3IHVzZXJzIHRoYXQKYWRkIHRoZWly
IG93biBzdGF0aWMgYWRkcmVzc19zcGFjZV9vcGVyYXRpb25zIHdpdGhvdXQgYW55CmZ1bmN0aW9u
cyBkZWZpbmVkLgoKVGhpcyBwYXRjaCBmaXhlcyB0aGUgZm9sbG93aW5nIGlzc3VlczoKRVJST1I6
ICJlbXB0eV9hb3BzIiBbZnMvdWJpZnMvdWJpZnMua29dIHVuZGVmaW5lZCEKRVJST1I6ICJlbXB0
eV9hb3BzIiBbZnMvbmlsZnMyL25pbGZzMi5rb10gdW5kZWZpbmVkIQoKTm90ZTogImZzOiBleHBv
cnQgZW1wdHlfYW9wcyIgcGF0Y2ggbmVlZHMgdG8gYmUgcmV2ZXJ0ZWQgZmlyc3QhCgpTaWduZWQt
b2ZmLWJ5OiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgotLS0KIGZzL25pbGZz
Mi9wYWdlLmMgfCAgICAyICstCiBmcy91Ymlmcy94YXR0ci5jIHwgICAgNCArKy0tCiAyIGZpbGVz
IGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9m
cy9uaWxmczIvcGFnZS5jIGIvZnMvbmlsZnMyL3BhZ2UuYwppbmRleCA5ZDJkYzZiLi5lN2RmM2Y5
IDEwMDY0NAotLS0gYS9mcy9uaWxmczIvcGFnZS5jCisrKyBiL2ZzL25pbGZzMi9wYWdlLmMKQEAg
LTQ5NSw3ICs0OTUsNyBAQCB1bnNpZ25lZCBuaWxmc19wYWdlX2NvdW50X2NsZWFuX2J1ZmZlcnMo
c3RydWN0IHBhZ2UgKnBhZ2UsCiB2b2lkIG5pbGZzX21hcHBpbmdfaW5pdChzdHJ1Y3QgYWRkcmVz
c19zcGFjZSAqbWFwcGluZywKIAkJCXN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpiZGkpCiB7Ci0J
c3RhdGljIGNvbnN0IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgZW1wdHlfYW9wczsK
KwlzdGF0aWMgY29uc3Qgc3RydWN0IGFkZHJlc3Nfc3BhY2Vfb3BlcmF0aW9ucyBlbXB0eV9hb3Bz
ID0ge307CiAKIAltYXBwaW5nLT5ob3N0ID0gTlVMTDsKIAltYXBwaW5nLT5mbGFncyA9IDA7CmRp
ZmYgLS1naXQgYS9mcy91Ymlmcy94YXR0ci5jIGIvZnMvdWJpZnMveGF0dHIuYwppbmRleCBjNzQ0
MDBmLi4yOWQ1NjgxIDEwMDY0NAotLS0gYS9mcy91Ymlmcy94YXR0ci5jCisrKyBiL2ZzL3ViaWZz
L3hhdHRyLmMKQEAgLTgwLDcgKzgwLDYgQEAgZW51bSB7CiB9OwogCiBzdGF0aWMgY29uc3Qgc3Ry
dWN0IGlub2RlX29wZXJhdGlvbnMgbm9uZV9pbm9kZV9vcGVyYXRpb25zOwotc3RhdGljIGNvbnN0
IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgbm9uZV9hZGRyZXNzX29wZXJhdGlvbnM7
CiBzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBub25lX2ZpbGVfb3BlcmF0aW9u
czsKIAogLyoqCkBAIC0xMDAsNiArOTksNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3Bl
cmF0aW9ucyBub25lX2ZpbGVfb3BlcmF0aW9uczsKIHN0YXRpYyBpbnQgY3JlYXRlX3hhdHRyKHN0
cnVjdCB1Ymlmc19pbmZvICpjLCBzdHJ1Y3QgaW5vZGUgKmhvc3QsCiAJCQljb25zdCBzdHJ1Y3Qg
cXN0ciAqbm0sIGNvbnN0IHZvaWQgKnZhbHVlLCBpbnQgc2l6ZSkKIHsKKwlzdGF0aWMgY29uc3Qg
c3RydWN0IGFkZHJlc3Nfc3BhY2Vfb3BlcmF0aW9ucyBlbXB0eV9hb3BzID0ge307CiAJaW50IGVy
cjsKIAlzdHJ1Y3QgaW5vZGUgKmlub2RlOwogCXN0cnVjdCB1Ymlmc19pbm9kZSAqdWksICpob3N0
X3VpID0gdWJpZnNfaW5vZGUoaG9zdCk7CkBAIC0xMzAsNyArMTMwLDcgQEAgc3RhdGljIGludCBj
cmVhdGVfeGF0dHIoc3RydWN0IHViaWZzX2luZm8gKmMsIHN0cnVjdCBpbm9kZSAqaG9zdCwKIAl9
CiAKIAkvKiBSZS1kZWZpbmUgYWxsIG9wZXJhdGlvbnMgdG8gYmUgIm5vdGhpbmciICovCi0JaW5v
ZGUtPmlfbWFwcGluZy0+YV9vcHMgPSAmbm9uZV9hZGRyZXNzX29wZXJhdGlvbnM7CisJaW5vZGUt
PmlfbWFwcGluZy0+YV9vcHMgPSAmZW1wdHlfYW9wczsKIAlpbm9kZS0+aV9vcCA9ICZub25lX2lu
b2RlX29wZXJhdGlvbnM7CiAJaW5vZGUtPmlfZm9wID0gJm5vbmVfZmlsZV9vcGVyYXRpb25zOwog
Ci0tIAoxLjcuNC4zCgo=
--0015175cddfae75ea304a00bb329
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0003-ubifs-Move-inode-file-_operations-to-create_xattr-an.patch"
Content-Disposition: attachment; 
	filename="0003-ubifs-Move-inode-file-_operations-to-create_xattr-an.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gm2kzid82

RnJvbSA0Y2M1MjNkNjYwZDVjOTQ3NmFkNWU2YWY5ZmYxNTU1NTFlNzJhMmRjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDIgQXByIDIwMTEgMTI6MzM6NDQgKzAyMDAKU3ViamVjdDogW1BBVENIIDMvM10g
dWJpZnM6IE1vdmUge2lub2RlLGZpbGV9X29wZXJhdGlvbnMgdG8gY3JlYXRlX3hhdHRyKCkgYW5k
IHVzZSBlbXB0eV97aW9wcyxmb3BzfQoKQ29uc2lkZXIgaW5vZGVfb3BlcmF0aW9ucyBhbmQgZmls
ZV9vcGVyYXRpb25zIGhhdmUgYWxzbyBubwpmdW5jdGlvbnMgZGVmaW5lZCBhbmQgbW92ZSB0aGVt
IHRvIGNyZWF0ZV94YXR0cigpLgpUcmFuc2Zvcm0gdG8gZW1wdHlfe2lvcHMsZm9wc30gKHNlZSBm
cy9pbm9kZS5jIGFuZCBmcy9vcGVuLmMpLgoKU2lnbmVkLW9mZi1ieTogU2VkYXQgRGlsZWsgPHNl
ZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBmcy91Ymlmcy94YXR0ci5jIHwgICAgOSArKysrLS0t
LS0KIDEgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2ZzL3ViaWZzL3hhdHRyLmMgYi9mcy91Ymlmcy94YXR0ci5jCmluZGV4IDI5ZDU2
ODEuLmQyMzdjNGYgMTAwNjQ0Ci0tLSBhL2ZzL3ViaWZzL3hhdHRyLmMKKysrIGIvZnMvdWJpZnMv
eGF0dHIuYwpAQCAtNzksOSArNzksNiBAQCBlbnVtIHsKIAlTRUNVUklUWV9YQVRUUiwKIH07CiAK
LXN0YXRpYyBjb25zdCBzdHJ1Y3QgaW5vZGVfb3BlcmF0aW9ucyBub25lX2lub2RlX29wZXJhdGlv
bnM7Ci1zdGF0aWMgY29uc3Qgc3RydWN0IGZpbGVfb3BlcmF0aW9ucyBub25lX2ZpbGVfb3BlcmF0
aW9uczsKLQogLyoqCiAgKiBjcmVhdGVfeGF0dHIgLSBjcmVhdGUgYW4gZXh0ZW5kZWQgYXR0cmli
dXRlLgogICogQGM6IFVCSUZTIGZpbGUtc3lzdGVtIGRlc2NyaXB0aW9uIG9iamVjdApAQCAtMTAw
LDYgKzk3LDggQEAgc3RhdGljIGludCBjcmVhdGVfeGF0dHIoc3RydWN0IHViaWZzX2luZm8gKmMs
IHN0cnVjdCBpbm9kZSAqaG9zdCwKIAkJCWNvbnN0IHN0cnVjdCBxc3RyICpubSwgY29uc3Qgdm9p
ZCAqdmFsdWUsIGludCBzaXplKQogewogCXN0YXRpYyBjb25zdCBzdHJ1Y3QgYWRkcmVzc19zcGFj
ZV9vcGVyYXRpb25zIGVtcHR5X2FvcHMgPSB7fTsKKwlzdGF0aWMgY29uc3Qgc3RydWN0IGlub2Rl
X29wZXJhdGlvbnMgZW1wdHlfaW9wcyA9IHt9OworCXN0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9v
cGVyYXRpb25zIGVtcHR5X2ZvcHMgPSB7fTsKIAlpbnQgZXJyOwogCXN0cnVjdCBpbm9kZSAqaW5v
ZGU7CiAJc3RydWN0IHViaWZzX2lub2RlICp1aSwgKmhvc3RfdWkgPSB1Ymlmc19pbm9kZShob3N0
KTsKQEAgLTEzMSw4ICsxMzAsOCBAQCBzdGF0aWMgaW50IGNyZWF0ZV94YXR0cihzdHJ1Y3QgdWJp
ZnNfaW5mbyAqYywgc3RydWN0IGlub2RlICpob3N0LAogCiAJLyogUmUtZGVmaW5lIGFsbCBvcGVy
YXRpb25zIHRvIGJlICJub3RoaW5nIiAqLwogCWlub2RlLT5pX21hcHBpbmctPmFfb3BzID0gJmVt
cHR5X2FvcHM7Ci0JaW5vZGUtPmlfb3AgPSAmbm9uZV9pbm9kZV9vcGVyYXRpb25zOwotCWlub2Rl
LT5pX2ZvcCA9ICZub25lX2ZpbGVfb3BlcmF0aW9uczsKKwlpbm9kZS0+aV9vcCA9ICZlbXB0eV9p
b3BzOworCWlub2RlLT5pX2ZvcCA9ICZlbXB0eV9mb3BzOwogCiAJaW5vZGUtPmlfZmxhZ3MgfD0g
U19TWU5DIHwgU19OT0FUSU1FIHwgU19OT0NNVElNRSB8IFNfTk9RVU9UQTsKIAl1aSA9IHViaWZz
X2lub2RlKGlub2RlKTsKLS0gCjEuNy40LjMKCg==
--0015175cddfae75ea304a00bb329--
