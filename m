Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0JBPOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 11:14:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37400 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab0JBPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 11:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=ktiyWL7E/STuAvONrlk5j8iOTLQX3bQbXV6mM8oU1FrFkEkKfgmrWQwUYUABT7Q+Ju
         veI08i1io0lpNu4PLBGVSqIryGD7TPU634/+/HmRJZndWNq7hMkGkRJvhcLOmSNmmxvr
         x/yAWqKXTHqBzuCW6DgnYf1roBbEuLjCVkkAw=
MIME-Version: 1.0
In-Reply-To: <1286032307-3350-1-git-send-email-rahul.ruikar@gmail.com>
References: <1286032307-3350-1-git-send-email-rahul.ruikar@gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sat, 2 Oct 2010 20:43:44 +0530
Message-ID: <AANLkTin57LWwuxjXB3ORt4+hzHeDBatWP2K+H7JDsTkm@mail.gmail.com>
Subject: Re: [RESEND/PATCH] usb: gadget: dummy_hcd: Fix error path
To: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>
Content-Type: multipart/mixed; boundary=0016364164e907bd930491a3c3e9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364164e907bd930491a3c3e9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

updated patch attached here.

- Rahul Ruikar





On 2 October 2010 20:41, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> In function dummy_udc_probe()
> call put_device() when device_register() fails.
> also usb_get_hcd() put before device_register() after review comment
> from Alan Stern.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
> =A0drivers/usb/gadget/dummy_hcd.c | =A0 =A08 +++++---
> =A01 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hc=
d.c
> index dc65462..9b30483 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -874,6 +874,8 @@ static int dummy_udc_probe (struct platform_device *p=
dev)
> =A0 =A0 =A0 =A0struct dummy =A0 =A0*dum =3D the_controller;
> =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 rc;
>
> + =A0 =A0 =A0 usb_get_hcd(dummy_to_hcd(dum));
> +
> =A0 =A0 =A0 =A0dum->gadget.name =3D gadget_name;
> =A0 =A0 =A0 =A0dum->gadget.ops =3D &dummy_ops;
> =A0 =A0 =A0 =A0dum->gadget.is_dualspeed =3D 1;
> @@ -885,10 +887,10 @@ static int dummy_udc_probe (struct platform_device =
*pdev)
> =A0 =A0 =A0 =A0dum->gadget.dev.parent =3D &pdev->dev;
> =A0 =A0 =A0 =A0dum->gadget.dev.release =3D dummy_gadget_release;
> =A0 =A0 =A0 =A0rc =3D device_register (&dum->gadget.dev);
> - =A0 =A0 =A0 if (rc < 0)
> + =A0 =A0 =A0 if (rc < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_device(&dum->gadget.dev);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> -
> - =A0 =A0 =A0 usb_get_hcd (dummy_to_hcd (dum));
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0platform_set_drvdata (pdev, dum);
> =A0 =A0 =A0 =A0rc =3D device_create_file (&dum->gadget.dev, &dev_attr_fun=
ction);
> --
> 1.7.2.3
>
>

--0016364164e907bd930491a3c3e9
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-usb-gadget-dummy_hcd-Fix-error-path.patch"
Content-Disposition: attachment; 
	filename="0001-usb-gadget-dummy_hcd-Fix-error-path.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gesmh8kd0

RnJvbSA1MDg4M2Q0ZGY3ZjM2YmY5Yjg3Yzg4MzZlYmQ3ZGUxNWZjN2FjOTAwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSYWh1bCBSdWlrYXIgPHJhaHVsLnJ1aWthckBnbWFpbC5jb20+
CkRhdGU6IFNhdCwgMiBPY3QgMjAxMCAyMDozNDozNCArMDUzMApTdWJqZWN0OiBbUkVTRU5EL1BB
VENIXSB1c2I6IGdhZGdldDogZHVtbXlfaGNkOiBGaXggZXJyb3IgcGF0aAoKSW4gZnVuY3Rpb24g
ZHVtbXlfdWRjX3Byb2JlKCkKY2FsbCBwdXRfZGV2aWNlKCkgd2hlbiBkZXZpY2VfcmVnaXN0ZXIo
KSBmYWlscy4KYWxzbyB1c2JfZ2V0X2hjZCgpIHB1dCBiZWZvcmUgZGV2aWNlX3JlZ2lzdGVyKCkg
YWZ0ZXIgcmV2aWV3IGNvbW1lbnQKZnJvbSBBbGFuIFN0ZXJuLgoKU2lnbmVkLW9mZi1ieTogUmFo
dWwgUnVpa2FyIDxyYWh1bC5ydWlrYXJAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvdXNiL2dhZGdl
dC9kdW1teV9oY2QuYyB8ICAgIDggKysrKystLS0KIDEgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2dhZGdldC9k
dW1teV9oY2QuYyBiL2RyaXZlcnMvdXNiL2dhZGdldC9kdW1teV9oY2QuYwppbmRleCBkYzY1NDYy
Li45YjMwNDgzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3VzYi9nYWRnZXQvZHVtbXlfaGNkLmMKKysr
IGIvZHJpdmVycy91c2IvZ2FkZ2V0L2R1bW15X2hjZC5jCkBAIC04NzQsNiArODc0LDggQEAgc3Rh
dGljIGludCBkdW1teV91ZGNfcHJvYmUgKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAJ
c3RydWN0IGR1bW15CSpkdW0gPSB0aGVfY29udHJvbGxlcjsKIAlpbnQJCXJjOwogCisJdXNiX2dl
dF9oY2QoZHVtbXlfdG9faGNkKGR1bSkpOworCiAJZHVtLT5nYWRnZXQubmFtZSA9IGdhZGdldF9u
YW1lOwogCWR1bS0+Z2FkZ2V0Lm9wcyA9ICZkdW1teV9vcHM7CiAJZHVtLT5nYWRnZXQuaXNfZHVh
bHNwZWVkID0gMTsKQEAgLTg4NSwxMCArODg3LDEwIEBAIHN0YXRpYyBpbnQgZHVtbXlfdWRjX3By
b2JlIChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCWR1bS0+Z2FkZ2V0LmRldi5wYXJl
bnQgPSAmcGRldi0+ZGV2OwogCWR1bS0+Z2FkZ2V0LmRldi5yZWxlYXNlID0gZHVtbXlfZ2FkZ2V0
X3JlbGVhc2U7CiAJcmMgPSBkZXZpY2VfcmVnaXN0ZXIgKCZkdW0tPmdhZGdldC5kZXYpOwotCWlm
IChyYyA8IDApCisJaWYgKHJjIDwgMCkgeworCQlwdXRfZGV2aWNlKCZkdW0tPmdhZGdldC5kZXYp
OwogCQlyZXR1cm4gcmM7Ci0KLQl1c2JfZ2V0X2hjZCAoZHVtbXlfdG9faGNkIChkdW0pKTsKKwl9
CiAKIAlwbGF0Zm9ybV9zZXRfZHJ2ZGF0YSAocGRldiwgZHVtKTsKIAlyYyA9IGRldmljZV9jcmVh
dGVfZmlsZSAoJmR1bS0+Z2FkZ2V0LmRldiwgJmRldl9hdHRyX2Z1bmN0aW9uKTsKLS0gCjEuNy4y
LjMKCg==
--0016364164e907bd930491a3c3e9--
