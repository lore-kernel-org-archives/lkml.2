Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2E3GsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:48:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34523 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab2E3GsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:48:00 -0400
Message-ID: <4FC5C291.3060801@kernel.org>
Date: Tue, 29 May 2012 23:47:45 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH] x86, realmode: ia64 build fix (drivers/acpi/sleep.c)
References: <1338359162-5785-1-git-send-email-jarkko.sakkinen@intel.com>
In-Reply-To: <1338359162-5785-1-git-send-email-jarkko.sakkinen@intel.com>
Content-Type: multipart/mixed;
 boundary="------------090301000109010505070109"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090301000109010505070109
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 05/29/2012 11:26 PM, Jarkko Sakkinen wrote:
> From: Jarkko Sakkinen <Jarkko Sakkinen jarkko.sakkinen@intel.com>
> 
> Added CONFIG_ACPI_SLEEP caging for #include <asm/realmode.h>.
> 
> Signed-off-by: Jarkko Sakkinen <Jarkko Sakkinen jarkko.sakkinen@intel.com>
> ---
>  drivers/acpi/sleep.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index a82fbf6..5b99f64 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -25,7 +25,9 @@
>  #include <acpi/acpi_bus.h>
>  #include <acpi/acpi_drivers.h>
>  
> +#ifdef CONFIG_ACPI_SLEEP
>  #include <asm/realmode.h>
> +#endif
>  
>  #include "internal.h"
>  #include "sleep.h"

We rarely want to do things this way, because it masks build problems.
The right way to do this is the way it was before
c9b77ccb52a5c77233b0e557b7d4417b00ef4012, where the dependency on the
trampoline code was located in an architecture-specific asm header.

ia64 actually still has acpi_wakeup_address defined, although it seems
to always be zero.

So I would say the right thing is more along the lines of the attached
(and totally untested) patch.

Also, your SOB line is messed up.




--------------090301000109010505070109
Content-Type: text/plain; charset=UTF-8;
 name="diff"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="diff"

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FjcGkuaCBiL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2FjcGkuaAppbmRleCA3MjRhYTQ0Li4wYzQ0NjMwIDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL2FzbS9hY3BpLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20v
YWNwaS5oCkBAIC0yOSw2ICsyOSw3IEBACiAjaW5jbHVkZSA8YXNtL3Byb2Nlc3Nvci5oPgog
I2luY2x1ZGUgPGFzbS9tbXUuaD4KICNpbmNsdWRlIDxhc20vbXBzcGVjLmg+CisjaW5jbHVk
ZSA8YXNtL3JlYWxtb2RlLmg+CiAKICNkZWZpbmUgQ09NUElMRVJfREVQRU5ERU5UX0lOVDY0
ICAgbG9uZyBsb25nCiAjZGVmaW5lIENPTVBJTEVSX0RFUEVOREVOVF9VSU5UNjQgIHVuc2ln
bmVkIGxvbmcgbG9uZwpAQCAtMTE2LDEwICsxMTcsOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQg
YWNwaV9kaXNhYmxlX3BjaSh2b2lkKQogLyogTG93LWxldmVsIHN1c3BlbmQgcm91dGluZS4g
Ki8KIGV4dGVybiBpbnQgYWNwaV9zdXNwZW5kX2xvd2xldmVsKHZvaWQpOwogCi1leHRlcm4g
Y29uc3QgdW5zaWduZWQgY2hhciBhY3BpX3dha2V1cF9jb2RlW107Ci0KLS8qIGVhcmx5IGlu
aXRpYWxpemF0aW9uIHJvdXRpbmUgKi8KLWV4dGVybiB2b2lkIGFjcGlfcmVzZXJ2ZV93YWtl
dXBfbWVtb3J5KHZvaWQpOworLyogUGh5c2ljYWwgYWRkcmVzcyB0byByZXN1bWUgYWZ0ZXIg
d2FrZXVwICovCisjZGVmaW5lIGFjcGlfd2FrZXVwX2FkZHJlc3MgKCh1bnNpZ25lZCBsb25n
KShyZWFsX21vZGVfaGVhZGVyLT53YWtldXBfc3RhcnQpKQogCiAvKgogICogQ2hlY2sgaWYg
dGhlIENQVSBjYW4gaGFuZGxlIEMyIGFuZCBkZWVwZXIKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
YWNwaS9zbGVlcC5jIGIvZHJpdmVycy9hY3BpL3NsZWVwLmMKaW5kZXggZWJhYTA0NS4uNzRl
ZTRhYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9hY3BpL3NsZWVwLmMKKysrIGIvZHJpdmVycy9h
Y3BpL3NsZWVwLmMKQEAgLTI1LDggKzI1LDYgQEAKICNpbmNsdWRlIDxhY3BpL2FjcGlfYnVz
Lmg+CiAjaW5jbHVkZSA8YWNwaS9hY3BpX2RyaXZlcnMuaD4KIAotI2luY2x1ZGUgPGFzbS9y
ZWFsbW9kZS5oPgotCiAjaW5jbHVkZSAiaW50ZXJuYWwuaCIKICNpbmNsdWRlICJzbGVlcC5o
IgogCkBAIC05MywxMyArOTEsMTEgQEAgc3RhdGljIHN0cnVjdCBub3RpZmllcl9ibG9jayB0
dHNfbm90aWZpZXIgPSB7CiBzdGF0aWMgaW50IGFjcGlfc2xlZXBfcHJlcGFyZSh1MzIgYWNw
aV9zdGF0ZSkKIHsKICNpZmRlZiBDT05GSUdfQUNQSV9TTEVFUAotCXVuc2lnbmVkIGxvbmcg
d2FrZXVwX3BhID0gcmVhbF9tb2RlX2hlYWRlci0+d2FrZXVwX3N0YXJ0OwogCS8qIGRvIHdl
IGhhdmUgYSB3YWtldXAgYWRkcmVzcyBmb3IgUzIgYW5kIFMzPyAqLwogCWlmIChhY3BpX3N0
YXRlID09IEFDUElfU1RBVEVfUzMpIHsKLQkJaWYgKCF3YWtldXBfcGEpCisJCWlmICghYWNw
aV93YWtldXBfYWRkcmVzcykKIAkJCXJldHVybiAtRUZBVUxUOwotCQlhY3BpX3NldF9maXJt
d2FyZV93YWtpbmdfdmVjdG9yKAotCQkJCShhY3BpX3BoeXNpY2FsX2FkZHJlc3Mpd2FrZXVw
X3BhKTsKKwkJYWNwaV9zZXRfZmlybXdhcmVfd2FraW5nX3ZlY3RvcihhY3BpX3dha2V1cF9h
ZGRyZXNzKTsKIAogCX0KIAlBQ1BJX0ZMVVNIX0NQVV9DQUNIRSgpOwo=
--------------090301000109010505070109--
