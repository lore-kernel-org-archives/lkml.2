Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1DBKOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 06:14:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37944 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab1DBKOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 06:14:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=K0bENbGrXD+Y4KVMxBa6niVsxryWSVrAe2QwyoXQAcAsEFXq+jGDFKrkW0hyb7gEHQ
         VUjTjTWjsPR9zLEvBN4NA5gMsl+G7nX/zVsHZkf4cocGj7r9pRwWe3eGVeOoUjQuD+wi
         CQ77nR8dYBR4wpwDJchxF2y3h/hw+4bnXRkCM=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110402112037.ca288d7b.sfr@canb.auug.org.au>
References: <AANLkTimhD_cu46Bhtt9v8MjKMVCnVMT6Es+Ys9RNPOp1@mail.gmail.com>
	<20110402112037.ca288d7b.sfr@canb.auug.org.au>
Date: Sat, 2 Apr 2011 12:14:34 +0200
Message-ID: <BANLkTim_y-=rU8r0_LKEMjPco6TXrEpBvw@mail.gmail.com>
Subject: Re: linux-next: Tree for April 1 [BROKEN ubifs when CONFIG_DEBUG_SECTION_MISMATCH=y]s
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jaxboe@fusionio.com>, dedekind1@gmail.com,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016364184bd0d6577049feccb36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364184bd0d6577049feccb36
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 2, 2011 at 2:20 AM, Stephen Rothwell <sfr@canb.auug.org.au> wro=
te:
> cc'ing Jens ...
>
> On Fri, 1 Apr 2011 20:22:41 +0200 Sedat Dilek <sedat.dilek@googlemail.com=
> wrote:
>>
>> On Fri, Apr 1, 2011 at 7:02 PM, Artem Bityutskiy <dedekind1@gmail.com> w=
rote:
>> > On Fri, 2011-04-01 at 18:10 +0200, Sedat Dilek wrote:
>> >> On Fri, Apr 1, 2011 at 6:06 PM, Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
>> >> > Cc'ing Artem,
>> >> >
>> >> > On Fri, 1 Apr 2011 17:55:52 +0200 Sedat Dilek <sedat.dilek@googlema=
il.com> wrote:
>> >> >>
>> >> >> With CONFIG_DEBUG_SECTION_MISMATCH=3Dy set, I see in my build.log:
>> >> >> ...
>> >> >> MODPOST 2742 modules
>> >> >> ...
>> >> >> ERROR: "empty_aops" [fs/ubifs/ubifs.ko] undefined!
>> >> >> make[5]: *** [__modpost] Error 1
>> >> >> make[4]: *** [modules] Error 2
>> >> >> make[3]: *** [sub-make] Error 2
>> >> >> make[2]: *** [all] Error 2
>> >> >> make[2]: Leaving directory
>> >> >> `/home/sd/src/linux-2.6/linux-2.6.39-rc1/debian/build/build_i386_n=
one_686-iniza'
>> >> >>
>> >> >> - Sedat -
>> >> >>
>> >> >
>> >> >
>> >> > --
>> >> > Cheers,
>> >> > Stephen Rothwell =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0sfr@canb.auug.org.au
>> >> > http://www.canb.auug.org.au/~sfr/
>> >> >
>> >>
>> >> Speculative patch (untested).
>> >>
>> >> - Sedat -
>> >>
>> >> $ diff -uprN fs/ubifs/xattr.c.orig fs/ubifs/xattr.c
>> >> --- fs/ubifs/xattr.c.orig =C2=A0 =C2=A0 =C2=A0 2011-04-01 15:56:08.47=
1082117 +0200
>> >> +++ fs/ubifs/xattr.c =C2=A0 =C2=A02011-04-01 18:08:27.355276827 +0200
>> >> @@ -81,6 +81,7 @@ enum {
>> >>
>> >> =C2=A0static const struct inode_operations none_inode_operations;
>> >> =C2=A0static const struct file_operations none_file_operations;
>> >> +static const struct address_space_operations empty_aops;
>> >>
>> >> =C2=A0/**
>> >> =C2=A0 * create_xattr - create an extended attribute.
>> >
>> > ubifs doess not have 'empty_aops' symbol and does not use such symbol.=
 I
>> > do not understand how you got that build issue, but this must be
>> > something to do with your local setup.
>> >
>> > Also:
>> >
>> > [dedekind@eru linux-next (master)]$ grep -r 'empty_aops' *
>> > fs/nilfs2/page.c: =C2=A0 =C2=A0 =C2=A0 static const struct address_spa=
ce_operations empty_aops;
>> > fs/nilfs2/page.c: =C2=A0 =C2=A0 =C2=A0 mapping->a_ops =3D &empty_aops;
>> > fs/inode.c: =C2=A0 =C2=A0 static const struct address_space_operations=
 empty_aops;
>> > fs/inode.c: =C2=A0 =C2=A0 mapping->a_ops =3D &empty_aops;
>> >
>> > in the current linux-next.
>> >
>> > --
>> > Best Regards,
>> > Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=
=8E=D1=86=D0=BA=D0=B8=D0=B9)
>> >
>> >
>>
>> You are right, I pulled linux-2.6-block.git#for-linus into linux-next.
>> Looks like linux-2.6-block-for-linus/0007-fs-export-empty_aops.patch
>> is causing this [1].
>>
>> - Sedat -
>>
>> [1] http://git.kernel.org/?p=3Dlinux/kernel/git/axboe/linux-2.6-block.gi=
t;a=3Dcommit;h=3D2c9214b7b72cf440024d8b91523eea25bbc76040
>>
>
>
> --
> Cheers,
> Stephen Rothwell =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>

Just FYI:
I contacted Jens last night and he refreshed his for-linus GIT branch.
Adding missing include <linux/fs.h> did not fix the issue.
I am trying with the attached one.

- Sedat -

--0016364184bd0d6577049feccb36
Content-Type: text/plain; charset=US-ASCII; 
	name="0001-nilfs2-ubifs-Use-empty_aops-without-any-functions-de.patch"
Content-Disposition: attachment; 
	filename="0001-nilfs2-ubifs-Use-empty_aops-without-any-functions-de.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gm0dxy2h1

RnJvbSA4ZTQyMjliM2YyZmJhMjQ2ZDg3YjU5NjNmY2M0YWIzYTUwN2I2OTlhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZWRhdCBEaWxlayA8c2VkYXQuZGlsZWtAZ21haWwuY29tPgpE
YXRlOiBTYXQsIDIgQXByIDIwMTEgMTA6MjU6MTMgKzAyMDAKU3ViamVjdDogW1BBVENIXSBuaWxm
czIsdWJpZnM6IFVzZSBlbXB0eV9hb3BzIHdpdGhvdXQgYW55IGZ1bmN0aW9ucyBkZWZpbmVkCgpX
aXRoIHRoZSAtPnN5bmNfcGFnZSgpIGhvb2sgZ29uZSwgd2UgaGF2ZSBhIGZldyB1c2VycyB0aGF0
CmFkZCB0aGVpciBvd24gc3RhdGljIGFkZHJlc3Nfc3BhY2Vfb3BlcmF0aW9ucyB3aXRob3V0IGFu
eQpmdW5jdGlvbnMgZGVmaW5lZC4KCkZ1cnRoZXJtb3JlIGZvciBVQklGUzoKMS4gQ29uc2lkZXIg
aW5vZGVfb3BlcmF0aW9ucyBhbmQgZmlsZV9vcGVyYXRpb25zIGhhdmUgYWxzbwogICBubyBmdW5j
dGlvbnMgZGVmaW5lZAoyLiBNb3ZlIHthZGRyZXNzX3NwYWNlLGlub2RlLGZpbGV9X29wZXJhdGlv
bnMgdG8gY3JlYXRlX3hhdHRyKCkKMy4gVHJhbnNmb3JtIHRvIGVtcHR5X3thb3BzLGZvcHMsaW9w
c30KClNpZ25lZC1vZmYtYnk6IFNlZGF0IERpbGVrIDxzZWRhdC5kaWxla0BnbWFpbC5jb20+Ci0t
LQogZnMvbmlsZnMyL3BhZ2UuYyB8ICAgIDIgKy0KIGZzL3ViaWZzL3hhdHRyLmMgfCAgIDEzICsr
KysrKy0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2ZzL25pbGZzMi9wYWdlLmMgYi9mcy9uaWxmczIvcGFnZS5jCmlu
ZGV4IDlkMmRjNmIuLmU3ZGYzZjkgMTAwNjQ0Ci0tLSBhL2ZzL25pbGZzMi9wYWdlLmMKKysrIGIv
ZnMvbmlsZnMyL3BhZ2UuYwpAQCAtNDk1LDcgKzQ5NSw3IEBAIHVuc2lnbmVkIG5pbGZzX3BhZ2Vf
Y291bnRfY2xlYW5fYnVmZmVycyhzdHJ1Y3QgcGFnZSAqcGFnZSwKIHZvaWQgbmlsZnNfbWFwcGlu
Z19pbml0KHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLAogCQkJc3RydWN0IGJhY2tpbmdf
ZGV2X2luZm8gKmJkaSkKIHsKLQlzdGF0aWMgY29uc3Qgc3RydWN0IGFkZHJlc3Nfc3BhY2Vfb3Bl
cmF0aW9ucyBlbXB0eV9hb3BzOworCXN0YXRpYyBjb25zdCBzdHJ1Y3QgYWRkcmVzc19zcGFjZV9v
cGVyYXRpb25zIGVtcHR5X2FvcHMgPSB7fTsKIAogCW1hcHBpbmctPmhvc3QgPSBOVUxMOwogCW1h
cHBpbmctPmZsYWdzID0gMDsKZGlmZiAtLWdpdCBhL2ZzL3ViaWZzL3hhdHRyLmMgYi9mcy91Ymlm
cy94YXR0ci5jCmluZGV4IGM3NDQwMGYuLmQyMzdjNGYgMTAwNjQ0Ci0tLSBhL2ZzL3ViaWZzL3hh
dHRyLmMKKysrIGIvZnMvdWJpZnMveGF0dHIuYwpAQCAtNzksMTAgKzc5LDYgQEAgZW51bSB7CiAJ
U0VDVVJJVFlfWEFUVFIsCiB9OwogCi1zdGF0aWMgY29uc3Qgc3RydWN0IGlub2RlX29wZXJhdGlv
bnMgbm9uZV9pbm9kZV9vcGVyYXRpb25zOwotc3RhdGljIGNvbnN0IHN0cnVjdCBhZGRyZXNzX3Nw
YWNlX29wZXJhdGlvbnMgbm9uZV9hZGRyZXNzX29wZXJhdGlvbnM7Ci1zdGF0aWMgY29uc3Qgc3Ry
dWN0IGZpbGVfb3BlcmF0aW9ucyBub25lX2ZpbGVfb3BlcmF0aW9uczsKLQogLyoqCiAgKiBjcmVh
dGVfeGF0dHIgLSBjcmVhdGUgYW4gZXh0ZW5kZWQgYXR0cmlidXRlLgogICogQGM6IFVCSUZTIGZp
bGUtc3lzdGVtIGRlc2NyaXB0aW9uIG9iamVjdApAQCAtMTAwLDYgKzk2LDkgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgbm9uZV9maWxlX29wZXJhdGlvbnM7CiBzdGF0aWMg
aW50IGNyZWF0ZV94YXR0cihzdHJ1Y3QgdWJpZnNfaW5mbyAqYywgc3RydWN0IGlub2RlICpob3N0
LAogCQkJY29uc3Qgc3RydWN0IHFzdHIgKm5tLCBjb25zdCB2b2lkICp2YWx1ZSwgaW50IHNpemUp
CiB7CisJc3RhdGljIGNvbnN0IHN0cnVjdCBhZGRyZXNzX3NwYWNlX29wZXJhdGlvbnMgZW1wdHlf
YW9wcyA9IHt9OworCXN0YXRpYyBjb25zdCBzdHJ1Y3QgaW5vZGVfb3BlcmF0aW9ucyBlbXB0eV9p
b3BzID0ge307CisJc3RhdGljIGNvbnN0IHN0cnVjdCBmaWxlX29wZXJhdGlvbnMgZW1wdHlfZm9w
cyA9IHt9OwogCWludCBlcnI7CiAJc3RydWN0IGlub2RlICppbm9kZTsKIAlzdHJ1Y3QgdWJpZnNf
aW5vZGUgKnVpLCAqaG9zdF91aSA9IHViaWZzX2lub2RlKGhvc3QpOwpAQCAtMTMwLDkgKzEyOSw5
IEBAIHN0YXRpYyBpbnQgY3JlYXRlX3hhdHRyKHN0cnVjdCB1Ymlmc19pbmZvICpjLCBzdHJ1Y3Qg
aW5vZGUgKmhvc3QsCiAJfQogCiAJLyogUmUtZGVmaW5lIGFsbCBvcGVyYXRpb25zIHRvIGJlICJu
b3RoaW5nIiAqLwotCWlub2RlLT5pX21hcHBpbmctPmFfb3BzID0gJm5vbmVfYWRkcmVzc19vcGVy
YXRpb25zOwotCWlub2RlLT5pX29wID0gJm5vbmVfaW5vZGVfb3BlcmF0aW9uczsKLQlpbm9kZS0+
aV9mb3AgPSAmbm9uZV9maWxlX29wZXJhdGlvbnM7CisJaW5vZGUtPmlfbWFwcGluZy0+YV9vcHMg
PSAmZW1wdHlfYW9wczsKKwlpbm9kZS0+aV9vcCA9ICZlbXB0eV9pb3BzOworCWlub2RlLT5pX2Zv
cCA9ICZlbXB0eV9mb3BzOwogCiAJaW5vZGUtPmlfZmxhZ3MgfD0gU19TWU5DIHwgU19OT0FUSU1F
IHwgU19OT0NNVElNRSB8IFNfTk9RVU9UQTsKIAl1aSA9IHViaWZzX2lub2RlKGlub2RlKTsKLS0g
CjEuNy40LjIKCg==
--0016364184bd0d6577049feccb36--
