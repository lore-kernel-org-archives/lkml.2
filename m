Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab2IUVSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:18:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47474 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab2IUVSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:18:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7S3DCMq1Rsj0Ya856ebyqFT_1pF2yirzaHrGPSSUJinQ@mail.gmail.com>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
	<1348080894-23412-1-git-send-email-yinghai@kernel.org>
	<1348080894-23412-2-git-send-email-yinghai@kernel.org>
	<CAErSpo7S3DCMq1Rsj0Ya856ebyqFT_1pF2yirzaHrGPSSUJinQ@mail.gmail.com>
Date: Fri, 21 Sep 2012 14:18:00 -0700
X-Google-Sender-Auth: sjAWYrPzrd-JNwy-cZdrNACFAAo
Message-ID: <CAE9FiQVP7Q2p2zN8pXubcgx=7CFAt9pw0tWcWpuPddO9U7pR5A@mail.gmail.com>
Subject: Re: [PATCH 01/40] PCI: fix default vga ref_count
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Julia Lawall <julia@diku.dk>, Matthew Garrett <mjg@redhat.com>
Content-Type: multipart/mixed; boundary=0015175884fc55a90404ca3cc6cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175884fc55a90404ca3cc6cd
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Sep 21, 2012 at 1:52 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Sep 19, 2012 at 12:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> --- a/drivers/gpu/vga/vgaarb.c
>> +++ b/drivers/gpu/vga/vgaarb.c
>> @@ -141,6 +141,12 @@ EXPORT_SYMBOL_GPL(vga_default_device);
>>
>>  void vga_set_default_device(struct pci_dev *pdev)
>>  {
>> +       if (vga_default)
>> +               pci_dev_put(vga_default);
>> +
>> +       if (pdev)
>> +               pdev = pci_dev_get(pdev);
>> +
>>         vga_default = pdev;
>
> I think this is equivalent to:
>
>     pci_dev_put(vga_default);
>     vga_default = pci_dev_get(pdev);

ah, i missed that, pci_dev_put and pci_dev_get check that inside.

>
> I haven't seen an answer to Matthew's question about whether we want
> to check for "vga_default == pdev".

yes, that could avoid the extra put/get pair.

Please check updated version.

-Yinghai

--0015175884fc55a90404ca3cc6cd
Content-Type: application/octet-stream; name="fix_vgarab_add_x.patch"
Content-Disposition: attachment; filename="fix_vgarab_add_x.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7dsizhi0

U3ViamVjdDogW1BBVENIXSBQQ0k6IGZpeCBkZWZhdWx0IHZnYSByZWZfY291bnQKCndoZW4gX19B
UkNIX0hBU19WR0FfREVGQVVMVF9ERVZJQ0UgaXMgbm90IGRlZmluZWQsIGFrYSBFRklGQiBpcyBu
b3QgdXNlZCwKZm9yIHN0YXRpYyBwYXRoLCB2Z2FfZGVmYXVsdCBzZXR0aW5nIGlzIHRocm91Z2gg
dmdhX2FyYml0ZXJfYWRkX3BjaV9kZXZpY2UuCmFuZCBsYXRlciB4ODYgcGNpX2ZpeHVwX3ZpZGVv
LCB3aWxsIHNraXAgc2V0dGluZyBhZ2Fpbi4KLSBzdWJzeXNfaW5pdGNhbGwodmdhX2FyYl9kZXZp
Y2VfaW5pdCkgY29tZSBmaXJzdCB0byBjYWxsIHZnYV9hcmJpdGVyX2FkZF9wY2lfZGV2aWNlLiBJ
dCB3aWxsIGNhbGwgcGNpX2dldF9kZXYgdG8gaG9sZCBvbmUgcmVmZXJlbmNlLgoKZm9yIGhvdHBs
dWcgYWRkIHBhdGgsIGV2ZW4gdmdhX2FyYml0ZXJfYWRkX3BjaV9kZXZpY2UgaXMgY2FsbGVkIHZp
YSBub3RpZmllciwKYnV0IGl0IHdpbGwgY2hlY2sgVkdBX1JTUkNfTEVHQUNZX01BU0sgdGhhdCBp
cyBub3Qgc2V0IGZvciBob3RwbHVnIHBhdGguClNvIHg4NiBwY2lfZml4dXBfdmlkZW8gd2lsbCB0
YWtlIG92ZXIgdG8gY2FsbCB2Z2Ffc2V0X2RlZmF1bHRfZGV2aWNlKCkuCkl0IHdpbGwgbm90IGhv
bGQgb25lIHJlZnJlbmNlLgoKTGF0ZXIgZm9yIGhvdHBsdWcgcmVtb3ZlIHBhdGgsIHZnYV9hcmJp
dGVyX2RlbF9wY2lfZGV2aWNlIHRoYXQgZG9lcyBub3QgY2hlY2sKVkdBX1JTUkNfTEVHQUNZX01B
U0sgd2lsbCBjYWxsIHB1dF9kZXZpY2UgYW5kIGl0IHdpbGwgY2F1c2UgcmVmX2NvdW50IHRvCmRl
Y3JlYXNlIGV4dHJhLiB0aGF0IHdpbGwgaGF2ZSB0aGF0IHBjaSBkZXZpY2UgZ2V0IGRlbGV0ZWQg
ZWFybHkgd3JvbmdseS4KCk5lZWQgdG8gbWFrZSBnZXQvcHV0IGJhbGFuY2UgZm9yIGJvdGggY2Fz
ZXMuCgotdjI6IEFjY29yZGluZyB0byBCam9ybiwgdXBkYXRlIHZnYV9zZXRfZGVmYXVsdF9kZXZp
Y2UgaW5zdGVhZC4uLgotdjM6IFJlbW92ZSBleHRyYSBjaGVja2luZyBhYm91dCBudWxsIHRoYXQg
cG9pbnRlZCBvdXQgYnkgQmpvcm4uCiAgICAgQWRkIGV4dHJhIGNoZWNrIGZvciBzYW1lIHZhbHVl
LCB0byBhdm9pZCBleHRyYSBwdXQvZ2V0IHBhaXIsIHN1Z2dlc3RlZCBieQoJTWF0dGhldy4KClNp
Z25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KQ2M6IHg4NkBrZXJu
ZWwub3JnCkNjOiBEYXZlIEFpcmxpZSA8YWlybGllZEByZWRoYXQuY29tPgpDYzogQW5kcmV3IE1v
cnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz4KQ2M6IEp1bGlhIExhd2FsbCA8anVsaWFA
ZGlrdS5kaz4KQ2M6IE1hdHRoZXcgR2FycmV0dCA8bWpnQHJlZGhhdC5jb20+CgotLS0KIGRyaXZl
cnMvZ3B1L3ZnYS92Z2FhcmIuYyB8ICAgMTQgKysrKysrKystLS0tLS0KIDEgZmlsZSBjaGFuZ2Vk
LCA4IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgtMi42L2RyaXZl
cnMvZ3B1L3ZnYS92Z2FhcmIuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYub3JpZy9kcml2ZXJz
L2dwdS92Z2EvdmdhYXJiLmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2dwdS92Z2EvdmdhYXJiLmMK
QEAgLTE0MSw3ICsxNDEsMTEgQEAgRVhQT1JUX1NZTUJPTF9HUEwodmdhX2RlZmF1bHRfZGV2aWNl
KTsKIAogdm9pZCB2Z2Ffc2V0X2RlZmF1bHRfZGV2aWNlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQog
ewotCXZnYV9kZWZhdWx0ID0gcGRldjsKKwlpZiAodmdhX2RlZmF1bHQgPT0gcGRldikKKwkJcmV0
dXJuOworCisJcGNpX2Rldl9wdXQodmdhX2RlZmF1bHQpOworCXZnYV9kZWZhdWx0ID0gcGNpX2Rl
dl9nZXQocGRldik7CiB9CiAjZW5kaWYKIApAQCAtNTc3LDcgKzU4MSw3IEBAIHN0YXRpYyBib29s
IHZnYV9hcmJpdGVyX2FkZF9wY2lfZGV2aWNlKHMKICNpZm5kZWYgX19BUkNIX0hBU19WR0FfREVG
QVVMVF9ERVZJQ0UKIAlpZiAodmdhX2RlZmF1bHQgPT0gTlVMTCAmJgogCSAgICAoKHZnYWRldi0+
b3ducyAmIFZHQV9SU1JDX0xFR0FDWV9NQVNLKSA9PSBWR0FfUlNSQ19MRUdBQ1lfTUFTSykpCi0J
CXZnYV9kZWZhdWx0ID0gcGNpX2Rldl9nZXQocGRldik7CisJCXZnYV9zZXRfZGVmYXVsdF9kZXZp
Y2UocGRldik7CiAjZW5kaWYKIAogCXZnYV9hcmJpdGVyX2NoZWNrX2JyaWRnZV9zaGFyaW5nKHZn
YWRldik7CkBAIC02MTMsMTAgKzYxNyw4IEBAIHN0YXRpYyBib29sIHZnYV9hcmJpdGVyX2RlbF9w
Y2lfZGV2aWNlKHMKIAl9CiAKICNpZm5kZWYgX19BUkNIX0hBU19WR0FfREVGQVVMVF9ERVZJQ0UK
LQlpZiAodmdhX2RlZmF1bHQgPT0gcGRldikgewotCQlwY2lfZGV2X3B1dCh2Z2FfZGVmYXVsdCk7
Ci0JCXZnYV9kZWZhdWx0ID0gTlVMTDsKLQl9CisJaWYgKHZnYV9kZWZhdWx0ID09IHBkZXYpCisJ
CXZnYV9zZXRfZGVmYXVsdF9kZXZpY2UoTlVMTCk7CiAjZW5kaWYKIAogCWlmICh2Z2FkZXYtPmRl
Y29kZXMgJiAoVkdBX1JTUkNfTEVHQUNZX0lPIHwgVkdBX1JTUkNfTEVHQUNZX01FTSkpCg==
--0015175884fc55a90404ca3cc6cd--
