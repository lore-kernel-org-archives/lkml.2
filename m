Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab1LNAlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:41:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58953 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab1LNAla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:41:30 -0500
MIME-Version: 1.0
In-Reply-To: <4EE637F3.7070606@xenotime.net>
References: <20111209163247.1de15dcb5b735ca5e1ad030b@canb.auug.org.au>
 <d4bdd33396b823c5241c4939b981e8a6.squirrel@xenotime.net> <4EE637F3.7070606@xenotime.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 13 Dec 2011 17:41:08 -0700
Message-ID: <CAErSpo5dbAJiJ4FhR4bso+4MnJ9mk45T2Z+spmdzRr95w8jAZg@mail.gmail.com>
Subject: Re: linux-next: Tree for Dec 9 (ibmphp)
To: Randy Dunlap <rdunlap@xenotime.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e6d784ffda375a04b402a040
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d784ffda375a04b402a040
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 12, 2011 at 10:20 AM, Randy Dunlap <rdunlap@xenotime.net> wrote=
:
> On 12/09/2011 10:51 AM, Randy Dunlap wrote:
>>
>> On Thu, December 8, 2011 9:32 pm, Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Changes since 20111208:
>>
>> (This build error =A0was first seen in 20111208.)
>>
>>
>> ERROR: "pci_scan_bus" [drivers/pci/hotplug/ibmphp.ko] undefined!
>>
>> Full randconfig file is attached.
>
>
> Same for 20111212.

I changed pci_scan_bus() from an inline function (visible to modules)
to a normal function (by default, not visible to modules), which broke
the ibmphp.ko build.

