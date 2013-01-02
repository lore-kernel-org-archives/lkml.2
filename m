Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3ABXh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 18:37:26 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:38600 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3ABXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 18:37:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130102223807.GA242@x4>
References: <20121223113153.GA8918@liondog.tnic>
	<20121223115133.GA229@x4>
	<20121223122210.GA4460@liondog.tnic>
	<20121223133102.GA8153@liondog.tnic>
	<CAKocOOPO7ZhybEgKfCkpna+KbpGgajMp6HuHbO9m9uT3gUtP0g@mail.gmail.com>
	<50E3907C.4040106@iki.fi>
	<20130102120248.GC6181@x1.alien8.de>
	<CAH3drwYSrfsbKg-BYpMF3Nkxrw1toK=EmcvJfKGzdbT_BK-1HQ@mail.gmail.com>
	<50E4755E.7030209@iki.fi>
	<CAH3drwZsNL6kwufTPGR8h-U9gfrsoYj_+C+8Ei1Ab-PPXrSuTQ@mail.gmail.com>
	<20130102223807.GA242@x4>
Date: Wed, 2 Jan 2013 18:37:23 -0500
Message-ID: <CADnq5_OuhJordwCQArknpdvzYLryouZ+u+a+tm37n3K+hmB9uw@mail.gmail.com>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
From: Alex Deucher <alexdeucher@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jerome Glisse <j.glisse@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Borislav Petkov <bp@alien8.de>, Shuah Khan <shuahkhan@gmail.com>,
        Andy Furniss <andyqos@ukfsn.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=bcaec54fb410684ac804d256ba84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec54fb410684ac804d256ba84
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Jan 2, 2013 at 5:38 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2013.01.02 at 17:31 -0500, Jerome Glisse wrote:
>> Please affected people can you test if patch :
>> http://people.freedesktop.org/~glisse/0003-drm-radeon-fix-dma-copy-on-r6xx-r7xx-evergen-ni-si-g.patch
>>
>> Fix the issue, you need to make sure you don't have the patch that
>> disable dma on r6xx ie that line 977-978 & 1061-1062  in radeon_asic.c
>> is :
>>  .copy = &r600_copy_dma,
>>  .copy_ring_index = R600_RING_TYPE_DMA_INDEX,
>
> It fixes the issue for me. Thanks.

The count is actually the count, not count - 1.  The real fix seems to
be that r6xx requires 2 dw aligned transfers.  The attached patch
fixes the issue for me.

Alex

>
> --
> Markus

--bcaec54fb410684ac804d256ba84
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-r6xx-fix-DMA-engine-for-ttm-bo-transfers.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-r6xx-fix-DMA-engine-for-ttm-bo-transfers.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hbh3v1f50

RnJvbSA0Nzk5NmZlMmNjNGVlODJhYzlkYjUxNGZjYTM2ZGY4ODkxNzJjZjMwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5j
b20+CkRhdGU6IFdlZCwgMiBKYW4gMjAxMyAxODozMDoyMSAtMDUwMApTdWJqZWN0OiBbUEFUQ0hd
IGRybS9yYWRlb24vcjZ4eDogZml4IERNQSBlbmdpbmUgZm9yIHR0bSBibyB0cmFuc2ZlcnMKCmNv
dW50IG11c3QgYmUgYSBtdWx0aXBsZSBvZiAyLgoKQ2M6IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxp
ZW44LmRlPgpDYzogTWFya3VzIFRyaXBwZWxzZG9yZiA8bWFya3VzQHRyaXBwZWxzZG9yZi5kZT4K
U2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQuY29tPgot
LS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMC5jIHwgICAgNCArKy0tCiAxIGZpbGVzIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3I2MDAuYyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMC5j
CmluZGV4IDJhYWYxNDcuLjlmNGNlNWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRl
b24vcjYwMC5jCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcjYwMC5jCkBAIC0yNjM2LDgg
KzI2MzYsOCBAQCBpbnQgcjYwMF9jb3B5X2RtYShzdHJ1Y3QgcmFkZW9uX2RldmljZSAqcmRldiwK
IAogCWZvciAoaSA9IDA7IGkgPCBudW1fbG9vcHM7IGkrKykgewogCQljdXJfc2l6ZV9pbl9kdyA9
IHNpemVfaW5fZHc7Ci0JCWlmIChjdXJfc2l6ZV9pbl9kdyA+IDB4RkZGRikKLQkJCWN1cl9zaXpl
X2luX2R3ID0gMHhGRkZGOworCQlpZiAoY3VyX3NpemVfaW5fZHcgPiAweEZGRkUpCisJCQljdXJf
c2l6ZV9pbl9kdyA9IDB4RkZGRTsKIAkJc2l6ZV9pbl9kdyAtPSBjdXJfc2l6ZV9pbl9kdzsKIAkJ
cmFkZW9uX3Jpbmdfd3JpdGUocmluZywgRE1BX1BBQ0tFVChETUFfUEFDS0VUX0NPUFksIDAsIDAs
IGN1cl9zaXplX2luX2R3KSk7CiAJCXJhZGVvbl9yaW5nX3dyaXRlKHJpbmcsIGRzdF9vZmZzZXQg
JiAweGZmZmZmZmZjKTsKLS0gCjEuNy43LjUKCg==
--bcaec54fb410684ac804d256ba84--
