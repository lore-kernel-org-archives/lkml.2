Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1DBLCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 07:02:12 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35875 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab1DBLCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 07:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=LkRjOW6fenoDcAdZW29j8TDOlunIXo17Enhp6RYB+HlfzeftP+77TAH8h53SEr3n7Y
         gVCk7aspr7lEZjGXYWJOtu7AlqOwm7z4qIAlsWpx2XDnbVO4oKrt7kcbUr1OKqtNRNwv
         HUcoH2b9LxvdN19kV04TpJqWFCnsVseN5G1tI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTim_y-=rU8r0_LKEMjPco6TXrEpBvw@mail.gmail.com>
References: <AANLkTimhD_cu46Bhtt9v8MjKMVCnVMT6Es+Ys9RNPOp1@mail.gmail.com>
	<20110402112037.ca288d7b.sfr@canb.auug.org.au>
	<BANLkTim_y-=rU8r0_LKEMjPco6TXrEpBvw@mail.gmail.com>
Date: Sat, 2 Apr 2011 13:02:09 +0200
Message-ID: <BANLkTimfCtqTA5aPYGRMZ1Ndz6eU8HnyJA@mail.gmail.com>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when CONFIG_DEBUG_SECTION_MISMATCH=y]s
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jaxboe@fusionio.com>, dedekind1@gmail.com,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016364184bd35077e049fed75eb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364184bd35077e049fed75eb
Content-Type: text/plain; charset=UTF-8

On Sat, Apr 2, 2011 at 12:14 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Sat, Apr 2, 2011 at 2:20 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> cc'ing Jens ...
>>
>> On Fri, 1 Apr 2011 20:22:41 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>>
>>> On Fri, Apr 1, 2011 at 7:02 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
>>> > On Fri, 2011-04-01 at 18:10 +0200, Sedat Dilek wrote:
>>> >> On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>> >> > Cc'ing Artem,
>>> >> >
>>> >> > On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>>> >> >>
>>> >> >> With CONFIG_DEBUG_SECTION_MISMATCH=y set, I see in my build.log:
>>> >> >> ...
>>> >> >> MODPOST 2742 modules
>>> >> >> ...
>>> >> >> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
>>> >> >> make[5]: *** [__modpost] Error 1
>>> >> >> make[4]: *** [modules] Error 2
>>> >> >> make[3]: *** [sub-make] Error 2
>>> >> >> make[2]: *** [all] Error 2
>>> >> >> make[2]: Leaving directory
>>> >> >> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_none_686-iniza'
>>> >> >>
[...]
> Just FYI:
> I contacted Jens last night and he refreshed his for-linus GIT branch.
> Adding missing include <linux/fs.h> did not fix the issue.
> I am trying with the attached one.
>
> - Sedat -
>

