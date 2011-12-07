Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1LGP0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:26:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35667 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab1LGP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:26:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
References: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au> <CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 7 Dec 2011 08:25:39 -0700
Message-ID: <CAErSpo5fO87Aj8_PcdTT5V1JC6D8_o5WEpEMmHCeC=2PA9rkoQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (pci tree related)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Content-Type: multipart/mixed; boundary=0016e6d58f3b5cf8fe04b3822bc4
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d58f3b5cf8fe04b3822bc4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 7, 2011 at 8:08 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Tue, Dec 6, 2011 at 11:05 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (sparc64 defconfi=
g)
>> failed like this:
>>
>> arch/sparc/kernel/pci.c: In function 'pci_scan_one_pbm':
>> arch/sparc/kernel/pci.c:697:7: error: incompatible type for argument 5 o=
f 'pci_create_root_bus'
>> include/linux/pci.h:665:17: note: expected 'struct list_head *' but argu=
ment is of type 'struct list_head'
>>
>> Caused by commit fa3cec8aff53 ("sparc/PCI: convert to pci_create_root_bu=
s
>> ()"). Same typo as for the powerpc tree. :-( =A0Please double check the
>> rest of those changes, please.
>>
>> I applied the following patch for today.
>
> Thanks for doing that, sorry for the trouble. =A0I don't have a set of
> cross-compilers, unfortunately, but I will inspect the rest manually.
> Do we have to discover problems one-by-one, or can you tell us about
> any other arch build problems at the same time?

I checked the rest manually and didn't find any similar problems.

The corrected patch attached (same as with Stephen's fixup) is
attached.  Also available
at git://github.com/bjorn-helgaas/linux.git on the "pci-scan-v5"
branch as c0cab2621d0cf75e86fbbad44d0b2b84c3a42f97)

Bjorn

--0016e6d58f3b5cf8fe04b3822bc4
Content-Type: application/octet-stream; name="patch.pci-host-bridge-sparc"
Content-Disposition: attachment; filename="patch.pci-host-bridge-sparc"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gvwhoqzm0

Y29tbWl0IDE4MzEzZDA5MjRiNjFmZWJmYmMxN2ZmMTlmMDdmZWE0MjJhMzg1MzQKQXV0aG9yOiBC
am9ybiBIZWxnYWFzIDxiaGVsZ2Fhc0Bnb29nbGUuY29tPgpEYXRlOiAgIE1vbiBPY3QgMTAgMTg6
MTQ6NDkgMjAxMSAtMDYwMAoKICAgIHNwYXJjL1BDSTogY29udmVydCB0byBwY2lfY3JlYXRlX3Jv
b3RfYnVzKCkKICAgIAogICAgQ29udmVydCBmcm9tIHBjaV9jcmVhdGVfYnVzKCkgdG8gcGNpX2Ny
ZWF0ZV9yb290X2J1cygpLiAgVGhpcyB3YXkgdGhlIHJvb3QKICAgIGJ1cyByZXNvdXJjZXMgYXJl
IGNvcnJlY3QgaW1tZWRpYXRlbHkuICBUaGlzIHBhdGNoIGRvZXNuJ3QgZml4IGEgcHJvYmxlbQog
ICAgYmVjYXVzZSBzcGFyYyBmaXhlZCB0aGUgcmVzb3VyY2VzIGJlZm9yZSBzY2FubmluZyB0aGUg
YnVzLCBidXQgaXQgbWFrZXMKICAgIHNwYXJjIG1vcmUgY29uc2lzdGVudCB3aXRoIG90aGVyIGFy
Y2hpdGVjdHVyZXMuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEJqb3JuIEhlbGdhYXMgPGJoZWxn
YWFzQGdvb2dsZS5jb20+CiAgICBBY2tlZC1ieTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZl
bWxvZnQubmV0PgoKZGlmZiAtLWdpdCBhL2FyY2gvc3BhcmMva2VybmVsL3BjaS5jIGIvYXJjaC9z
cGFyYy9rZXJuZWwvcGNpLmMKaW5kZXggMzExMTFlMy4uNDlkZWRmMiAxMDA2NDQKLS0tIGEvYXJj
aC9zcGFyYy9rZXJuZWwvcGNpLmMKKysrIGIvYXJjaC9zcGFyYy9rZXJuZWwvcGNpLmMKQEAgLTY4
NSwyMyArNjg1LDI1IEBAIHN0YXRpYyB2b2lkIF9fZGV2aW5pdCBwY2lfYnVzX3JlZ2lzdGVyX29m
X3N5c2ZzKHN0cnVjdCBwY2lfYnVzICpidXMpCiBzdHJ1Y3QgcGNpX2J1cyAqIF9fZGV2aW5pdCBw
Y2lfc2Nhbl9vbmVfcGJtKHN0cnVjdCBwY2lfcGJtX2luZm8gKnBibSwKIAkJCQkJICAgIHN0cnVj
dCBkZXZpY2UgKnBhcmVudCkKIHsKKwlMSVNUX0hFQUQocmVzb3VyY2VzKTsKIAlzdHJ1Y3QgZGV2
aWNlX25vZGUgKm5vZGUgPSBwYm0tPm9wLT5kZXYub2Zfbm9kZTsKIAlzdHJ1Y3QgcGNpX2J1cyAq
YnVzOwogCiAJcHJpbnRrKCJQQ0k6IFNjYW5uaW5nIFBCTSAlc1xuIiwgbm9kZS0+ZnVsbF9uYW1l
KTsKIAotCWJ1cyA9IHBjaV9jcmVhdGVfYnVzKHBhcmVudCwgcGJtLT5wY2lfZmlyc3RfYnVzbm8s
IHBibS0+cGNpX29wcywgcGJtKTsKKwlwY2lfYWRkX3Jlc291cmNlKCZyZXNvdXJjZXMsICZwYm0t
PmlvX3NwYWNlKTsKKwlwY2lfYWRkX3Jlc291cmNlKCZyZXNvdXJjZXMsICZwYm0tPm1lbV9zcGFj
ZSk7CisJYnVzID0gcGNpX2NyZWF0ZV9yb290X2J1cyhwYXJlbnQsIHBibS0+cGNpX2ZpcnN0X2J1
c25vLCBwYm0tPnBjaV9vcHMsCisJCQkJICBwYm0sICZyZXNvdXJjZXMpOwogCWlmICghYnVzKSB7
CiAJCXByaW50ayhLRVJOX0VSUiAiRmFpbGVkIHRvIGNyZWF0ZSBidXMgZm9yICVzXG4iLAogCQkg
ICAgICAgbm9kZS0+ZnVsbF9uYW1lKTsKKwkJcGNpX2ZyZWVfcmVzb3VyY2VfbGlzdCgmcmVzb3Vy
Y2VzKTsKIAkJcmV0dXJuIE5VTEw7CiAJfQogCWJ1cy0+c2Vjb25kYXJ5ID0gcGJtLT5wY2lfZmly
c3RfYnVzbm87CiAJYnVzLT5zdWJvcmRpbmF0ZSA9IHBibS0+cGNpX2xhc3RfYnVzbm87CiAKLQli
dXMtPnJlc291cmNlWzBdID0gJnBibS0+aW9fc3BhY2U7Ci0JYnVzLT5yZXNvdXJjZVsxXSA9ICZw
Ym0tPm1lbV9zcGFjZTsKLQogCXBjaV9vZl9zY2FuX2J1cyhwYm0sIG5vZGUsIGJ1cyk7CiAJcGNp
X2J1c19hZGRfZGV2aWNlcyhidXMpOwogCXBjaV9idXNfcmVnaXN0ZXJfb2Zfc3lzZnMoYnVzKTsK
QEAgLTcxMSwxMyArNzEzLDYgQEAgc3RydWN0IHBjaV9idXMgKiBfX2RldmluaXQgcGNpX3NjYW5f
b25lX3BibShzdHJ1Y3QgcGNpX3BibV9pbmZvICpwYm0sCiAKIHZvaWQgX19kZXZpbml0IHBjaWJp
b3NfZml4dXBfYnVzKHN0cnVjdCBwY2lfYnVzICpwYnVzKQogewotCXN0cnVjdCBwY2lfcGJtX2lu
Zm8gKnBibSA9IHBidXMtPnN5c2RhdGE7Ci0KLQkvKiBHZW5lcmljIFBDSSBidXMgcHJvYmluZyBz
ZXRzIHRoZXNlIHRvIHBvaW50IGF0Ci0JICogJmlve3BvcnQsbWVtfV9yZXNvdWNlIHdoaWNoIGlz
IHdyb25nIGZvciB1cy4KLQkgKi8KLQlwYnVzLT5yZXNvdXJjZVswXSA9ICZwYm0tPmlvX3NwYWNl
OwotCXBidXMtPnJlc291cmNlWzFdID0gJnBibS0+bWVtX3NwYWNlOwogfQogCiB2b2lkIHBjaWJp
b3NfdXBkYXRlX2lycShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgaW50IGlycSkK
--0016e6d58f3b5cf8fe04b3822bc4--
