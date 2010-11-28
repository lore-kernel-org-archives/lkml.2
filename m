Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab0K1GYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 01:24:10 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37674 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0K1GYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 01:24:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=xUD8O1WDadCdNXSzBIoIp2594fmciQi6OPnx0qIkssHBkLNQXvNySrQekTH/nksA96
         YDdlLPyuyyYpGYGzJWYtBDNw2hi5grXT6WnGwyS5oYThWTSqjIMm5kz4FX+ZBbCd7jlX
         QEMsfV1caBKfpepgxXaJkCdl3NMWirr4rkJos=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20101128032830.GA12139@amd>
References: <cover.1290852958.git.npiggin@kernel.dk>
	<AANLkTikRDO0C4Giz6vVHeMnHMtOGO5N1gN4wChEwBLpk@mail.gmail.com>
	<20101128032830.GA12139@amd>
Date: Sun, 28 Nov 2010 07:24:06 +0100
Message-ID: <AANLkTinVPzv6q1Vq8mfy_b4ujm6cAesobEe3+6ryfq6V@mail.gmail.com>
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Anca Emanuel <anca.emanuel@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636310649a94cfb0496170036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636310649a94cfb0496170036
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 28, 2010 at 4:28 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> On Sat, Nov 27, 2010 at 05:04:08PM +0200, Anca Emanuel wrote:
>> On Sat, Nov 27, 2010 at 12:15 PM, Nick Piggin <npiggin@kernel.dk> wrote:
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.gi=
t vfs-scale-working
>>
>> I get:
>> =C2=A0 CC [M] =C2=A0fs/cifs/inode.o
>> fs/cifs/inode.c: In function =E2=80=98inode_has_hashed_dentries=E2=80=99=
:
>> fs/cifs/inode.c:807: error: =E2=80=98dcache_inode_lock=E2=80=99 undeclar=
ed (first use
>> in this function)
>> fs/cifs/inode.c:807: error: (Each undeclared identifier is reported only=
 once
>> fs/cifs/inode.c:807: error: for each function it appears in.)
>> make[3]: *** [fs/cifs/inode.o] Error 1
>> make[2]: *** [fs/cifs] Error 2
>> make[1]: *** [fs] Error 2
>>
>> I used the latest mainline.
>
> Sorry, missed a conversion, it just needs to be changed to
> inode->i_lock. Pushed the fix to git.
>

I attached a patch to my posting in [1] but it was somehow "eaten"
(here in my mbox the patch is definitely attached).
Patchwork is also not listing my patch.
Anyway, it's fixed - that's good.

I have to check why I get a Call trace with systemd-v15 but not with
sysvinit package here on Debian.

- Sedat -

[1] http://lkml.org/lkml/2010/11/27/145

--001636310649a94cfb0496170036
Content-Type: plain/text; 
	name="fs-cifs-inode.c-Fix-error-dcache_inode_lock-undeclared.patch"
Content-Disposition: attachment; 
	filename="fs-cifs-inode.c-Fix-error-dcache_inode_lock-undeclared.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gh1jlytm0

SW5kZXg6IGxpbnV4LTIuNi9mcy9jaWZzL2lub2RlLmMKPT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42
Lm9yaWcvZnMvY2lmcy9pbm9kZS5jCisrKyBsaW51eC0yLjYvZnMvY2lmcy9pbm9kZS5jCkBAIC04
MDQsMTQgKzgwNCwxNCBAQCBpbm9kZV9oYXNfaGFzaGVkX2RlbnRyaWVzKHN0cnVjdCBpbm9kZSAq
CiB7CiAJc3RydWN0IGRlbnRyeSAqZGVudHJ5OwogCi0Jc3Bpbl9sb2NrKCZkY2FjaGVfaW5vZGVf
bG9jayk7CisJc3Bpbl9sb2NrKCZpbm9kZS0+aV9sb2NrKTsKIAlsaXN0X2Zvcl9lYWNoX2VudHJ5
KGRlbnRyeSwgJmlub2RlLT5pX2RlbnRyeSwgZF9hbGlhcykgewogCQlpZiAoIWRfdW5oYXNoZWQo
ZGVudHJ5KSB8fCBJU19ST09UKGRlbnRyeSkpIHsKLQkJCXNwaW5fdW5sb2NrKCZkY2FjaGVfaW5v
ZGVfbG9jayk7CisJCQlzcGluX3VubG9jaygmaW5vZGUtPmlfbG9jayk7CiAJCQlyZXR1cm4gdHJ1
ZTsKIAkJfQogCX0KLQlzcGluX3VubG9jaygmZGNhY2hlX2lub2RlX2xvY2spOworCXNwaW5fdW5s
b2NrKCZpbm9kZS0+aV9sb2NrKTsKIAlyZXR1cm4gZmFsc2U7CiB9CiAK
--001636310649a94cfb0496170036--