I have split the single patch into two, first reflects ther build-error.
The second considers {inode,file}_operations have also undefined
functions by using "unified" empty_{iops,fops} as used in other fs/*
files.

- Sedat -

--0016364184bd35077e049fed75eb
Content-Type: text/plain; charset=US-ASCII; 
	name="0001-nilfs2-ubifs-Fix-error-empty_aops-undefined.patch"
Content-Disposition: attachment; 
	filename="0001-nilfs2-ubifs-Fix-error-empty_aops-undefined.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gm0fmsgx1

RnJvbSA2NTcxMjY3YTMyYmViZTZkODdlMTJkMTYwNjU4NjI0ZWU1NjAzOWZjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDIgQXByIDIwMTEgMTI6Mjg6MzcgKzAyMDAKU3ViamVjdDogW1BBVENIIDEvMl0g
bmlsZnMyLHViaWZzOiBGaXggZXJyb3IgZW1wdHlfYW9wcyB1bmRlZmluZWQKCldpdGggdGhlIC0+
c3luY19wYWdlKCkgaG9vayBnb25lLCB3ZSBoYXZlIGEgZmV3IHVzZXJzIHRoYXQKYWRkIHRoZWly
IG93biBzdGF0aWMgYWRkcmVzc19zcGFjZV9vcGVyYXRpb25zIHdpdGhvdXQgYW55CmZ1bmN0aW9u
cyBkZWZpbmVkLgoKVGhpcyBmaXhlcyB0aGUgZm9sbG93aW5nIGlzc3VlczoKRVJST1I6ICJlbXB0
eV9hb3BzIiBbZnMvdWJpZnMvdWJpZnMua29dIHVuZGVmaW5lZCEKRVJST1I6ICJlbXB0eV9hb3Bz
IiBbZnMvbmlsZnMyL25pbGZzMi5rb10gdW5kZWZpbmVkIQoKU2lnbmVkLW9mZi1ieTogU2VkYXQg
RGlsZWsgPHNlZGF0LmRpbGVrQGdtYWlsLmNvbT4KLS0tCiBmcy9uaWxmczIvcGFnZS5jIHwgICAg
MiArLQogZnMvdWJpZnMveGF0dHIuYyB8ICAgIDQgKystLQogMiBmaWxlcyBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvbmlsZnMyL3BhZ2Uu
YyBiL2ZzL25pbGZzMi9wYWdlLmMKaW5kZXggOWQyZGM2Yi4uZTdkZjNmOSAxMDA2NDQKLS0tIGEv
ZnMvbmlsZnMyL3BhZ2UuYworKysgYi9mcy9uaWxmczIvcGFnZS5jCkBAIC00OTUsNyArNDk1LDcg
QEAgdW5zaWduZWQgbmlsZnNfcGFnZV9jb3VudF9jbGVhbl9idWZmZXJzKHN0cnVjdCBwYWdlICpw
YWdlLAogdm9pZCBuaWxmc19tYXBwaW5nX2luaXQoc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBp
bmcsCiAJCQlzdHJ1Y3QgYmFja2luZ19kZXZfaW5mbyAqYmRpKQogewotCXN0YXRpYyBjb25zdCBz
dHJ1Y3QgYWRkcmVzc19zcGFjZV9vcGVyYXRpb25zIGVtcHR5X2FvcHM7CisJc3RhdGljIGNvbnN0
IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgZW1wdHlfYW9wcyA9IHt9OwogCiAJbWFw
cGluZy0+aG9zdCA9IE5VTEw7CiAJbWFwcGluZy0+ZmxhZ3MgPSAwOwpkaWZmIC0tZ2l0IGEvZnMv
dWJpZnMveGF0dHIuYyBiL2ZzL3ViaWZzL3hhdHRyLmMKaW5kZXggYzc0NDAwZi4uMjlkNTY4MSAx
MDA2NDQKLS0tIGEvZnMvdWJpZnMveGF0dHIuYworKysgYi9mcy91Ymlmcy94YXR0ci5jCkBAIC04
MCw3ICs4MCw2IEBAIGVudW0gewogfTsKIAogc3RhdGljIGNvbnN0IHN0cnVjdCBpbm9kZV9vcGVy
YXRpb25zIG5vbmVfaW5vZGVfb3BlcmF0aW9uczsKLXN0YXRpYyBjb25zdCBzdHJ1Y3QgYWRkcmVz
c19zcGFjZV9vcGVyYXRpb25zIG5vbmVfYWRkcmVzc19vcGVyYXRpb25zOwogc3RhdGljIGNvbnN0
IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgbm9uZV9maWxlX29wZXJhdGlvbnM7CiAKIC8qKgpAQCAt
MTAwLDYgKzk5LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgbm9uZV9m
aWxlX29wZXJhdGlvbnM7CiBzdGF0aWMgaW50IGNyZWF0ZV94YXR0cihzdHJ1Y3QgdWJpZnNfaW5m
byAqYywgc3RydWN0IGlub2RlICpob3N0LAogCQkJY29uc3Qgc3RydWN0IHFzdHIgKm5tLCBjb25z
dCB2b2lkICp2YWx1ZSwgaW50IHNpemUpCiB7CisJc3RhdGljIGNvbnN0IHN0cnVjdCBhZGRyZXNz
X3NwYWNlX29wZXJhdGlvbnMgZW1wdHlfYW9wcyA9IHt9OwogCWludCBlcnI7CiAJc3RydWN0IGlu
b2RlICppbm9kZTsKIAlzdHJ1Y3QgdWJpZnNfaW5vZGUgKnVpLCAqaG9zdF91aSA9IHViaWZzX2lu
b2RlKGhvc3QpOwpAQCAtMTMwLDcgKzEzMCw3IEBAIHN0YXRpYyBpbnQgY3JlYXRlX3hhdHRyKHN0
cnVjdCB1Ymlmc19pbmZvICpjLCBzdHJ1Y3QgaW5vZGUgKmhvc3QsCiAJfQogCiAJLyogUmUtZGVm
aW5lIGFsbCBvcGVyYXRpb25zIHRvIGJlICJub3RoaW5nIiAqLwotCWlub2RlLT5pX21hcHBpbmct
PmFfb3BzID0gJm5vbmVfYWRkcmVzc19vcGVyYXRpb25zOworCWlub2RlLT5pX21hcHBpbmctPmFf
b3BzID0gJmVtcHR5X2FvcHM7CiAJaW5vZGUtPmlfb3AgPSAmbm9uZV9pbm9kZV9vcGVyYXRpb25z
OwogCWlub2RlLT5pX2ZvcCA9ICZub25lX2ZpbGVfb3BlcmF0aW9uczsKIAotLSAKMS43LjQuMgoK
--0016364184bd35077e049fed75eb
Content-Type: text/plain; charset=US-ASCII; 
	name="0002-ubifs-Move-inode-file-_operations-to-create_xattr-an.patch"
Content-Disposition: attachment; 
	filename="0002-ubifs-Move-inode-file-_operations-to-create_xattr-an.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gm0fn4f62

RnJvbSAwZjQ1MDM5Y2ZkZDUwZDQ5NGQ3ZmRiYTlkNTk1YWVkMjkxODE2N2NjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDIgQXByIDIwMTEgMTI6MzM6NDQgKzAyMDAKU3ViamVjdDogW1BBVENIIDIvMl0g
dWJpZnM6IE1vdmUge2lub2RlLGZpbGV9X29wZXJhdGlvbnMgdG8gY3JlYXRlX3hhdHRyKCkgYW5k
IHVzZSBlbXB0eV97aW9wcyxmb3BzfQoKQ29uc2lkZXIgaW5vZGVfb3BlcmF0aW9ucyBhbmQgZmls
ZV9vcGVyYXRpb25zIGhhdmUgYWxzbyBubyBmdW5jdGlvbnMgZGVmaW5lZAphbmQgbW92ZSB0aGVt
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
X2lub2RlKGlub2RlKTsKLS0gCjEuNy40LjIKCg==
--0016364184bd35077e049fed75eb--
