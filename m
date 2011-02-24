Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab1BXQio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 11:38:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756301Ab1BXQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 11:38:42 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTin8+F003-jFoQ0pd9OjN1oT2iqyNjd58SDJZuMK@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
 <20110222140349.GA20708@kryptos.osrc.amd.com> <AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
 <AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
 <AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
 <AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
 <AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com> <AANLkTin8+F003-jFoQ0pd9OjN1oT2iqyNjd58SDJZuMK@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Feb 2011 08:37:11 -0800
Message-ID: <AANLkTinzse1ZfEvAuWfuZ_8VDypcnD5poU6GwOdYTgWh@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000325575896e6facf049d09d67d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000325575896e6facf049d09d67d
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Feb 24, 2011 at 5:20 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>>
>> Every boot?
>
> Yes.
>
>> And just out of interest, what happens if you don't have the vesafb
>> driver at all?
>
> I used 'e' option from grub, removed the 'set gfxpayload = $linux_gfx_mode'
> and it works.
>
> dmesg: http://pastebin.com/JAZsk4vD

Hmm. So it definitely seems to be the hand-over.

Does this patch make any difference? When we unregister the old
framebuffer, we still leave it in the registered_fb[] array, which
looks wrong. But it would also be interesting to hear if setting
CONFIG_SLUB_DEBUG_ON or CONFIG_DEBUG_PAGEALLOC makes any difference
(they'd help detect accesses to free'd data structures).

                          Linus

--000325575896e6facf049d09d67d
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkjwbfnb0

IGRyaXZlcnMvdmlkZW8vZmJtZW0uYyB8ICAgIDEgKwogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2Vy
dGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy92aWRlby9mYm1l
bS5jIGIvZHJpdmVycy92aWRlby9mYm1lbS5jCmluZGV4IGUyYmY5NTMuLmU4Zjg5MjUgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvdmlkZW8vZmJtZW0uYworKysgYi9kcml2ZXJzL3ZpZGVvL2ZibWVtLmMK
QEAgLTE1MTEsNiArMTUxMSw3IEBAIHZvaWQgcmVtb3ZlX2NvbmZsaWN0aW5nX2ZyYW1lYnVmZmVy
cyhzdHJ1Y3QgYXBlcnR1cmVzX3N0cnVjdCAqYSwKIAkJCSAgICAgICAiJXMgdnMgJXMgLSByZW1v
dmluZyBnZW5lcmljIGRyaXZlclxuIiwKIAkJCSAgICAgICBuYW1lLCByZWdpc3RlcmVkX2ZiW2ld
LT5maXguaWQpOwogCQkJdW5yZWdpc3Rlcl9mcmFtZWJ1ZmZlcihyZWdpc3RlcmVkX2ZiW2ldKTsK
KwkJCXJlZ2lzdGVyZWRfZmJbaV0gPSBOVUxMOwogCQl9CiAJfQogfQo=
--000325575896e6facf049d09d67d--