The updated patch is attached, as well as the incremental change (just
adding "EXPORT_SYMBOL(pci_scan_bus);".

(Also available at git://github.com/bjorn-helgaas/linux.git on the "pci-sca=
n-v6"
branch as bef4a9eefaa69dd9bc998e29d619127d1653683d)

Bjorn

--0016e6d784ffda375a04b402a040
Content-Type: application/octet-stream; name="patch.convert-pci_scan_bus"
Content-Disposition: attachment; filename="patch.convert-pci_scan_bus"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gw5m5wr01

Y29tbWl0IDNhZTRhYjgxM2I2MGQ5YzQyZmJkZmM3OTQ3M2M1NWM1M2NiODU0NDcKQXV0aG9yOiBC
am9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpEYXRlOiAgIFRodSBPY3QgMjcgMTE6
NDU6MzggMjAxMSAtMDYwMAoKICAgIFBDSTogY29udmVydCBwY2lfc2Nhbl9idXMoKSB0byB1c2Ug
cGNpX2NyZWF0ZV9yb290X2J1cygpCiAgICAKICAgIEkgcGxhbiB0byBkZXByZWNhdGUgcGNpX3Nj
YW5fYnVzX3BhcmVudGVkKCksIHNvIHVzZSBwY2lfY3JlYXRlX3Jvb3RfYnVzKCkKICAgIGRpcmVj
dGx5IGluc3RlYWQuICBwY2lfc2Nhbl9idXMoKSBpdHNlbGYgd2lsbCBiZSByZW1vdmVkIGFzIHNv
b24gYXMgYWxsCiAgICBjYWxsZXJzIGFyZSBnb25lLCBzbyB0aGlzIGlzIGp1c3QgYW4gaW50ZXJp
bSBzdGVwLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBCam9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bn
b29nbGUuY29tPgoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3Byb2JlLmMgYi9kcml2ZXJzL3Bj
aS9wcm9iZS5jCmluZGV4IDlmNGIwMGMuLmYwNjZjOWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNp
L3Byb2JlLmMKKysrIGIvZHJpdmVycy9wY2kvcHJvYmUuYwpAQCAtMTY0OSw2ICsxNjQ5LDI1IEBA
IHN0cnVjdCBwY2lfYnVzICogX19kZXZpbml0IHBjaV9zY2FuX2J1c19wYXJlbnRlZChzdHJ1Y3Qg
ZGV2aWNlICpwYXJlbnQsCiB9CiBFWFBPUlRfU1lNQk9MKHBjaV9zY2FuX2J1c19wYXJlbnRlZCk7
CiAKK3N0cnVjdCBwY2lfYnVzICogX19kZXZpbml0IHBjaV9zY2FuX2J1cyhpbnQgYnVzLCBzdHJ1
Y3QgcGNpX29wcyAqb3BzLAorCQkJCQl2b2lkICpzeXNkYXRhKQoreworCUxJU1RfSEVBRChyZXNv
dXJjZXMpOworCXN0cnVjdCBwY2lfYnVzICpiOworCisJcGNpX2FkZF9yZXNvdXJjZSgmcmVzb3Vy
Y2VzLCAmaW9wb3J0X3Jlc291cmNlKTsKKwlwY2lfYWRkX3Jlc291cmNlKCZyZXNvdXJjZXMsICZp
b21lbV9yZXNvdXJjZSk7CisJYiA9IHBjaV9jcmVhdGVfcm9vdF9idXMoTlVMTCwgYnVzLCBvcHMs
IHN5c2RhdGEsICZyZXNvdXJjZXMpOworCWlmIChiKSB7CisJCWItPnN1Ym9yZGluYXRlID0gcGNp
X3NjYW5fY2hpbGRfYnVzKGIpOworCQlwY2lfYnVzX2FkZF9kZXZpY2VzKGIpOworCX0gZWxzZSB7
CisJCXBjaV9mcmVlX3Jlc291cmNlX2xpc3QoJnJlc291cmNlcyk7CisJfQorCXJldHVybiBiOwor
fQorRVhQT1JUX1NZTUJPTChwY2lfc2Nhbl9idXMpOworCiAjaWZkZWYgQ09ORklHX0hPVFBMVUcK
IC8qKgogICogcGNpX3Jlc2Nhbl9idXMgLSBzY2FuIGEgUENJIGJ1cyBmb3IgZGV2aWNlcy4KZGlm
ZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvcGNpLmggYi9pbmNsdWRlL2xpbnV4L3BjaS5oCmluZGV4
IDMyMzdjYzguLmEwODI1OTMgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcGNpLmgKKysrIGIv
aW5jbHVkZS9saW51eC9wY2kuaApAQCAtNjYwLDE1ICs2NjAsNyBAQCBleHRlcm4gc3RydWN0IHBj
aV9idXMgKnBjaV9maW5kX2J1cyhpbnQgZG9tYWluLCBpbnQgYnVzbnIpOwogdm9pZCBwY2lfYnVz
X2FkZF9kZXZpY2VzKGNvbnN0IHN0cnVjdCBwY2lfYnVzICpidXMpOwogc3RydWN0IHBjaV9idXMg
KnBjaV9zY2FuX2J1c19wYXJlbnRlZChzdHJ1Y3QgZGV2aWNlICpwYXJlbnQsIGludCBidXMsCiAJ
CQkJICAgICAgc3RydWN0IHBjaV9vcHMgKm9wcywgdm9pZCAqc3lzZGF0YSk7Ci1zdGF0aWMgaW5s
aW5lIHN0cnVjdCBwY2lfYnVzICogX19kZXZpbml0IHBjaV9zY2FuX2J1cyhpbnQgYnVzLCBzdHJ1
Y3QgcGNpX29wcyAqb3BzLAotCQkJCQkgICB2b2lkICpzeXNkYXRhKQotewotCXN0cnVjdCBwY2lf
YnVzICpyb290X2J1czsKLQlyb290X2J1cyA9IHBjaV9zY2FuX2J1c19wYXJlbnRlZChOVUxMLCBi
dXMsIG9wcywgc3lzZGF0YSk7Ci0JaWYgKHJvb3RfYnVzKQotCQlwY2lfYnVzX2FkZF9kZXZpY2Vz
KHJvb3RfYnVzKTsKLQlyZXR1cm4gcm9vdF9idXM7Ci19CitzdHJ1Y3QgcGNpX2J1cyAqcGNpX3Nj
YW5fYnVzKGludCBidXMsIHN0cnVjdCBwY2lfb3BzICpvcHMsIHZvaWQgKnN5c2RhdGEpOwogc3Ry
dWN0IHBjaV9idXMgKnBjaV9jcmVhdGVfcm9vdF9idXMoc3RydWN0IGRldmljZSAqcGFyZW50LCBp
bnQgYnVzLAogCQkJCSAgICBzdHJ1Y3QgcGNpX29wcyAqb3BzLCB2b2lkICpzeXNkYXRhLAogCQkJ
CSAgICBzdHJ1Y3QgbGlzdF9oZWFkICpyZXNvdXJjZXMpOwo=
--0016e6d784ffda375a04b402a040
Content-Type: application/octet-stream; name="patch.export"
Content-Disposition: attachment; filename="patch.export"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gw5m663f2

ZGlmZiAtLWdpdCBhLzAxYzEzODJkMzpkcml2ZXJzL3BjaS9wcm9iZS5jIGIvYmVmNGE5ZWVmOmRy
aXZlcnMvcGNpL3Byb2JlLmMKaW5kZXggODE4MmQ2OS4uZjAxYTAxYSAxMDA2NDQKLS0tIGEvMDFj
MTM4MmQzOmRyaXZlcnMvcGNpL3Byb2JlLmMKKysrIGIvYmVmNGE5ZWVmOmRyaXZlcnMvcGNpL3By
b2JlLmMKQEAgLTE2NTgsNiArMTY1OCw3IEBAIHN0cnVjdCBwY2lfYnVzICogX19kZXZpbml0IHBj
aV9zY2FuX2J1cyhpbnQgYnVzLCBzdHJ1Y3QgcGNpX29wcyAqb3BzLAogCX0KIAlyZXR1cm4gYjsK
IH0KK0VYUE9SVF9TWU1CT0wocGNpX3NjYW5fYnVzKTsKIAogI2lmZGVmIENPTkZJR19IT1RQTFVH
CiAvKioK
--0016e6d784ffda375a04b402a040--
