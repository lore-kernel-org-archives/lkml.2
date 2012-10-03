Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab2JCQjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:39:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64905 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab2JCQjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <506C562E.5090909@redhat.com>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com>
 <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com>
 <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com> <506C562E.5090909@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 09:38:52 -0700
X-Google-Sender-Auth: h89a_UDBDuPgQv7_DeMKdH4FpfU
Message-ID: <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: multipart/mixed; boundary=e89a8f838ed95d852104cb2a47f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f838ed95d852104cb2a47f8
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Oct 3, 2012 at 8:13 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
>
> Yes. The issue was noticed with media drivers when people started using the
> drivers on Fedora 17, witch came with udev-182. There's an open
> bugzilla there:
>         https://bugzilla.redhat.com/show_bug.cgi?id=827538

Yeah, that bugzilla shows the problem with Kay as a maintainer too,
not willing to own up to problems he caused.

Can you actually see the problem? I did add the attached patch as an
attachment to the bugzilla, so the reporter there may be able to test
it, but it's been open for a long while..

Anyway. Attached is a really stupid patch that tries to do the "direct
firmware load" as suggested by Ivan. It has not been tested very
extensively at all (but I did test that it loaded the brcmsmac
firmware images on my laptop so it has the *potential* to work).

It has a few extra printk's sprinkled in (to show whether it does
anything or not), and it has a few other issues, but it might be worth
testing as a starting point.

We are apparently better off trying to avoid udev like the plague.
Doing something very similar to this for module loading is probably a
good idea too.

I'm adding Ming Lei to the participants too, because hooking into the
firmware loader like this means that the image doesn't get cached.
Which is sad. I'm hoping Ming Lei might be open to trying to fix that.

Hmm?

                   Linus

--e89a8f838ed95d852104cb2a47f8
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7unmexf0

