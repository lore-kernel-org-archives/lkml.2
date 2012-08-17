Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab2HQBy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:54:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42203 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2HQBy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:54:58 -0400
MIME-Version: 1.0
In-Reply-To: <1345167949-7419-3-git-send-email-ming.lei@canonical.com>
References: <1345167949-7419-1-git-send-email-ming.lei@canonical.com>
	<1345167949-7419-3-git-send-email-ming.lei@canonical.com>
Date: Fri, 17 Aug 2012 09:54:56 +0800
Message-ID: <CACVXFVNGHtXqiZtA0V6FuCEvebSs1F=jQG=nAYqwQjD6jdG2+Q@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] PM / Sleep: introduce dpm_for_each_dev
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Content-Type: multipart/mixed; boundary=047d7b6dc2d266fa9804c76c724c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7b6dc2d266fa9804c76c724c
Content-Type: text/plain; charset=ISO-8859-1

On Fri, Aug 17, 2012 at 9:45 AM, Ming Lei <ming.lei@canonical.com> wrote:
> diff --git a/include/linux/pm.h b/include/linux/pm.h
> index 44d1f23..bf86f89 100644
> --- a/include/linux/pm.h
> +++ b/include/linux/pm.h
> @@ -640,6 +640,7 @@ extern void __suspend_report_result(const char *function, void *fn, int ret);
>         } while (0)
>
>  extern int device_pm_wait_for_dev(struct device *sub, struct device *dev);
> +extern void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *));
>
>  extern int pm_generic_prepare(struct device *dev);
>  extern int pm_generic_suspend_late(struct device *dev);
> @@ -679,6 +680,10 @@ static inline int device_pm_wait_for_dev(struct device *a, struct device *b)
>         return 0;
>  }
>
> +void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *))

Sorry, the above line is wrong, and should be defined as 'static inline'.
Please drop this one and take the attachment patch.


Thanks,
--
Ming Lei

--047d7b6dc2d266fa9804c76c724c
Content-Type: application/octet-stream; 
	name="0002-PM-Sleep-introduce-dpm_for_each_dev.patch"
Content-Disposition: attachment; 
	filename="0002-PM-Sleep-introduce-dpm_for_each_dev.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h5ymkryz0

