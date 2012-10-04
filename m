Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab2JDVVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:21:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63697 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933856Ab2JDVVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:21:46 -0400
MIME-Version: 1.0
In-Reply-To: <20121004164551.GA2244@phenom.dumpdata.com>
References: <1348991844-12285-1-git-send-email-yinghai@kernel.org>
	<1348991844-12285-5-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210011139320.29232@kaball.uk.xensource.com>
	<CAE9FiQUMMRPb2u13R2b7hHSOTgb4jKcnbAace7T22_GCm=-HxQ@mail.gmail.com>
	<20121004164551.GA2244@phenom.dumpdata.com>
Date: Thu, 4 Oct 2012 14:21:44 -0700
X-Google-Sender-Auth: I7s2JRrZXdGXT9jZ5eSJz1YiZsg
Message-ID: <CAE9FiQWjXhat85JpXhCLApGe62mdCwb2HKhWGLjQdj2ed=6buA@mail.gmail.com>
Subject: Re: [PATCH 04/13] x86, mm: Revert back good_end setting for 64bit
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=00151758f42c9110a204cb42572f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00151758f42c9110a204cb42572f
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Oct 4, 2012 at 9:45 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> So could use ram under 1M to map that page table at first.
>
> Could or does this patch do it? And why 1MB?

can you or stefano could test attached patch on xen ?

that will map the page table buffer that will be used.

under 1M, still 4k there, so there will be no page table around 512M.

>>
>> so that will make it xen happy ?
>
> The issues that Xen faces are purely due to the fact that they
> must be RO when they are in use. I believe (and without actually
> checking it just to make sure) that it does not matter where
> the page-tables are located. But with the current generic code
> the location is quite linear: it starts with pgt_buf_start and
> goes up to pgt_buf_top. So how would this patch move the location
> of the page-table to be under 1MB?

just page table buf's page table.

Thanks

Yinghai

--00151758f42c9110a204cb42572f
Content-Type: application/octet-stream; 
	name="fix_xen_with_init_mapping.patch"
Content-Disposition: attachment; filename="fix_xen_with_init_mapping.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h7wdc1bv0

