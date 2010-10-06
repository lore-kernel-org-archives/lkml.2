Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342Ab0JFCet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:34:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47122 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0JFCes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=dvIRFmnsBS1g3e06Jk9rDt1vGBM6YEZt4GkCw+sW9pf3xepvrdU/qxHIKPTUBn5fFo
         Ia/kaYA0RZpzbOOypP9Wcgmvq8Lwmx1gRDtU3rnNgemzMqA/z+980auTjqsDoqvu4Rd6
         YmU6Hlg5RG9vpd2zQ1Max/1TpLsV8CJphY85U=
MIME-Version: 1.0
In-Reply-To: <4CAB79C4.3030208@ru.mvista.com>
References: <1286302800-2715-1-git-send-email-rahul.ruikar@gmail.com> <4CAB79C4.3030208@ru.mvista.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Wed, 6 Oct 2010 08:04:23 +0530
Message-ID: <AANLkTinBBUQuEnWzASb5daiE+C3w+Rs8kLdgzK7XAyne@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: langwell_udc: Fix error path
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=001636416599e6353d0491e99e22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636416599e6353d0491e99e22
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

updated patch with following changes.
- variable name changed
- comment updated.

Please find it attached here.

- Rahul Ruikar





On 6 October 2010 00:47, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> Rahul Ruikar wrote:
>
>> Fix for following cases
>> - Call device_unregister() only when device_register() is success.
>
> =A0 s/is success/succeeds/
>
>> - Call put_device() when device_register() fails.
>> - Call device_remove_file() only when device_create_file() is success.
>
> =A0 s/is success/succeeds/
>
>> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
>
> [...]
>
>> diff --git a/drivers/usb/gadget/langwell_udc.h
>> b/drivers/usb/gadget/langwell_udc.h
>> index 9719934..b212a70 100644
>> --- a/drivers/usb/gadget/langwell_udc.h
>> +++ b/drivers/usb/gadget/langwell_udc.h
>> @@ -199,7 +199,9 @@ struct langwell_udc {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vbus_acti=
ve:1,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0suspended=
:1,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0stopped:1=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lpm:1; =A0=
/* LPM capability */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lpm:1, =A0=
/* LPM capability */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reg_status=
:1,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 file_creat=
e:1;
>
> =A0 I'd rather have called this 'file_created'.
>
>> =A0 =A0 =A0 =A0/* pci state used to access those endpoints */
>> =A0 =A0 =A0 =A0struct pci_dev =A0 =A0 =A0 =A0 =A0*pdev;
>
> WBR, Sergei
>

--001636416599e6353d0491e99e22
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-usb-gadget-langwell_udc-Fix-error-path.patch"
Content-Disposition: attachment; 
	filename="0001-usb-gadget-langwell_udc-Fix-error-path.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gexl0izt0

RnJvbSBkNmE1NGJkNmIwNTBmZmJlOGFkNWRhMDc0NGEzMjlkOGMyYWVmMTkwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSYWh1bCBSdWlrYXIgPHJhaHVsLnJ1aWthckBnbWFpbC5jb20+
CkRhdGU6IFR1ZSwgNSBPY3QgMjAxMCAyMzozNDowNSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIHVz
YjogZ2FkZ2V0OiBsYW5nd2VsbF91ZGM6IEZpeCBlcnJvciBwYXRoCgpGaXggZm9yIGZvbGxvd2lu
ZyBjYXNlcwotIENhbGwgZGV2aWNlX3VucmVnaXN0ZXIoKSBvbmx5IHdoZW4gZGV2aWNlX3JlZ2lz
dGVyKCkgc3VjY2VlZHMuCi0gQ2FsbCBwdXRfZGV2aWNlKCkgd2hlbiBkZXZpY2VfcmVnaXN0ZXIo
KSBmYWlscy4KLSBDYWxsIGRldmljZV9yZW1vdmVfZmlsZSgpIG9ubHkgd2hlbiBkZXZpY2VfY3Jl
YXRlX2ZpbGUoKSBzdWNjZWVkcy4KClNpZ25lZC1vZmYtYnk6IFJhaHVsIFJ1aWthciA8cmFodWwu
cnVpa2FyQGdtYWlsLmNvbT4KLS0tCiBkcml2ZXJzL3VzYi9nYWRnZXQvbGFuZ3dlbGxfdWRjLmMg
fCAgIDE0ICsrKysrKysrKysrLS0tCiBkcml2ZXJzL3VzYi9nYWRnZXQvbGFuZ3dlbGxfdWRjLmgg
fCAgICA0ICsrKy0KIDIgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9nYWRnZXQvbGFuZ3dlbGxfdWRjLmMgYi9k
cml2ZXJzL3VzYi9nYWRnZXQvbGFuZ3dlbGxfdWRjLmMKaW5kZXggYzJkMmEyMC4uNTZlMjE2ZSAx
MDA2NDQKLS0tIGEvZHJpdmVycy91c2IvZ2FkZ2V0L2xhbmd3ZWxsX3VkYy5jCisrKyBiL2RyaXZl
cnMvdXNiL2dhZGdldC9sYW5nd2VsbF91ZGMuYwpAQCAtMjk1Miw4ICsyOTUyLDExIEBAIHN0YXRp
YyB2b2lkIGxhbmd3ZWxsX3VkY19yZW1vdmUoc3RydWN0IHBjaV9kZXYgKnBkZXYpCiAJSU5GTyhk
ZXYsICJ1bmJpbmRcbiIpOwogCURCRyhkZXYsICI8LS0tICVzKClcbiIsIF9fZnVuY19fKTsKIAot
CWRldmljZV91bnJlZ2lzdGVyKCZkZXYtPmdhZGdldC5kZXYpOwotCWRldmljZV9yZW1vdmVfZmls
ZSgmcGRldi0+ZGV2LCAmZGV2X2F0dHJfbGFuZ3dlbGxfdWRjKTsKKwlpZiAoZGV2LT5yZWdfc3Rh
dHVzKQorCQlkZXZpY2VfdW5yZWdpc3RlcigmZGV2LT5nYWRnZXQuZGV2KTsKKworCWlmIChkZXYt
PmZpbGVfY3JlYXRlZCkKKwkJZGV2aWNlX3JlbW92ZV9maWxlKCZwZGV2LT5kZXYsICZkZXZfYXR0
cl9sYW5nd2VsbF91ZGMpOwogCiAjaWZuZGVmCU9UR19UUkFOU0NFSVZFUgogCXBjaV9zZXRfZHJ2
ZGF0YShwZGV2LCBOVUxMKTsKQEAgLTMxOTAsMTMgKzMxOTMsMTggQEAgc3RhdGljIGludCBsYW5n
d2VsbF91ZGNfcHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsCiAJdGhlX2NvbnRyb2xsZXIgPSBk
ZXY7CiAKIAlyZXR2YWwgPSBkZXZpY2VfcmVnaXN0ZXIoJmRldi0+Z2FkZ2V0LmRldik7Ci0JaWYg
KHJldHZhbCkKKwlpZiAocmV0dmFsKSB7CisJCXB1dF9kZXZpY2UoJmRldi0+Z2FkZ2V0LmRldik7
CiAJCWdvdG8gZXJyb3I7CisJfQorCWRldi0+cmVnX3N0YXR1cyA9IDE7CiAKIAlyZXR2YWwgPSBk
ZXZpY2VfY3JlYXRlX2ZpbGUoJnBkZXYtPmRldiwgJmRldl9hdHRyX2xhbmd3ZWxsX3VkYyk7CiAJ
aWYgKHJldHZhbCkKIAkJZ290byBlcnJvcjsKIAorCWRldi0+ZmlsZV9jcmVhdGVkID0gMTsKKwog
CVZEQkcoZGV2LCAiPC0tLSAlcygpXG4iLCBfX2Z1bmNfXyk7CiAJcmV0dXJuIDA7CiAKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdXNiL2dhZGdldC9sYW5nd2VsbF91ZGMuaCBiL2RyaXZlcnMvdXNiL2dh
ZGdldC9sYW5nd2VsbF91ZGMuaAppbmRleCA5NzE5OTM0Li5kYTQwNjcxIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3VzYi9nYWRnZXQvbGFuZ3dlbGxfdWRjLmgKKysrIGIvZHJpdmVycy91c2IvZ2FkZ2V0
L2xhbmd3ZWxsX3VkYy5oCkBAIC0xOTksNyArMTk5LDkgQEAgc3RydWN0IGxhbmd3ZWxsX3VkYyB7
CiAJCQkJdmJ1c19hY3RpdmU6MSwKIAkJCQlzdXNwZW5kZWQ6MSwKIAkJCQlzdG9wcGVkOjEsCi0J
CQkJbHBtOjE7CS8qIExQTSBjYXBhYmlsaXR5ICovCisJCQkJbHBtOjEsCS8qIExQTSBjYXBhYmls
aXR5ICovCisJCQkJcmVnX3N0YXR1czoxLAorCQkJCWZpbGVfY3JlYXRlZDoxOwogCiAJLyogcGNp
IHN0YXRlIHVzZWQgdG8gYWNjZXNzIHRob3NlIGVuZHBvaW50cyAqLwogCXN0cnVjdCBwY2lfZGV2
CQkqcGRldjsKLS0gCjEuNy4yLjMKCg==
--001636416599e6353d0491e99e22--
