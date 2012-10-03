Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab2JCRcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 13:32:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42368 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab2JCRcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 13:32:32 -0400
MIME-Version: 1.0
In-Reply-To: <20121003170907.GA23473@ZenIV.linux.org.uk>
References: <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com>
 <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
 <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com> <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Oct 2012 10:32:08 -0700
X-Google-Sender-Auth: 1M4SNs1OLXgIfHUk16mYP2QbXSg
Message-ID: <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use request_firmware_nowait()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: multipart/mixed; boundary=f46d0444ecf5fd8f8304cb2b0593
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0444ecf5fd8f8304cb2b0593
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Oct 3, 2012 at 10:09 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> +       if (!S_ISREG(inode->i_mode))
> +               return false;
> +       size = i_size_read(inode);
>
> Probably better to do vfs_getattr() and check mode and size in kstat; if
> it's sufficiently hot for that to hurt, we are fucked anyway.
>
> +               file = filp_open(path, O_RDONLY, 0);
> +               if (IS_ERR(file))
> +                       continue;
> +printk("from file '%s' ", path);
> +               success = fw_read_file_contents(file, fw);
> +               filp_close(file, NULL);
>
> fput(file), please.  We have enough misuses of filp_close() as it is...

Ok, like this?

                      Linus

--f46d0444ecf5fd8f8304cb2b0593
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7upr98f0

