Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab0JBIqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 04:46:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62716 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0JBIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 04:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=v9lKZt3uLuPkj7S3t80B4LUqxNjUBbeC1/50WzJb5dSnWOijVV1UN3LimfjUNHVUCl
         XN5OzNifWKgHOOLPw5t1P67iE0NZROELiUuFM5XMFAki1I3oRo1ucb0yiH78w4fl8xqL
         l6Ha5z21X88IAI9M2AUzyQB9Eg2xDwsn7iUfE=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=8LGCVqchpQrB+31FRqK04+3xLFCuak0S1FHpK@mail.gmail.com>
References: <1286002121-3694-1-git-send-email-rahul.ruikar@gmail.com> <AANLkTi=8LGCVqchpQrB+31FRqK04+3xLFCuak0S1FHpK@mail.gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sat, 2 Oct 2010 14:16:14 +0530
Message-ID: <AANLkTimnSzAWJW417_XR60umT_k47AFWDdDPPD3yhbLG@mail.gmail.com>
Subject: Re: [PATCH] usb: core: endpoint: Fix error path
To: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Tejun Heo <tj@kernel.org>, asanchez@neurowork.net, rjw@sisk.pl
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e659fd1435c07804919e59d1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e659fd1435c07804919e59d1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

revised patch attached.

Thanks
- Rahul Ruikar





On 2 October 2010 13:15, Ming Lei <tom.leiming@gmail.com> wrote:
> 2010/10/2 Rahul Ruikar <rahul.ruikar@gmail.com>:
>> In function usb_create_ep_devs()
>> call put_device() when device_register() fails.
>>
>> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
>> ---
>> =A0drivers/usb/core/endpoint.c | =A0 =A04 +++-
>> =A01 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
>> index 3788e73..cab126d 100644
>> --- a/drivers/usb/core/endpoint.c
>> +++ b/drivers/usb/core/endpoint.c
>> @@ -195,8 +195,10 @@ int usb_create_ep_devs(struct device *parent,
>> =A0 =A0 =A0 =A0device_enable_async_suspend(&ep_dev->dev);
>>
>> =A0 =A0 =A0 =A0retval =3D device_register(&ep_dev->dev);
>> - =A0 =A0 =A0 if (retval)
>> + =A0 =A0 =A0 if (retval) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_device(&ep_dev->dev);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto error_register;
>> + =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0endpoint->ep_dev =3D ep_dev;
>> =A0 =A0 =A0 =A0return retval;
>> --
>
> You should replace kfree(ep_dev) with put_device(&ep_dev->dev),
> otherwise double free will be triggered.
>
> So you need to revise the patch...
>
> --
> Lei Ming
>

--0016e659fd1435c07804919e59d1
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-usb-core-endpoint-Fix-error-path.patch"
Content-Disposition: attachment; 
	filename="0001-usb-core-endpoint-Fix-error-path.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ges8k16l0

RnJvbSAwMTg5MDYwMzYxYzUwM2E3OGZmYjA1NWY5YzJhYjUwYWM1YTFhODhlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSYWh1bCBSdWlrYXIgPHJhaHVsLnJ1aWthckBnbWFpbC5jb20+
CkRhdGU6IFNhdCwgMiBPY3QgMjAxMCAxNDowOTozOSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIHVz
YjogY29yZTogZW5kcG9pbnQ6IEZpeCBlcnJvciBwYXRoCgpJbiBmdW5jdGlvbiB1c2JfY3JlYXRl
X2VwX2RldnMoKQpjYWxsIHB1dF9kZXZpY2UoKSB3aGVuIGRldmljZV9yZWdpc3RlcigpIGZhaWxz
LgoKU2lnbmVkLW9mZi1ieTogUmFodWwgUnVpa2FyIDxyYWh1bC5ydWlrYXJAZ21haWwuY29tPgot
LS0KIGRyaXZlcnMvdXNiL2NvcmUvZW5kcG9pbnQuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdl
ZCwgMSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
dXNiL2NvcmUvZW5kcG9pbnQuYyBiL2RyaXZlcnMvdXNiL2NvcmUvZW5kcG9pbnQuYwppbmRleCAz
Nzg4ZTczLi45ZGEyNTA1IDEwMDY0NAotLS0gYS9kcml2ZXJzL3VzYi9jb3JlL2VuZHBvaW50LmMK
KysrIGIvZHJpdmVycy91c2IvY29yZS9lbmRwb2ludC5jCkBAIC0yMDIsNyArMjAyLDcgQEAgaW50
IHVzYl9jcmVhdGVfZXBfZGV2cyhzdHJ1Y3QgZGV2aWNlICpwYXJlbnQsCiAJcmV0dXJuIHJldHZh
bDsKIAogZXJyb3JfcmVnaXN0ZXI6Ci0Ja2ZyZWUoZXBfZGV2KTsKKwlwdXRfZGV2aWNlKCZlcF9k
ZXYtPmRldik7CiBleGl0OgogCXJldHVybiByZXR2YWw7CiB9Ci0tIAoxLjcuMi4zCgo=
--0016e659fd1435c07804919e59d1--
