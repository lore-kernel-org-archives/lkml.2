Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3ADUez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:34:55 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:60452 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3ADUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:34:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-27-git-send-email-yinghai@kernel.org>
	<CAKocOOP=jh2XOFJtoz-uHO2cvb9NRfOGdc05LKg1JH-ToiUwwA@mail.gmail.com>
Date: Fri, 4 Jan 2013 12:34:51 -0800
X-Google-Sender-Auth: RWoa5QS7z7zqgZAyo9rKptoWsdA
Message-ID: <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
From: Yinghai Lu <yinghai@kernel.org>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: multipart/mixed; boundary=0015174c19e054d86404d27c69c4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174c19e054d86404d27c69c4
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Jan 4, 2013 at 9:50 AM, Shuah Khan <shuahkhan@gmail.com> wrote:
>
> This change doesn't take into account what swiolb was when
> pci_swiotlb_detect_override() is called. Instead of returning
> use_swiotlb like the original code did, it returns swiotlb which could
> be zero, if !enough_mem_for_swiotlb().
>
> Might work fine on Intel platforms, but not on systems where the IOMMU
> driver wants to enable swiotlb for some devices as in the case of AMD.
>
> AMD IOMMU driver enables swiotlb for devices that are not specified in
> IVRs and/or not in the AMD IOMMU scope, after it successfully
> initializes IOMMU. It will explicitely set switolb=1 to make sure
> reserved swiotlb memory is not released. This change will break that
> case.

in that case, we have to panic....

please check attached patch.

Also for those kind of systems, users must specify crashkernel_low=72M or
what ever for kdump.

Thanks

Yinghai

--0015174c19e054d86404d27c69c4
Content-Type: application/octet-stream; name="auto_switch_off_swiotlb.patch"
Content-Disposition: attachment; filename="auto_switch_off_swiotlb.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbjs5dth0

