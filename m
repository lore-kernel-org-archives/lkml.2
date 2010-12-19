Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0LSVUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:20:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756728Ab0LSVUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:20:05 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1012142219240.10437@xanadu.home>
References: <alpine.LFD.2.00.1012142219240.10437@xanadu.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 19 Dec 2010 13:19:42 -0800
Message-ID: <AANLkTik8Jd4Q4xVZqTCw=gMP6z_ZLv=nn+zN2tVLfi1M@mail.gmail.com>
Subject: Re: [PATCH] clarify a usage constraint for cnt32_to_63()
To: Nicolas Pitre <nico@fluxnic.net>
Cc: David Howells <dhowells@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0022152d6f5d78ffe20497c9f776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0022152d6f5d78ffe20497c9f776
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Dec 14, 2010 at 7:44 PM, Nicolas Pitre <nico@fluxnic.net> wrote:
>
> The cnt32_to_63 algorithm relies on proper counter data evaluation
> ordering to work properly. This was missing from the provided
> documentation.
>
> Let's augment the documentation with the missing usage constraint and
> fix the only instance that got it wrong.

Hmm. In the meantime, mn10300 seems to have changed its get_cycles()
to count up like a normal architecture.

So I _think_ the nm10300 part of the patch should now look like the
attached. Untested. I'd like to get an ack from David or at least
somebody who compiles (and preferably tests) mn10300. And then
preferably a re-send of the whole patch.

Hmm?

                          Linus

--0022152d6f5d78ffe20497c9f776
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghwfvuiq0

IGFyY2gvbW4xMDMwMC9rZXJuZWwvdGltZS5jIHwgICAgOCArKy0tLS0tLQogMSBmaWxlcyBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9t
bjEwMzAwL2tlcm5lbC90aW1lLmMgYi9hcmNoL21uMTAzMDAva2VybmVsL3RpbWUuYwppbmRleCBm
ODYwYTM0Li41MTE0ZWI4IDEwMDY0NAotLS0gYS9hcmNoL21uMTAzMDAva2VybmVsL3RpbWUuYwor
KysgYi9hcmNoL21uMTAzMDAva2VybmVsL3RpbWUuYwpAQCAtNDAsMjEgKzQwLDE3IEBAIHVuc2ln
bmVkIGxvbmcgbG9uZyBzY2hlZF9jbG9jayh2b2lkKQogCQl1bnNpZ25lZCBsb25nIGxvbmcgbGw7
CiAJCXVuc2lnbmVkIGxbMl07CiAJfSB0c2M2NCwgcmVzdWx0OwotCXVuc2lnbmVkIGxvbmcgdHNj
LCB0bXA7CisJdW5zaWduZWQgbG9uZyB0bXA7CiAJdW5zaWduZWQgcHJvZHVjdFszXTsgLyogOTYt
Yml0IGludGVybWVkaWF0ZSB2YWx1ZSAqLwogCiAJLyogY250MzJfdG9fNjMoKSBpcyBub3Qgc2Fm
ZSB3aXRoIHByZWVtcHRpb24gKi8KIAlwcmVlbXB0X2Rpc2FibGUoKTsKIAotCS8qIHJlYWQgdGhl
IFRTQyB2YWx1ZQotCSAqLwotCXRzYyA9IGdldF9jeWNsZXMoKTsKLQogCS8qIGV4cGFuZCB0byA2
NC1iaXRzLgogCSAqIC0gc2NoZWRfY2xvY2soKSBtdXN0IGJlIGNhbGxlZCBvbmNlIGEgbWludXRl
IG9yIGJldHRlciBvciB0aGUKIAkgKiAgIGZvbGxvd2luZyB3aWxsIGdvIGhvcnJpYmx5IHdyb25n
IC0gc2VlIGNudDMyX3RvXzYzKCkKIAkgKi8KLQl0c2M2NC5sbCA9IGNudDMyX3RvXzYzKHRzYykg
JiAweDdmZmZmZmZmZmZmZmZmZmZVTEw7CisJdHNjNjQubGwgPSBjbnQzMl90b182MyhnZXRfY3lj
bGVzKCkpICYgMHg3ZmZmZmZmZmZmZmZmZmZmVUxMOwogCiAJcHJlZW1wdF9lbmFibGUoKTsKIAo=
--0022152d6f5d78ffe20497c9f776--
