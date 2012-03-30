Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab2C3S1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:27:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64371 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2C3S1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
References: <1332135996-13860-1-git-send-email-yinghai@kernel.org>
Date: Fri, 30 Mar 2012 11:27:37 -0700
X-Google-Sender-Auth: 4Dx4Phusx7xlEDInGjgQ94JaDX4
Message-ID: <CAE9FiQWydpUdy9NVZH23DQYovSFBkEX1gZPf9SwzN9nXyDQhMA@mail.gmail.com>
Subject: Re: [PATCH 00/47] PCI, x86: pci root bus hotplug support
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: multipart/mixed; boundary=047d7b2eded3c32f7004bc79fe4f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b2eded3c32f7004bc79fe4f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 18, 2012 at 10:45 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> will add pci_stop_and_remove_bus() to support remove bus in
> /sys/devices/pci.../pci_bus/...
>
> To rescan root, need to
> echo 1 > /sys/bus/pci/rescan_root
>
> It supports acpi path root bus and legacy root bus.
>
> This patcheset include some IOMM and dmar and pnpacpi fix with device ref=
count leaking.
> =A0 =A0 =A0 =A0also include some bus remove/rescan cleanup.
>
> The patches need to apply to pci/for-linus and pci/linux-next
> =A0 =A0 =A0 =A0[PATCH -v3] PCI: pci_host_bridge related cleanup
> =A0 =A0 =A0 =A0[PATCH -v11] PCI: allocate pci bus num range for unassigne=
d bridge busn
>
> could get from
> =A0 =A0 =A0 =A0git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linu=
x-yinghai.git for-pci-root-bus-hotplug
>
> -v2: Address most of Bjorn's review, except still keeping .../pci_bus/...=
/remove
> =A0 =A0 Separate pci root hot add support from acpiphp to pci_root_hp
> =A0 =A0 add hot removal to pci_root_hp
> -v3: Reordering the patches about /sys changes at last that Bjorn objects=
.
> =A0 =A0 Claim hw/fw allocated bus after root bus hot add.
> =A0 =A0 add two patches for Jiang Liu about removal.

Add attached patch to the tree for making ioapic and iommu hotplug working.

Thanks

Yinghai

--047d7b2eded3c32f7004bc79fe4f
Content-Type: application/octet-stream; 
	name="stop_pci_drivers_before_ioapic_dmar.patch"
Content-Disposition: attachment; 
	filename="stop_pci_drivers_before_ioapic_dmar.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h0fkchcl0