U3ViamVjdDogW1BBVENIXSB4ODY6IERvbid0IGVuYWJsZSBzd2lvdGxiIGlmIHRoZXJlIGlzIG5v
dCBlbm91Z2ggcmFtIGZvciBpdAoKTm9ybWFsIGJvb3QgcGF0aCBvbiBzeXN0ZW0gd2l0aCBpb21t
dSBzdXBwb3J0Ogpzd2lvdGxiIGJ1ZmZlciB3aWxsIGJlIGFsbG9jYXRlZCBlYXJseSBhdCBmaXJz
dCBhbmQgdGhlbiB0cnkgdG8gaW5pdGlhbGl6ZQppb21tdSwgaWYgaW9tbXUgZm9yIGludGVsIG9y
IGFtZCBjb3VsZCBzZXR1cCBwcm9wZXJseSwgc3dpb3RsYiBidWZmZXIKd2lsbCBiZSBmcmVlZC4K
ClRoZSBlYXJseSBhbGxvY2F0aW5nIGlzIHdpdGggYm9vdG1lbSwgYW5kIGdldCBwYW5pYyB3aGVu
IHdlIHRyeSB0byB1c2UKa2R1bXAgd2l0aCBidWZmZXIgYWJvdmUgNEcgb25seSBpZiBzd2lvdGxi
IGlzIGVuYWJsZWQuCgpiZWNhdXNlIGFjdHVhbGx5IHRoZSBrZXJuZWwgY2FuIGdvIG9uIHdpdGhv
dXQgc3dpb3RsYiwgYW5kIHVzZSBpbnRlbCBpb21tdS4KClRyeSBkaXNhYmxlIHN3aW90bGIgaWYg
dGhlcmUgaXMgbm90IGVub3VnaCByYW0gZm9yIGl0LgoKVGhhdCBpcyBmb3Iga2R1bXAgdG8gdXNl
IGtlcm5lbCBhYm92ZSA0Ry4KCi12MjogU2h1YWggS2hhbiA8c2h1YWhraGFuQGdtYWlsLmNvbT4g
cG9pbnRlZCBvdXQgdGhhdCBBTUQgaW9tbXUgdW5oYW5kbGVkCiAgICAgZGV2aWNlcyB0aGF0IG5l
ZWQgc3dpb3RsYiB3aWxsIGhhdmUgcHJvYmxlbS4KICAgICBJbiB0aGF0IGNhc2UsIHdlIGhhdmUg
dG8gcGFuaWMsIGJlY2F1c2Ugd2UgZG8gbm90IGVuYWJsZSBzd2lvdGxiCiAgICAgYmVmb3JlLgoK
U3VnZ2VzdGVkLWJ5OiBFcmljIFcuIEJpZWRlcm1hbiA8ZWJpZWRlcm1AeG1pc3Npb24uY29tPgpT
aWduZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aW5naGFpQGtlcm5lbC5vcmc+CkNjOiBLb25yYWQg
Unplc3p1dGVrIFdpbGsgPGtvbnJhZC53aWxrQG9yYWNsZS5jb20+CkNjOiBKb2VyZyBSb2VkZWwg
PGpvcm9AOGJ5dGVzLm9yZz4KCi0tLQogYXJjaC94ODYva2VybmVsL3BjaS1zd2lvdGxiLmMgfCAg
IDE0ICsrKysrKysrKystLS0tCiBkcml2ZXJzL2lvbW11L2FtZF9pb21tdS5jICAgICB8ICAgIDQg
KysrKwogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQoK
SW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9rZXJuZWwvcGNpLXN3aW90bGIuYwo9PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
Ci0tLSBsaW51eC0yLjYub3JpZy9hcmNoL3g4Ni9rZXJuZWwvcGNpLXN3aW90bGIuYworKysgbGlu
dXgtMi42L2FyY2gveDg2L2tlcm5lbC9wY2ktc3dpb3RsYi5jCkBAIC02LDYgKzYsNyBAQAogI2lu
Y2x1ZGUgPGxpbnV4L3N3aW90bGIuaD4KICNpbmNsdWRlIDxsaW51eC9ib290bWVtLmg+CiAjaW5j
bHVkZSA8bGludXgvZG1hLW1hcHBpbmcuaD4KKyNpbmNsdWRlIDxsaW51eC9tZW1ibG9jay5oPgog
CiAjaW5jbHVkZSA8YXNtL2lvbW11Lmg+CiAjaW5jbHVkZSA8YXNtL3N3aW90bGIuaD4KQEAgLTUw
LDYgKzUxLDExIEBAIHN0YXRpYyBzdHJ1Y3QgZG1hX21hcF9vcHMgc3dpb3RsYl9kbWFfb3AKIAku
ZG1hX3N1cHBvcnRlZCA9IE5VTEwsCiB9OwogCitzdGF0aWMgYm9vbCBfX2luaXQgZW5vdWdoX21l
bV9mb3Jfc3dpb3RsYih2b2lkKQoreworCS8qIGRvIHdlIGhhdmUgbGVzcyB0aGFuIDFNIFJBTSB1
bmRlciA0RyA/ICovCisJcmV0dXJuIG1lbWJsb2NrX21lbV9zaXplKDFVTEw8PCgzMi1QQUdFX1NI
SUZUKSkgPiAoMVVMTDw8MjApOworfQogLyoKICAqIHBjaV9zd2lvdGxiX2RldGVjdF9vdmVycmlk
ZSAtIHNldCBzd2lvdGxiIHRvIDEgaWYgbmVjZXNzYXJ5CiAgKgpAQCAtNTgsMTIgKzY0LDEyIEBA
IHN0YXRpYyBzdHJ1Y3QgZG1hX21hcF9vcHMgc3dpb3RsYl9kbWFfb3AKICAqLwogaW50IF9faW5p
dCBwY2lfc3dpb3RsYl9kZXRlY3Rfb3ZlcnJpZGUodm9pZCkKIHsKLQlpbnQgdXNlX3N3aW90bGIg
PSBzd2lvdGxiIHwgc3dpb3RsYl9mb3JjZTsKLQogCWlmIChzd2lvdGxiX2ZvcmNlKQogCQlzd2lv
dGxiID0gMTsKKwllbHNlIGlmICghZW5vdWdoX21lbV9mb3Jfc3dpb3RsYigpKQorCQlzd2lvdGxi
ID0gMDsKIAotCXJldHVybiB1c2Vfc3dpb3RsYjsKKwlyZXR1cm4gc3dpb3RsYjsKIH0KIElPTU1V
X0lOSVRfRklOSVNIKHBjaV9zd2lvdGxiX2RldGVjdF9vdmVycmlkZSwKIAkJICBwY2lfeGVuX3N3
aW90bGJfZGV0ZWN0LApAQCAtNzgsNyArODQsNyBAQCBpbnQgX19pbml0IHBjaV9zd2lvdGxiX2Rl
dGVjdF80Z2Iodm9pZCkKIHsKIAkvKiBkb24ndCBpbml0aWFsaXplIHN3aW90bGIgaWYgaW9tbXU9
b2ZmIChub19pb21tdT0xKSAqLwogI2lmZGVmIENPTkZJR19YODZfNjQKLQlpZiAoIW5vX2lvbW11
ICYmIG1heF9wZm4gPiBNQVhfRE1BMzJfUEZOKQorCWlmICghbm9faW9tbXUgJiYgbWF4X3BmbiA+
IE1BWF9ETUEzMl9QRk4gJiYgZW5vdWdoX21lbV9mb3Jfc3dpb3RsYigpKQogCQlzd2lvdGxiID0g
MTsKICNlbmRpZgogCXJldHVybiBzd2lvdGxiOwpJbmRleDogbGludXgtMi42L2RyaXZlcnMvaW9t
bXUvYW1kX2lvbW11LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvZHJpdmVycy9pb21t
dS9hbWRfaW9tbXUuYworKysgbGludXgtMi42L2RyaXZlcnMvaW9tbXUvYW1kX2lvbW11LmMKQEAg
LTMxNDQsNiArMzE0NCw3IEBAIGludCBfX2luaXQgYW1kX2lvbW11X2luaXRfZG1hX29wcyh2b2lk
KQogewogCXN0cnVjdCBhbWRfaW9tbXUgKmlvbW11OwogCWludCByZXQsIHVuaGFuZGxlZDsKKwlp
bnQgc3dpb3RsYl9vcmlnOwogCiAJLyoKIAkgKiBmaXJzdCBhbGxvY2F0ZSBhIGRlZmF1bHQgcHJv
dGVjdGlvbiBkb21haW4gZm9yIGV2ZXJ5IElPTU1VIHdlCkBAIC0zMTY2LDEyICszMTY3LDE1IEBA
IGludCBfX2luaXQgYW1kX2lvbW11X2luaXRfZG1hX29wcyh2b2lkKQogCXByZWFsbG9jX3Byb3Rl
Y3Rpb25fZG9tYWlucygpOwogCiAJaW9tbXVfZGV0ZWN0ZWQgPSAxOworCXN3aW90bGJfb3JpZyA9
IHN3aW90bGI7CiAJc3dpb3RsYiA9IDA7CiAKIAkvKiBNYWtlIHRoZSBkcml2ZXIgZmluYWxseSB2
aXNpYmxlIHRvIHRoZSBkcml2ZXJzICovCiAJdW5oYW5kbGVkID0gZGV2aWNlX2RtYV9vcHNfaW5p
dCgpOwogCWlmICh1bmhhbmRsZWQgJiYgbWF4X3BmbiA+IE1BWF9ETUEzMl9QRk4pIHsKIAkJLyog
VGhlcmUgYXJlIHVuaGFuZGxlZCBkZXZpY2VzIC0gaW5pdGlhbGl6ZSBzd2lvdGxiIGZvciB0aGVt
ICovCisJCWlmICghc3dpb3RsYl9vcmlnKQorCQkJcGFuaWMoImNhbiBub3QgZW5hYmxlIHN3aW90
bGIgZm9yIHVuaGFuZGxlZCBkZXZpY2VzIGJ5IEFNRCBpb21tdSFcbiIpOwogCQlzd2lvdGxiID0g
MTsKIAl9CiAK
--0015174c19e054d86404d27c69c4--