IGRyaXZlcnMvYmFzZS9maXJtd2FyZV9jbGFzcy5jIHwgNzMgKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcyIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2Jhc2UvZmlybXdhcmVfY2xhc3Mu
YyBiL2RyaXZlcnMvYmFzZS9maXJtd2FyZV9jbGFzcy5jCmluZGV4IDZlMjEwODAyYzM3Yi4uMzhm
ZWFjNGFmOTkxIDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jhc2UvZmlybXdhcmVfY2xhc3MuYworKysg
Yi9kcml2ZXJzL2Jhc2UvZmlybXdhcmVfY2xhc3MuYwpAQCAtMjEsNiArMjEsNyBAQAogI2luY2x1
ZGUgPGxpbnV4L2Zpcm13YXJlLmg+CiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPgogI2luY2x1ZGUg
PGxpbnV4L3NjaGVkLmg+CisjaW5jbHVkZSA8bGludXgvZmlsZS5oPgogI2luY2x1ZGUgPGxpbnV4
L2xpc3QuaD4KICNpbmNsdWRlIDxsaW51eC9hc3luYy5oPgogI2luY2x1ZGUgPGxpbnV4L3BtLmg+
CkBAIC0zMyw2ICszNCw2NyBAQCBNT0RVTEVfQVVUSE9SKCJNYW51ZWwgRXN0cmFkYSBTYWlueiIp
OwogTU9EVUxFX0RFU0NSSVBUSU9OKCJNdWx0aSBwdXJwb3NlIGZpcm13YXJlIGxvYWRpbmcgc3Vw
cG9ydCIpOwogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwogCisvKiBEb24ndCBpbmxpbmUgdGhpczog
J3N0cnVjdCBrc3RhdCcgaXMgYmlnZ2lzaCAqLworc3RhdGljIG5vaW5saW5lIGxvbmcgZndfZmls
ZV9zaXplKHN0cnVjdCBmaWxlICpmaWxlKQoreworCXN0cnVjdCBrc3RhdCBzdDsKKwlpZiAodmZz
X2dldGF0dHIoZmlsZS0+Zl9wYXRoLm1udCwgZmlsZS0+Zl9wYXRoLmRlbnRyeSwgJnN0KSkKKwkJ
cmV0dXJuIC0xOworCWlmICghU19JU1JFRyhzdC5tb2RlKSkKKwkJcmV0dXJuIC0xOworCWlmIChz
dC5zaXplICE9IChsb25nKXN0LnNpemUpCisJCXJldHVybiAtMTsKKwlyZXR1cm4gc3Quc2l6ZTsK
K30KKworc3RhdGljIGJvb2wgZndfcmVhZF9maWxlX2NvbnRlbnRzKHN0cnVjdCBmaWxlICpmaWxl
LCBzdHJ1Y3QgZmlybXdhcmUgKmZ3KQoreworCWxvZmZfdCBwb3M7CisJbG9uZyBzaXplOworCWNo
YXIgKmJ1ZjsKKworCXNpemUgPSBmd19maWxlX3NpemUoZmlsZSk7CisJaWYgKHNpemUgPCAwKQor
CQlyZXR1cm4gZmFsc2U7CisJYnVmID0gdm1hbGxvYyhzaXplKTsKKwlpZiAoIWJ1ZikKKwkJcmV0
dXJuIGZhbHNlOworCXBvcyA9IDA7CisJaWYgKHZmc19yZWFkKGZpbGUsIGJ1Ziwgc2l6ZSwgJnBv
cykgIT0gc2l6ZSkgeworCQl2ZnJlZShidWYpOworCQlyZXR1cm4gZmFsc2U7CisJfQorCWZ3LT5k
YXRhID0gYnVmOworCWZ3LT5zaXplID0gc2l6ZTsKKwlyZXR1cm4gdHJ1ZTsKK30KKworc3RhdGlj
IGJvb2wgZndfZ2V0X2ZpbGVzeXN0ZW1fZmlybXdhcmUoc3RydWN0IGZpcm13YXJlICpmdywgY29u
c3QgY2hhciAqbmFtZSkKK3sKKwlpbnQgaTsKKwlib29sIHN1Y2Nlc3MgPSBmYWxzZTsKKwljb25z
dCBjaGFyICpmd19wYXRoW10gPSB7ICIvbGliL2Zpcm13YXJlL3VwZGF0ZSIsICIvZmlybXdhcmUi
LCAiL2xpYi9maXJtd2FyZSIgfTsKKwljaGFyICpwYXRoID0gX19nZXRuYW1lKCk7CisKK3ByaW50
aygiVHJ5aW5nIHRvIGxvYWQgZncgJyVzJyAiLCBuYW1lKTsKKwlmb3IgKGkgPSAwOyBpIDwgQVJS
QVlfU0laRShmd19wYXRoKTsgaSsrKSB7CisJCXN0cnVjdCBmaWxlICpmaWxlOworCQlzbnByaW50
ZihwYXRoLCBQQVRIX01BWCwgIiVzLyVzIiwgZndfcGF0aFtpXSwgbmFtZSk7CisKKwkJZmlsZSA9
IGZpbHBfb3BlbihwYXRoLCBPX1JET05MWSwgMCk7CisJCWlmIChJU19FUlIoZmlsZSkpCisJCQlj
b250aW51ZTsKK3ByaW50aygiZnJvbSBmaWxlICclcycgIiwgcGF0aCk7CisJCXN1Y2Nlc3MgPSBm
d19yZWFkX2ZpbGVfY29udGVudHMoZmlsZSwgZncpOworCQlmcHV0KGZpbGUpOworCQlpZiAoc3Vj
Y2VzcykKKwkJCWJyZWFrOworCX0KK3ByaW50aygiICVzLlxuIiwgc3VjY2VzcyA/ICJPayIgOiAi
ZmFpbGVkIik7CisJX19wdXRuYW1lKHBhdGgpOworCXJldHVybiBzdWNjZXNzOworfQorCiAvKiBC
dWlsdGluIGZpcm13YXJlIHN1cHBvcnQgKi8KIAogI2lmZGVmIENPTkZJR19GV19MT0FERVIKQEAg
LTM0Niw3ICs0MDgsMTEgQEAgc3RhdGljIHNzaXplX3QgZmlybXdhcmVfbG9hZGluZ19zaG93KHN0
cnVjdCBkZXZpY2UgKmRldiwKIC8qIGZpcm13YXJlIGhvbGRzIHRoZSBvd25lcnNoaXAgb2YgcGFn
ZXMgKi8KIHN0YXRpYyB2b2lkIGZpcm13YXJlX2ZyZWVfZGF0YShjb25zdCBzdHJ1Y3QgZmlybXdh
cmUgKmZ3KQogewotCVdBUk5fT04oIWZ3LT5wcml2KTsKKwkvKiBMb2FkZWQgZGlyZWN0bHk/ICov
CisJaWYgKCFmdy0+cHJpdikgeworCQl2ZnJlZShmdy0+ZGF0YSk7CisJCXJldHVybjsKKwl9CiAJ
ZndfZnJlZV9idWYoZnctPnByaXYpOwogfQogCkBAIC03MDksNiArNzc1LDExIEBAIF9yZXF1ZXN0
X2Zpcm13YXJlX3ByZXBhcmUoY29uc3Qgc3RydWN0IGZpcm13YXJlICoqZmlybXdhcmVfcCwgY29u
c3QgY2hhciAqbmFtZSwKIAkJcmV0dXJuIE5VTEw7CiAJfQogCisJaWYgKGZ3X2dldF9maWxlc3lz
dGVtX2Zpcm13YXJlKGZpcm13YXJlLCBuYW1lKSkgeworCQlkZXZfZGJnKGRldmljZSwgImZpcm13
YXJlOiBkaXJlY3QtbG9hZGluZyBmaXJtd2FyZSAlc1xuIiwgbmFtZSk7CisJCXJldHVybiBOVUxM
OworCX0KKwogCXJldCA9IGZ3X2xvb2t1cF9hbmRfYWxsb2NhdGVfYnVmKG5hbWUsICZmd19jYWNo
ZSwgJmJ1Zik7CiAJaWYgKCFyZXQpCiAJCWZ3X3ByaXYgPSBmd19jcmVhdGVfaW5zdGFuY2UoZmly
bXdhcmUsIG5hbWUsIGRldmljZSwK
--f46d0444ecf5fd8f8304cb2b0593--