U3ViamVjdDogW1BBVENIXSBBQ1BJLCBQQ0k6IFN0b3AgcGNpIGRldmljZXMgYmVmb3JlIGFjcGlf
cGNpX2RyaXZlciByZW1vdmUgY2FsbGluZwoKRHVyaW5nIHN0b3AgcGNpIGRyaXZlcnMsIGl0IHN0
aWxsIG5lZWQgdG8gYWNjZXNzIGlvYXBpYyBhbmQgaW9tbXUuClNvIG5lZWQgdG8gbWFrZSBzdXJl
IHRob3NlIGRyaXZlcnMgbmVlZCB0byBiZSBzdG9wIGF0IGZpcnN0LgoKQWxzbyBjaGFuZ2UgdGhl
IGFjcGlfcGNpX2RyaXZlcnMgcmVtb3ZlIGNhbGxpbmcgc2VxdWVuY2UgdG8gcmV2ZXJzZS4KClNp
Z25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2VybmVsLm9yZz4KCi0tLQogZHJpdmVy
cy9hY3BpL3BjaV9yb290LmMgfCAgIDExICsrKysrKystLS0tCiBkcml2ZXJzL3BjaS9yZW1vdmUu
YyAgICB8ICAgIDIgKy0KIGluY2x1ZGUvbGludXgvcGNpLmggICAgIHwgICAgMSArCiAzIGZpbGVz
IGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCkluZGV4OiBsaW51eC0y
LjYvZHJpdmVycy9hY3BpL3BjaV9yb290LmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcv
ZHJpdmVycy9hY3BpL3BjaV9yb290LmMKKysrIGxpbnV4LTIuNi9kcml2ZXJzL2FjcGkvcGNpX3Jv
b3QuYwpAQCAtNjU3LDEwICs2NTcsNiBAQCBzdGF0aWMgaW50IGFjcGlfcGNpX3Jvb3RfcmVtb3Zl
KHN0cnVjdCBhCiAKIAltdXRleF9sb2NrKCZhY3BpX3BjaV9yb290X2xvY2spOwogCi0JbGlzdF9m
b3JfZWFjaF9lbnRyeShkcml2ZXIsICZhY3BpX3BjaV9kcml2ZXJzLCBub2RlKQotCQlpZiAoZHJp
dmVyLT5yZW1vdmUpCi0JCQlkcml2ZXItPnJlbW92ZShyb290LT5kZXZpY2UtPmhhbmRsZSk7Ci0K
IAkvKiB0aGF0IHJvb3QgYnVzIGNvdWxkIGJlIHJlbW92ZWQgYWxyZWFkeSAqLwogCWlmICghcGNp
X2ZpbmRfYnVzKHJvb3QtPnNlZ21lbnQsIHJvb3QtPnNlY29uZGFyeS5zdGFydCkpIHsKIAkJZGV2
X3ByaW50ayhLRVJOX0RFQlVHLCAmZGV2aWNlLT5kZXYsCkBAIC02NjgsNiArNjY0LDEzIEBAIHN0
YXRpYyBpbnQgYWNwaV9wY2lfcm9vdF9yZW1vdmUoc3RydWN0IGEKIAkJZ290byBvdXQ7CiAJfQog
CisJLyogc3RvcCBub3JtYWwgcGNpIGRyaXZlcnMgYmVmb3JlIHdlIHN0b3AgaW9hcGljIGFuZCBk
bWFyIGV0YyAqLworCXBjaV9zdG9wX2J1c19kZXZpY2VzKHJvb3QtPmJ1cyk7CisKKwlsaXN0X2Zv
cl9lYWNoX2VudHJ5X3JldmVyc2UoZHJpdmVyLCAmYWNwaV9wY2lfZHJpdmVycywgbm9kZSkKKwkJ
aWYgKGRyaXZlci0+cmVtb3ZlKQorCQkJZHJpdmVyLT5yZW1vdmUocm9vdC0+ZGV2aWNlLT5oYW5k
bGUpOworCiAJZGV2aWNlX3NldF9ydW5fd2FrZShyb290LT5idXMtPmJyaWRnZSwgZmFsc2UpOwog
CXBjaV9hY3BpX3JlbW92ZV9idXNfcG1fbm90aWZpZXIoZGV2aWNlKTsKIApJbmRleDogbGludXgt
Mi42L2RyaXZlcnMvcGNpL3JlbW92ZS5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxpbnV4LTIuNi5vcmlnL2Ry
aXZlcnMvcGNpL3JlbW92ZS5jCisrKyBsaW51eC0yLjYvZHJpdmVycy9wY2kvcmVtb3ZlLmMKQEAg
LTExNyw3ICsxMTcsNyBAQCBzdGF0aWMgdm9pZCBfX3BjaV9yZW1vdmVfYnVzX2RldmljZXMoc3Ry
CiAJCV9fcGNpX3JlbW92ZV9idXNfZGV2aWNlKGRldik7CiB9CiAKLXN0YXRpYyB2b2lkIHBjaV9z
dG9wX2J1c19kZXZpY2VzKHN0cnVjdCBwY2lfYnVzICpidXMpCit2b2lkIHBjaV9zdG9wX2J1c19k
ZXZpY2VzKHN0cnVjdCBwY2lfYnVzICpidXMpCiB7CiAJc3RydWN0IHBjaV9kZXYgKmRldiwgKnRt
cDsKIApJbmRleDogbGludXgtMi42L2luY2x1ZGUvbGludXgvcGNpLmgKPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0g
bGludXgtMi42Lm9yaWcvaW5jbHVkZS9saW51eC9wY2kuaAorKysgbGludXgtMi42L2luY2x1ZGUv
bGludXgvcGNpLmgKQEAgLTc4Miw2ICs3ODIsNyBAQCBleHRlcm4gdm9pZCBwY2lfZGV2X3B1dChz
dHJ1Y3QgcGNpX2RldiAqCiBleHRlcm4gdm9pZCBwY2lfcmVtb3ZlX2J1cyhzdHJ1Y3QgcGNpX2J1
cyAqYik7CiBleHRlcm4gdm9pZCBfX3BjaV9yZW1vdmVfYnVzX2RldmljZShzdHJ1Y3QgcGNpX2Rl
diAqZGV2KTsKIGV4dGVybiB2b2lkIHBjaV9zdG9wX2FuZF9yZW1vdmVfYnVzX2RldmljZShzdHJ1
Y3QgcGNpX2RldiAqZGV2KTsKK3ZvaWQgcGNpX3N0b3BfYnVzX2RldmljZXMoc3RydWN0IHBjaV9i
dXMgKmJ1cyk7CiB2b2lkIHBjaV9zdG9wX2FuZF9yZW1vdmVfYnVzKHN0cnVjdCBwY2lfYnVzICpi
dXMpOwogZXh0ZXJuIHZvaWQgcGNpX3N0b3BfYnVzX2RldmljZShzdHJ1Y3QgcGNpX2RldiAqZGV2
KTsKIHZvaWQgcGNpX3NldHVwX2NhcmRidXMoc3RydWN0IHBjaV9idXMgKmJ1cyk7Cg==
--047d7b2eded3c32f7004bc79fe4f--
