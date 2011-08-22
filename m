Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1HVVEF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:04:05 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64541 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab1HVVED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo71XHyuji1HxZwShtg-YQCavgkgcdH23ic38q3COB3MgQ@mail.gmail.com>
References: <CAG1a4rs4Cr1z50gGuK9SLE6aOvibE1sdV_GSLPv+gqYC8g+ORQ@mail.gmail.com>
	<CAErSpo4FfBoGDUquoLNsJ9=z-M-x6NQgP8xJL_VqEXpsL2H5PA@mail.gmail.com>
	<4E520149.3010802@intel.com>
	<CAErSpo71XHyuji1HxZwShtg-YQCavgkgcdH23ic38q3COB3MgQ@mail.gmail.com>
Date: Mon, 22 Aug 2011 14:04:02 -0700
Message-ID: <CAE9FiQVNGpA9rE0Q7Lx2AB_+8dPEg=f98vqPx1PARkABLVYXqw@mail.gmail.com>
Subject: Re: APEI: Can not request iomem region for GARs
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Huang Ying <ying.huang@intel.com>, Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf305638e337465604ab1e6bfd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf305638e337465604ab1e6bfd
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 22, 2011 at 9:45 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Aug 22, 2011 at 1:12 AM, Huang Ying <ying.huang@intel.com> wrote:
>> Do you have time to try the patch attached with the mail?
>> acpi_nvs.patch should go first.
>
> In this case, we have an ACPI NVS region, and the APEI code is
> essentially a driver for some registers that reside there. =A0APEI is
> the entity that manages those registers, and it needs to enforce
> mutual exclusion so nobody else touches them behind its back, so I
> think it makes sense for it to request the register regions and mark
> them busy.
>
> My proposal is to change e820 so it either leaves ACPI NVS out of the
> iomem_resource tree or puts it in but leaves it non-busy.

assume Huang Ying only tested with UEFI native boot?

i have one local patch for legacy mode booting, and it's similar to
what Bjorn suggested.

Please check the attached patch.

Thanks

Yinghai Lu

--20cf305638e337465604ab1e6bfd
Content-Type: text/x-patch; charset=US-ASCII; name="apei_size_check_1.patch"
Content-Disposition: attachment; filename="apei_size_check_1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_grnxmsbx0

U3ViamVjdDogW1BBVENIXSB4ODY6IGFsbG93IE5WUyBjYW4gYmUgYWNjZXNzZWQgYnkgZHJpdmVy
CgpBUEVJIHJlbGF0ZWQuLi4KClNpZ25lZC1vZmYtYnk6IFlpbmdoYWkgTHUgPHlpbmdoYWlAa2Vy
bmVsLm9yZz4KCi0tLQogYXJjaC94ODYva2VybmVsL2U4MjAuYyB8ICAgIDMgKystCiAxIGZpbGUg
Y2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpJbmRleDogbGludXgtMi42
L2FyY2gveDg2L2tlcm5lbC9lODIwLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42Lm9yaWcvYXJj
aC94ODYva2VybmVsL2U4MjAuYworKysgbGludXgtMi42L2FyY2gveDg2L2tlcm5lbC9lODIwLmMK
QEAgLTk5NSw3ICs5OTUsOCBAQCB2b2lkIF9faW5pdCBlODIwX3Jlc2VydmVfcmVzb3VyY2VzKHZv
aWQpCiAJCSAqIHBjaWJpb3NfcmVzb3VyY2Vfc3VydmV5KCkKIAkJICovCiAJCWlmIChlODIwLm1h
cFtpXS50eXBlICE9IEU4MjBfUkVTRVJWRUQgfHwgcmVzLT5zdGFydCA8ICgxVUxMPDwyMCkpIHsK
LQkJCXJlcy0+ZmxhZ3MgfD0gSU9SRVNPVVJDRV9CVVNZOworCQkJaWYgKGU4MjAubWFwW2ldLnR5
cGUgIT0gRTgyMF9OVlMpCisJCQkJcmVzLT5mbGFncyB8PSBJT1JFU09VUkNFX0JVU1k7CiAJCQlp
bnNlcnRfcmVzb3VyY2UoJmlvbWVtX3Jlc291cmNlLCByZXMpOwogCQl9CiAJCXJlcysrOwo=
--20cf305638e337465604ab1e6bfd--