IGRyaXZlcnMvYmFzZS9maXJtd2FyZV9jbGFzcy5jIHwgNTkgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDU4IGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jhc2UvZmlybXdhcmVfY2xhc3Mu
YyBiL2RyaXZlcnMvYmFzZS9maXJtd2FyZV9jbGFzcy5jCmluZGV4IDZlMjEwODAyYzM3Yi4uMmZm
Y2I0MDMwMDY1IDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jhc2UvZmlybXdhcmVfY2xhc3MuYworKysg
Yi9kcml2ZXJzL2Jhc2UvZmlybXdhcmVfY2xhc3MuYwpAQCAtNTUsNiArNTUsNTQgQEAgc3RhdGlj
IGJvb2wgZndfZ2V0X2J1aWx0aW5fZmlybXdhcmUoc3RydWN0IGZpcm13YXJlICpmdywgY29uc3Qg
Y2hhciAqbmFtZSkKIAlyZXR1cm4gZmFsc2U7CiB9CiAKK3N0YXRpYyBib29sIGZ3X3JlYWRfZmls
ZV9jb250ZW50cyhzdHJ1Y3QgZmlsZSAqZmlsZSwgc3RydWN0IGZpcm13YXJlICpmdykKK3sKKwls
b2ZmX3Qgc2l6ZSwgcG9zOworCXN0cnVjdCBpbm9kZSAqaW5vZGUgPSBmaWxlLT5mX2RlbnRyeS0+
ZF9pbm9kZTsKKwljaGFyICpidWY7CisKKwlpZiAoIVNfSVNSRUcoaW5vZGUtPmlfbW9kZSkpCisJ
CXJldHVybiBmYWxzZTsKKwlzaXplID0gaV9zaXplX3JlYWQoaW5vZGUpOworCWJ1ZiA9IHZtYWxs
b2Moc2l6ZSk7CisJaWYgKCFidWYpCisJCXJldHVybiBmYWxzZTsKKwlwb3MgPSAwOworCWlmICh2
ZnNfcmVhZChmaWxlLCBidWYsIHNpemUsICZwb3MpICE9IHNpemUpIHsKKwkJdmZyZWUoYnVmKTsK
KwkJcmV0dXJuIGZhbHNlOworCX0KKwlmdy0+ZGF0YSA9IGJ1ZjsKKwlmdy0+c2l6ZSA9IHNpemU7
CisJcmV0dXJuIHRydWU7Cit9CisKK3N0YXRpYyBib29sIGZ3X2dldF9maWxlc3lzdGVtX2Zpcm13
YXJlKHN0cnVjdCBmaXJtd2FyZSAqZncsIGNvbnN0IGNoYXIgKm5hbWUpCit7CisJaW50IGk7CisJ
Ym9vbCBzdWNjZXNzID0gZmFsc2U7CisJY29uc3QgY2hhciAqZndfcGF0aFtdID0geyAiL2xpYi9m
aXJtd2FyZS91cGRhdGUiLCAiL2Zpcm13YXJlIiwgIi9saWIvZmlybXdhcmUiIH07CisJY2hhciAq
cGF0aCA9IF9fZ2V0bmFtZSgpOworCitwcmludGsoIlRyeWluZyB0byBsb2FkIGZ3ICclcycgIiwg
bmFtZSk7CisJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoZndfcGF0aCk7IGkrKykgeworCQlz
dHJ1Y3QgZmlsZSAqZmlsZTsKKwkJc25wcmludGYocGF0aCwgUEFUSF9NQVgsICIlcy8lcyIsIGZ3
X3BhdGhbaV0sIG5hbWUpOworCisJCWZpbGUgPSBmaWxwX29wZW4ocGF0aCwgT19SRE9OTFksIDAp
OworCQlpZiAoSVNfRVJSKGZpbGUpKQorCQkJY29udGludWU7CitwcmludGsoImZyb20gZmlsZSAn
JXMnICIsIHBhdGgpOworCQlzdWNjZXNzID0gZndfcmVhZF9maWxlX2NvbnRlbnRzKGZpbGUsIGZ3
KTsKKwkJZmlscF9jbG9zZShmaWxlLCBOVUxMKTsKKwkJaWYgKHN1Y2Nlc3MpCisJCQlicmVhazsK
Kwl9CitwcmludGsoIiAlcy5cbiIsIHN1Y2Nlc3MgPyAiT2siIDogImZhaWxlZCIpOworCV9fcHV0
bmFtZShwYXRoKTsKKwlyZXR1cm4gc3VjY2VzczsKK30KKwogc3RhdGljIGJvb2wgZndfaXNfYnVp
bHRpbl9maXJtd2FyZShjb25zdCBzdHJ1Y3QgZmlybXdhcmUgKmZ3KQogewogCXN0cnVjdCBidWls
dGluX2Z3ICpiX2Z3OwpAQCAtMzQ2LDcgKzM5NCwxMSBAQCBzdGF0aWMgc3NpemVfdCBmaXJtd2Fy
ZV9sb2FkaW5nX3Nob3coc3RydWN0IGRldmljZSAqZGV2LAogLyogZmlybXdhcmUgaG9sZHMgdGhl
IG93bmVyc2hpcCBvZiBwYWdlcyAqLwogc3RhdGljIHZvaWQgZmlybXdhcmVfZnJlZV9kYXRhKGNv
bnN0IHN0cnVjdCBmaXJtd2FyZSAqZncpCiB7Ci0JV0FSTl9PTighZnctPnByaXYpOworCS8qIExv
YWRlZCBkaXJlY3RseT8gKi8KKwlpZiAoIWZ3LT5wcml2KSB7CisJCXZmcmVlKGZ3LT5kYXRhKTsK
KwkJcmV0dXJuOworCX0KIAlmd19mcmVlX2J1Zihmdy0+cHJpdik7CiB9CiAKQEAgLTcwOSw2ICs3
NjEsMTEgQEAgX3JlcXVlc3RfZmlybXdhcmVfcHJlcGFyZShjb25zdCBzdHJ1Y3QgZmlybXdhcmUg
KipmaXJtd2FyZV9wLCBjb25zdCBjaGFyICpuYW1lLAogCQlyZXR1cm4gTlVMTDsKIAl9CiAKKwlp
ZiAoZndfZ2V0X2ZpbGVzeXN0ZW1fZmlybXdhcmUoZmlybXdhcmUsIG5hbWUpKSB7CisJCWRldl9k
YmcoZGV2aWNlLCAiZmlybXdhcmU6IGRpcmVjdC1sb2FkaW5nIGZpcm13YXJlICVzXG4iLCBuYW1l
KTsKKwkJcmV0dXJuIE5VTEw7CisJfQorCiAJcmV0ID0gZndfbG9va3VwX2FuZF9hbGxvY2F0ZV9i
dWYobmFtZSwgJmZ3X2NhY2hlLCAmYnVmKTsKIAlpZiAoIXJldCkKIAkJZndfcHJpdiA9IGZ3X2Ny
ZWF0ZV9pbnN0YW5jZShmaXJtd2FyZSwgbmFtZSwgZGV2aWNlLAo=
--e89a8f838ed95d852104cb2a47f8--
