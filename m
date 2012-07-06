Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2GFRJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:09:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62979 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2GFRJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM=9txA0OAm=8ROHXBpXZ+-onqJx41yK4_-v1go8e8W6ROVzw@mail.gmail.com>
References: <20120706144622.GA13387@localhost>
	<20120706144846.GA13505@localhost>
	<CAPM=9txA0OAm=8ROHXBpXZ+-onqJx41yK4_-v1go8e8W6ROVzw@mail.gmail.com>
Date: Fri, 6 Jul 2012 18:09:20 +0100
Message-ID: <CAPM=9tzUkUOkA8-RNA4rztUXuKREKYGJVR3=0oYM7ufR9kRacA@mail.gmail.com>
Subject: Re: general protection fault on ttm_init()
From: Dave Airlie <airlied@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=90e6ba6145f22f447604c42c53b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba6145f22f447604c42c53b0
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Jul 6, 2012 at 5:49 PM, Dave Airlie <airlied@gmail.com> wrote:
> On Fri, Jul 6, 2012 at 3:48 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> ... The missed kconfig.
>>
>> On Fri, Jul 06, 2012 at 10:46:22PM +0800, Fengguang Wu wrote:
>>> Hi Thomas,
>
> Wierd, I'm sorta tempted to just depend drm on CONFIG_PROC_FS, but it
> looks like the error path is failing to dtrt.

I've attached a patch that should fix it, let me know if it works.

though since the drm fails on proc not being there I wonder should we
just enforce proc being there if you pick drm.

Dave.

--90e6ba6145f22f447604c42c53b0
Content-Type: application/octet-stream; 
	name="0001-drm-fail-gracefully-when-proc-isn-t-setup.patch"
Content-Disposition: attachment; 
	filename="0001-drm-fail-gracefully-when-proc-isn-t-setup.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4biqidt0

RnJvbSAxNWVmNTBlOWJiYTFmYjUyZjhmNGI0YjQ4ZDI5YzY3NTBiNzJmYWQ5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIEFpcmxpZSA8YWlybGllZEBnbWFpbC5jb20+CkRhdGU6
IEZyaSwgNiBKdWwgMjAxMiAxODowNjo0MiArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIGRybTogZmFp
bCBncmFjZWZ1bGx5IHdoZW4gcHJvYyBpc24ndCBzZXR1cC4KCklmIGRybSBjYW4ndCBmaW5kIHBy
b2MgaXQgc2hvdWxkIGZhaWwgbW9yZSBncmFjZWZ1bGx5LCB0aGFuIGp1c3QKb29wc2luZy4KClJl
cG9ydGVkLWJ5OiBGZW5nZ3VhbmcgV3UgPGZlbmdndWFuZy53dUBpbnRlbC5jb20+ClNpZ25lZC1v
ZmYtYnk6IERhdmUgQWlybGllIDxhaXJsaWVkQHJlZGhhdC5jb20+Ci0tLQogZHJpdmVycy9ncHUv
ZHJtL2RybV9zeXNmcy5jIHwgICAgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KykKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vZHJtX3N5c2ZzLmMgYi9kcml2ZXJzL2dw
dS9kcm0vZHJtX3N5c2ZzLmMKaW5kZXggNDVjZjFkZC4uZGU4YzYzNiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9ncHUvZHJtL2RybV9zeXNmcy5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9kcm1fc3lzZnMu
YwpAQCAtNTU0LDYgKzU1NCw5IEBAIHZvaWQgZHJtX3N5c2ZzX2RldmljZV9yZW1vdmUoc3RydWN0
IGRybV9taW5vciAqbWlub3IpCiAKIGludCBkcm1fY2xhc3NfZGV2aWNlX3JlZ2lzdGVyKHN0cnVj
dCBkZXZpY2UgKmRldikKIHsKKwlpZiAoIWRybV9jbGFzcyB8fCBJU19FUlIoZHJtX2NsYXNzKSkK
KwkJcmV0dXJuIC1FTk9FTlQ7CisKIAlkZXYtPmNsYXNzID0gZHJtX2NsYXNzOwogCXJldHVybiBk
ZXZpY2VfcmVnaXN0ZXIoZGV2KTsKIH0KLS0gCjEuNy4xMC40Cgo=
--90e6ba6145f22f447604c42c53b0--