RnJvbSAwNjhiNWZmNGViNGE3NTQxOTNiYjQxNWQ4NDViMzUyMTg5NDg3OTNjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNaW5nIExlaSA8dG9tLmxlaW1pbmdAZ21haWwuY29tPgpEYXRl
OiBGcmksIDE3IEF1ZyAyMDEyIDA5OjAzOjU2ICswODAwClN1YmplY3Q6IFtSRkMgUEFUQ0ggMi8z
XSBQTSAvIFNsZWVwOiBpbnRyb2R1Y2UgZHBtX2Zvcl9lYWNoX2RldgoKZHBtX2xpc3QgYW5kIGl0
cyBwbSBsb2NrIHByb3ZpZGUgYSBnb29kIHdheSB0byBpdGVyYXRlIGFsbApkZXZpY2VzIGluIHN5
c3RlbS4gRXhjZXB0IHRoaXMgd2F5LCB0aGVyZSBpcyBubyBvdGhlciBlYXN5CndheSB0byBpdGVy
YXRlIGRldmljZXMgaW4gc3lzdGVtLgoKZmlybXdhcmUgbG9hZGVyIG5lZWQgdG8gY2FjaGUgZmly
bXdhcmUgaW1hZ2VzIGZvciBkZXZpY2VzCmJlZm9yZSBzeXN0ZW0gc2xlZXAsIHNvIGludHJvZHVj
ZSB0aGUgZnVuY3Rpb24gdG8gbWVldCBpdHMKZGVtYW5kLgoKUmVwb3J0ZWQtYnk6IEZlbmdndWFu
ZyBXdSA8ZmVuZ2d1YW5nLnd1QGludGVsLmNvbT4KU2lnbmVkLW9mZi1ieTogTWluZyBMZWkgPHRv
bS5sZWltaW5nQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL2Jhc2UvcG93ZXIvbWFpbi5jIHwgICAx
OSArKysrKysrKysrKysrKysrKysrCiBpbmNsdWRlL2xpbnV4L3BtLmggICAgICAgIHwgICAgNSAr
KysrKwogMiBmaWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9iYXNlL3Bvd2VyL21haW4uYyBiL2RyaXZlcnMvYmFzZS9wb3dlci9tYWluLmMKaW5kZXgg
NTdmNTgxNC4uMTg0YmNiNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9iYXNlL3Bvd2VyL21haW4uYwor
KysgYi9kcml2ZXJzL2Jhc2UvcG93ZXIvbWFpbi5jCkBAIC0xMzQ5LDMgKzEzNDksMjIgQEAgaW50
IGRldmljZV9wbV93YWl0X2Zvcl9kZXYoc3RydWN0IGRldmljZSAqc3Vib3JkaW5hdGUsIHN0cnVj
dCBkZXZpY2UgKmRldikKIAlyZXR1cm4gYXN5bmNfZXJyb3I7CiB9CiBFWFBPUlRfU1lNQk9MX0dQ
TChkZXZpY2VfcG1fd2FpdF9mb3JfZGV2KTsKKworLyoqCisgKiBkcG1fZm9yX2VhY2hfZGV2IC0g
ZGV2aWNlIGl0ZXJhdG9yLgorICogQGRhdGE6IGRhdGEgZm9yIHRoZSBjYWxsYmFjay4KKyAqIEBm
bjogZnVuY3Rpb24gdG8gYmUgY2FsbGVkIGZvciBlYWNoIGRldmljZS4KKyAqCisgKiBJdGVyYXRl
IG92ZXIgZGV2aWNlcyBpbiBkcG1fbGlzdCwgYW5kIGNhbGwgQGZuIGZvciBlYWNoIGRldmljZSwK
KyAqIHBhc3NpbmcgaXQgQGRhdGEuCisgKi8KK3ZvaWQgZHBtX2Zvcl9lYWNoX2Rldih2b2lkICpk
YXRhLCB2b2lkICgqZm4pKHN0cnVjdCBkZXZpY2UgKiwgdm9pZCAqKSkKK3sKKwlzdHJ1Y3QgZGV2
aWNlICpkZXY7CisKKwlkZXZpY2VfcG1fbG9jaygpOworCWxpc3RfZm9yX2VhY2hfZW50cnkoZGV2
LCAmZHBtX2xpc3QsIHBvd2VyLmVudHJ5KQorCQlmbihkZXYsIGRhdGEpOworCWRldmljZV9wbV91
bmxvY2soKTsKK30KK0VYUE9SVF9TWU1CT0xfR1BMKGRwbV9mb3JfZWFjaF9kZXYpOwpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC9wbS5oIGIvaW5jbHVkZS9saW51eC9wbS5oCmluZGV4IDQ0ZDFm
MjMuLjAwN2U2ODcgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvcG0uaAorKysgYi9pbmNsdWRl
L2xpbnV4L3BtLmgKQEAgLTY0MCw2ICs2NDAsNyBAQCBleHRlcm4gdm9pZCBfX3N1c3BlbmRfcmVw
b3J0X3Jlc3VsdChjb25zdCBjaGFyICpmdW5jdGlvbiwgdm9pZCAqZm4sIGludCByZXQpOwogCX0g
d2hpbGUgKDApCiAKIGV4dGVybiBpbnQgZGV2aWNlX3BtX3dhaXRfZm9yX2RldihzdHJ1Y3QgZGV2
aWNlICpzdWIsIHN0cnVjdCBkZXZpY2UgKmRldik7CitleHRlcm4gdm9pZCBkcG1fZm9yX2VhY2hf
ZGV2KHZvaWQgKmRhdGEsIHZvaWQgKCpmbikoc3RydWN0IGRldmljZSAqLCB2b2lkICopKTsKIAog
ZXh0ZXJuIGludCBwbV9nZW5lcmljX3ByZXBhcmUoc3RydWN0IGRldmljZSAqZGV2KTsKIGV4dGVy
biBpbnQgcG1fZ2VuZXJpY19zdXNwZW5kX2xhdGUoc3RydWN0IGRldmljZSAqZGV2KTsKQEAgLTY3
OSw2ICs2ODAsMTAgQEAgc3RhdGljIGlubGluZSBpbnQgZGV2aWNlX3BtX3dhaXRfZm9yX2Rldihz
dHJ1Y3QgZGV2aWNlICphLCBzdHJ1Y3QgZGV2aWNlICpiKQogCXJldHVybiAwOwogfQogCitzdGF0
aWMgaW5saW5lIHZvaWQgZHBtX2Zvcl9lYWNoX2Rldih2b2lkICpkYXRhLCB2b2lkICgqZm4pKHN0
cnVjdCBkZXZpY2UgKiwgdm9pZCAqKSkKK3sKK30KKwogI2RlZmluZSBwbV9nZW5lcmljX3ByZXBh
cmUJTlVMTAogI2RlZmluZSBwbV9nZW5lcmljX3N1c3BlbmQJTlVMTAogI2RlZmluZSBwbV9nZW5l
cmljX3Jlc3VtZQlOVUxMCi0tIAoxLjcuOS41Cgo=
--047d7b6dc2d266fa9804c76c724c--