LS0tCiBhcmNoL3g4Ni9tbS9pbml0LmMgfCAgIDQ3ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKQoK
SW5kZXg6IGxpbnV4LTIuNi9hcmNoL3g4Ni9tbS9pbml0LmMKPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgt
Mi42Lm9yaWcvYXJjaC94ODYvbW0vaW5pdC5jCisrKyBsaW51eC0yLjYvYXJjaC94ODYvbW0vaW5p
dC5jCkBAIC0zNTksNiArMzU5LDM5IEBAIHVuc2lnbmVkIGxvbmcgX19pbml0X3JlZm9rIGluaXRf
bWVtb3J5X20KIAlyZXR1cm4gcmV0ID4+IFBBR0VfU0hJRlQ7CiB9CiAKK3N0YXRpYyBsb25nIF9f
aW5pdCBlYXJseV9pbml0X21lbW9yeV9tYXBwaW5nKHVuc2lnbmVkIGxvbmcgc3RhcnQsCisJCQkJ
CSAgICAgICB1bnNpZ25lZCBsb25nIGVuZCkKK3sKKwl1bnNpZ25lZCBsb25nIHJldDsKKwl1bnNp
Z25lZCBsb25nIHRhYmxlcywgZ29vZF9lbmQ7CisKKwlwcl9pbmZvKCJpbml0X21lbW9yeV9tYXBw
aW5nOiBbbWVtICUjMDEwbHgtJSMwMTBseF1cbiIsCisJICAgICAgIHN0YXJ0LCBlbmQgLSAxKTsK
KworCXRhYmxlcyA9IGNhbGN1bGF0ZV90YWJsZV9zcGFjZV9zaXplKHN0YXJ0LCBlbmQpOworCWdv
b2RfZW5kID0gSVNBX0VORF9BRERSRVNTOworCisJZmluZF9lYXJseV90YWJsZV9zcGFjZSgwLCBn
b29kX2VuZCwgdGFibGVzKTsKKworCXByaW50ayhLRVJOX0RFQlVHICJrZXJuZWwgZGlyZWN0IG1h
cHBpbmcgdGFibGVzIGZyb20gJSNseCB0byAlI2x4IEAgW21lbSAlIzAxMGx4LSUjMDEwbHhdIHBy
ZWFsbG9jXG4iLAorCQlzdGFydCwgZW5kIC0gMSwgcGd0X2J1Zl9zdGFydCA8PCBQQUdFX1NISUZU
LAorCQkocGd0X2J1Zl90b3AgPDwgUEFHRV9TSElGVCkgLSAxKTsKKworCXJldCA9IGluaXRfbWVt
b3J5X21hcHBpbmcoc3RhcnQsIGVuZCk7CisKKwlpZiAocGd0X2J1Zl9lbmQgPiBwZ3RfYnVmX3N0
YXJ0KSB7CisJCXByaW50ayhLRVJOX0RFQlVHICJrZXJuZWwgZGlyZWN0IG1hcHBpbmcgdGFibGVz
IGZyb20gJSNseCB0byAlI2x4IEAgW21lbSAlIzAxMGx4LSUjMDEwbHhdIGZpbmFsXG4iLAorCQkJ
c3RhcnQsIGVuZCAtIDEsIHBndF9idWZfc3RhcnQgPDwgUEFHRV9TSElGVCwKKwkJCShwZ3RfYnVm
X2VuZCA8PCBQQUdFX1NISUZUKSAtIDEpOworCQl4ODZfaW5pdC5tYXBwaW5nLnBhZ2V0YWJsZV9y
ZXNlcnZlKFBGTl9QSFlTKHBndF9idWZfc3RhcnQpLAorCQkJCVBGTl9QSFlTKHBndF9idWZfZW5k
KSk7CisJfQorCisJZWFybHlfbWVtdGVzdChzdGFydCwgZW5kKTsKKworCXJldHVybiByZXQ7Cit9
CisKIC8qCiAgKiBJdGVyYXRlIHRocm91Z2ggRTgyMCBtZW1vcnkgbWFwIGFuZCBjcmVhdGUgZGly
ZWN0IG1hcHBpbmdzIGZvciBvbmx5IEU4MjBfUkFNCiAgKiByZWdpb25zLiBXZSBjYW5ub3Qgc2lt
cGx5IGNyZWF0ZSBkaXJlY3QgbWFwcGluZ3MgZm9yIGFsbCBwZm5zIGZyb20KQEAgLTM5NSw2ICs0
MjgsMjAgQEAgdm9pZCBfX2luaXQgaW5pdF9tZW1fbWFwcGluZyh2b2lkKQogI2VuZGlmCiAJd2Fs
a19yYW1fcmFuZ2VzKHNpemVfd29ya19mbiwgJnRhYmxlcyk7CiAJZmluZF9lYXJseV90YWJsZV9z
cGFjZSgwLCBnb29kX2VuZCwgdGFibGVzKTsKKworCWlmIChwZ3RfYnVmX3RvcCA+PSBtYXhfcGZu
X21hcHBlZCkgeworCQl1bnNpZ25lZCBsb25nIG9sZF9wZ3RfYnVmX3N0YXJ0ID0gcGd0X2J1Zl9z
dGFydDsKKwkJdW5zaWduZWQgbG9uZyBvbGRfcGd0X2J1Zl9lbmQgPSBwZ3RfYnVmX2VuZDsKKwkJ
dW5zaWduZWQgbG9uZyBvbGRfcGd0X2J1Zl90b3AgPSBwZ3RfYnVmX3RvcDsKKworCQllYXJseV9p
bml0X21lbW9yeV9tYXBwaW5nKG9sZF9wZ3RfYnVmX3N0YXJ0IDw8IFBBR0VfU0hJRlQsCisJCQkJ
CSAgb2xkX3BndF9idWZfdG9wIDw8IFBBR0VfU0hJRlQpOworCisJCXBndF9idWZfc3RhcnQgPSBv
bGRfcGd0X2J1Zl9zdGFydDsKKwkJcGd0X2J1Zl9lbmQgPSBvbGRfcGd0X2J1Zl9lbmQ7CisJCXBn
dF9idWZfdG9wID0gb2xkX3BndF9idWZfdG9wOworCX0KKwogCXByaW50ayhLRVJOX0RFQlVHICJr
ZXJuZWwgZGlyZWN0IG1hcHBpbmcgdGFibGVzIHVwIHRvICUjbHggQCBbbWVtICUjMDEwbHgtJSMw
MTBseF0gcHJlYWxsb2NcbiIsCiAJCWVuZCAtIDEsIHBndF9idWZfc3RhcnQgPDwgUEFHRV9TSElG
VCwKIAkJKHBndF9idWZfdG9wIDw8IFBBR0VfU0hJRlQpIC0gMSk7Cg==
--00151758f42c9110a204cb42572f--
