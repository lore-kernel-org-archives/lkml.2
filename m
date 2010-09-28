Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab0I1U54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:57:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273Ab0I1U5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <20100928134721.f79a5955.akpm@linux-foundation.org>
References: <4CA09977.80506@panasas.com> <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
 <20100928134721.f79a5955.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Sep 2010 13:57:04 -0700
Message-ID: <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Julia Lawall <julia@diku.dk>,
        "David S. Miller" <davem@davemloft.net>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Content-Type: multipart/mixed; boundary=0016364ece5684ec7504915817ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364ece5684ec7504915817ba
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 28, 2010 at 1:47 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> And I misread that, assuming that it's just a wrapper around
> eth_mac_addr(). =A0Only it isn't, because it passes eth_mac_addr() the
> MAC address's address directly (with ->sa_data). =A0But eth_mac_addr()
> expects a `struct sockaddr *'.
>
> And for some wtf reason, eth_mac_addr() passes that `struct
> sockaddr *' in a `void *', thus cunningly hiding the bug.
>
> Yeah, please revert it.

Well, the alternative would be to just fix uml_net_set_mac(). The code
before the patch was clearly crap too, so reverting may make it work,
but gets us back to a stupid situation with two different initializers
for one field.

So perhaps something like the attached patch would make it work, and
have the locking in place that apparently people think it should have?

Boaz?

                     Linus

--0016364ece5684ec7504915817ba
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gen8xns60

IGFyY2gvdW0vZHJpdmVycy9uZXRfa2Vybi5jIHwgICAgNiArKystLS0KIDEgZmlsZXMgY2hhbmdl
ZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvdW0v
ZHJpdmVycy9uZXRfa2Vybi5jIGIvYXJjaC91bS9kcml2ZXJzL25ldF9rZXJuLmMKaW5kZXggMmFi
MjMzYi4uZTQ0ZmQ4NyAxMDA2NDQKLS0tIGEvYXJjaC91bS9kcml2ZXJzL25ldF9rZXJuLmMKKysr
IGIvYXJjaC91bS9kcml2ZXJzL25ldF9rZXJuLmMKQEAgLTI1NywxNCArMjU3LDE0IEBAIHN0YXRp
YyB2b2lkIHVtbF9uZXRfdHhfdGltZW91dChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQogCiBzdGF0
aWMgaW50IHVtbF9uZXRfc2V0X21hYyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCB2b2lkICphZGRy
KQogeworCWludCByZXQ7CiAJc3RydWN0IHVtbF9uZXRfcHJpdmF0ZSAqbHAgPSBuZXRkZXZfcHJp
dihkZXYpOwotCXN0cnVjdCBzb2NrYWRkciAqaHdhZGRyID0gYWRkcjsKIAogCXNwaW5fbG9ja19p
cnEoJmxwLT5sb2NrKTsKLQlldGhfbWFjX2FkZHIoZGV2LCBod2FkZHItPnNhX2RhdGEpOworCXJl
dCA9IGV0aF9tYWNfYWRkcihkZXYsIGFkZHIpOwogCXNwaW5fdW5sb2NrX2lycSgmbHAtPmxvY2sp
OwogCi0JcmV0dXJuIDA7CisJcmV0dXJuIHJldDsKIH0KIAogc3RhdGljIGludCB1bWxfbmV0X2No
YW5nZV9tdHUoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwgaW50IG5ld19tdHUpCg==
--0016364ece5684ec7504915817ba--
