Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab1FWTSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:18:33 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60603 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab1FWTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=NsrJfFDzhS6Br6FHASZAdBF/+SFOVAdXp5za7gU/SsumozS2UAZ9jsOT+Vck8qkCD7
         7IpO3a1PtPYY37qawxUHNJanst63/qRymK3t+9skTRKZa6RUU6tk+wr7PEkU3u1WHw+U
         L3dNMQR1zinZcfsDR/FsomaX17hpVoHaKjixA=
MIME-Version: 1.0
In-Reply-To: <20110623163105.GC16892@linux-mips.org>
References: <20110623114536.GA14011@linux-mips.org>
	<BANLkTimR98qo5fjMRf-kZahcA=hE-E3+Hg@mail.gmail.com>
	<20110623163105.GC16892@linux-mips.org>
Date: Thu, 23 Jun 2011 15:18:27 -0400
Message-ID: <BANLkTin7vqGFZpCoLJY+NDfmNroZWWAOgg@mail.gmail.com>
Subject: Re: [PATCH] STAGING: Comedi: Build only on arches providing PAGE_KERNEL_NOCACHE
From: Arnaud Lacombe <lacombar@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-am33-list@redhat.com, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-arch@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org
Content-Type: multipart/mixed; boundary=bcaec521627119bf0a04a665f307
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec521627119bf0a04a665f307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 23, 2011 at 12:31 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
> On Thu, Jun 23, 2011 at 06:01:47PM +0200, Geert Uytterhoeven wrote:
>
>> If only to get m68k/allmodconfig going again (hmm, there's another
>> staging driver
>> preventing a green light).
>
> I ran into this doing an allyesconfig. =A0Allyesconfig has one disadvanta=
ge,
> for choice it will only select the first or default option which means
> that option gets exercised well and all the other options not at all. =A0=
On
> MIPS that'd be IP22, 32-bit, R4x00, big endian, 4K pages, no multithreadi=
ng,
> 250Hz. =A0Make randconfig disables lots of things so often misses the
> opportunity to trigger some issues.
>
> I'd really want an "make allrandconfig" which enables as many options as
> possible but picks a random one from choice statements, something like th=
at.
>
Something like the attached patch ? [sorry for the attachment, gmail
is so much a PITA for that ...]

 - Arnaud

ps: the patch breaks all the others *config target.

> =A0Ralf
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" i=
n
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--bcaec521627119bf0a04a665f307
Content-Type: text/x-patch; charset=US-ASCII; name="0001-allyesrandchoiceconfig.patch"
Content-Disposition: attachment; 
	filename="0001-allyesrandchoiceconfig.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpa3fc6w0

RnJvbSBmNGIxNWY4YWMyN2NlMDkxM2NiNGRjYTBiMGUyNmYxYWFmMzAwMjVlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBcm5hdWQgTGFjb21iZSA8bGFjb21iYXJAZ21haWwuY29tPgpE
YXRlOiBUaHUsIDIzIEp1biAyMDExIDE1OjExOjI0IC0wNDAwClN1YmplY3Q6IFtQQVRDSF0gYWxs
eWVzcmFuZGNob2ljZWNvbmZpZwoKLS0tCiBzY3JpcHRzL2tjb25maWcvTWFrZWZpbGUgICB8ICAg
IDIgKy0KIHNjcmlwdHMva2NvbmZpZy9jb25mLmMgICAgIHwgICAgNyArKysrKysrCiBzY3JpcHRz
L2tjb25maWcvY29uZmRhdGEuYyB8ICAgMTQgKysrKysrKysrKystLS0KIHNjcmlwdHMva2NvbmZp
Zy9sa2MuaCAgICAgIHwgICAgMSArCiA0IGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyks
IDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9rY29uZmlnL01ha2VmaWxlIGIv
c2NyaXB0cy9rY29uZmlnL01ha2VmaWxlCmluZGV4IGZhYTlhNDcuLjRlYjllYWMgMTAwNjQ0Ci0t
LSBhL3NjcmlwdHMva2NvbmZpZy9NYWtlZmlsZQorKysgYi9zY3JpcHRzL2tjb25maWcvTWFrZWZp
bGUKQEAgLTk4LDcgKzk4LDcgQEAgdXBkYXRlLXBvLWNvbmZpZzogJChvYmopL2t4Z2V0dGV4dCAk
KG9iaikvZ2NvbmYuZ2xhZGUuaAogCiBQSE9OWSArPSBhbGxub2NvbmZpZyBhbGx5ZXNjb25maWcg
YWxsbW9kY29uZmlnIGFsbGRlZmNvbmZpZyByYW5kY29uZmlnCiAKLWFsbG5vY29uZmlnIGFsbHll
c2NvbmZpZyBhbGxtb2Rjb25maWcgYWxsZGVmY29uZmlnIHJhbmRjb25maWc6ICQob2JqKS9jb25m
CithbGxub2NvbmZpZyBhbGx5ZXNjb25maWcgYWxseWVzcmFuZGNob2ljZWNvbmZpZyBhbGxtb2Rj
b25maWcgYWxsZGVmY29uZmlnIHJhbmRjb25maWc6ICQob2JqKS9jb25mCiAJJDwgLS0kQCAkKEtj
b25maWcpCiAKIFBIT05ZICs9IGxpc3RuZXdjb25maWcgb2xkbm9jb25maWcgc2F2ZWRlZmNvbmZp
ZyBkZWZjb25maWcKZGlmZiAtLWdpdCBhL3NjcmlwdHMva2NvbmZpZy9jb25mLmMgYi9zY3JpcHRz
L2tjb25maWcvY29uZi5jCmluZGV4IDAwNmFkODEuLjliMWMzMjQgMTAwNjQ0Ci0tLSBhL3Njcmlw
dHMva2NvbmZpZy9jb25mLmMKKysrIGIvc2NyaXB0cy9rY29uZmlnL2NvbmYuYwpAQCAtMzMsNiAr
MzMsNyBAQCBlbnVtIGlucHV0X21vZGUgewogCXNhdmVkZWZjb25maWcsCiAJbGlzdG5ld2NvbmZp
ZywKIAlvbGRub2NvbmZpZywKKwlhbGx5ZXNyYW5kY2hvaWNlY29uZmlnLAogfSBpbnB1dF9tb2Rl
ID0gb2xkYXNrY29uZmlnOwogCiBjaGFyICpkZWZjb25maWdfZmlsZTsKQEAgLTQ1Myw2ICs0NTQs
NyBAQCBzdGF0aWMgc3RydWN0IG9wdGlvbiBsb25nX29wdHNbXSA9IHsKIAl7InJhbmRjb25maWci
LCAgICAgIG5vX2FyZ3VtZW50LCAgICAgICBOVUxMLCByYW5kY29uZmlnfSwKIAl7Imxpc3RuZXdj
b25maWciLCAgIG5vX2FyZ3VtZW50LCAgICAgICBOVUxMLCBsaXN0bmV3Y29uZmlnfSwKIAl7Im9s
ZG5vY29uZmlnIiwgICAgIG5vX2FyZ3VtZW50LCAgICAgICBOVUxMLCBvbGRub2NvbmZpZ30sCisJ
eyJhbGx5ZXNyYW5kY2hvaWNlY29uZmlnIiwgbm9fYXJndW1lbnQsIE5VTEwsIGFsbHllc3JhbmRj
aG9pY2Vjb25maWd9LAogCXtOVUxMLCAwLCBOVUxMLCAwfQogfTsKIApAQCAtNDc2LDYgKzQ3OCw3
IEBAIGludCBtYWluKGludCBhYywgY2hhciAqKmF2KQogCQljYXNlIHNhdmVkZWZjb25maWc6CiAJ
CQlkZWZjb25maWdfZmlsZSA9IG9wdGFyZzsKIAkJCWJyZWFrOworCQljYXNlIGFsbHllc3JhbmRj
aG9pY2Vjb25maWc6CiAJCWNhc2UgcmFuZGNvbmZpZzoKIAkJewogCQkJc3RydWN0IHRpbWV2YWwg
bm93OwpAQCAtNTc5LDYgKzU4MiwxMCBAQCBpbnQgbWFpbihpbnQgYWMsIGNoYXIgKiphdikKIAlj
YXNlIGFsbG5vY29uZmlnOgogCQljb25mX3NldF9hbGxfbmV3X3N5bWJvbHMoZGVmX25vKTsKIAkJ
YnJlYWs7CisJY2FzZSBhbGx5ZXNyYW5kY2hvaWNlY29uZmlnOgorCQljb25mX3NldF9hbGxfbmV3
X3N5bWJvbHMoZGVmX3llcyk7CisJCWNvbmZfc2V0X2FsbF9uZXdfY2hvaWNlX3N5bWJvbHMoZGVm
X3JhbmRvbSk7CisJCWJyZWFrOwogCWNhc2UgYWxseWVzY29uZmlnOgogCQljb25mX3NldF9hbGxf
bmV3X3N5bWJvbHMoZGVmX3llcyk7CiAJCWJyZWFrOwpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9rY29u
ZmlnL2NvbmZkYXRhLmMgYi9zY3JpcHRzL2tjb25maWcvY29uZmRhdGEuYwppbmRleCAyYmFmZDlh
Li5lOTZiOTVhIDEwMDY0NAotLS0gYS9zY3JpcHRzL2tjb25maWcvY29uZmRhdGEuYworKysgYi9z
Y3JpcHRzL2tjb25maWcvY29uZmRhdGEuYwpAQCAtOTQ1LDYgKzk0NSw3IEBAIHN0YXRpYyB2b2lk
IHJhbmRvbWl6ZV9jaG9pY2VfdmFsdWVzKHN0cnVjdCBzeW1ib2wgKmNzeW0pCiAKIAljbnQgPSAw
OwogCWV4cHJfbGlzdF9mb3JfZWFjaF9zeW0ocHJvcC0+ZXhwciwgZSwgc3ltKSB7CisJCXByaW50
ZigiJXMgJWQgJWRcbiIsIHN5bS0+bmFtZSwgZGVmLCBjbnQrMSk7CiAJCWlmIChkZWYgPT0gY250
KyspIHsKIAkJCXN5bS0+ZGVmW1NfREVGX1VTRVJdLnRyaSA9IHllczsKIAkJCWNzeW0tPmRlZltT
X0RFRl9VU0VSXS52YWwgPSBzeW07CkBAIC05ODAsMTIgKzk4MSwxNCBAQCBzdGF0aWMgdm9pZCBz
ZXRfYWxsX2Nob2ljZV92YWx1ZXMoc3RydWN0IHN5bWJvbCAqY3N5bSkKIAogdm9pZCBjb25mX3Nl
dF9hbGxfbmV3X3N5bWJvbHMoZW51bSBjb25mX2RlZl9tb2RlIG1vZGUpCiB7Ci0Jc3RydWN0IHN5
bWJvbCAqc3ltLCAqY3N5bTsKKwlzdHJ1Y3Qgc3ltYm9sICpzeW07CiAJaW50IGksIGNudDsKIAog
CWZvcl9hbGxfc3ltYm9scyhpLCBzeW0pIHsKIAkJaWYgKHN5bV9oYXNfdmFsdWUoc3ltKSkKIAkJ
CWNvbnRpbnVlOworCQlpZiAoc3ltX2lzX2Nob2ljZShzeW0pKQorCQkJY29udGludWU7CiAJCXN3
aXRjaCAoc3ltX2dldF90eXBlKHN5bSkpIHsKIAkJY2FzZSBTX0JPT0xFQU46CiAJCWNhc2UgU19U
UklTVEFURToKQEAgLTEwMDYsMTQgKzEwMDksMTkgQEAgdm9pZCBjb25mX3NldF9hbGxfbmV3X3N5
bWJvbHMoZW51bSBjb25mX2RlZl9tb2RlIG1vZGUpCiAJCQlkZWZhdWx0OgogCQkJCWNvbnRpbnVl
OwogCQkJfQotCQkJaWYgKCEoc3ltX2lzX2Nob2ljZShzeW0pICYmIG1vZGUgPT0gZGVmX3JhbmRv
bSkpCi0JCQkJc3ltLT5mbGFncyB8PSBTWU1CT0xfREVGX1VTRVI7CisJCQlzeW0tPmZsYWdzIHw9
IFNZTUJPTF9ERUZfVVNFUjsKIAkJCWJyZWFrOwogCQlkZWZhdWx0OgogCQkJYnJlYWs7CiAJCX0K
IAogCX0KK30KKwordm9pZCBjb25mX3NldF9hbGxfbmV3X2Nob2ljZV9zeW1ib2xzKGVudW0gY29u
Zl9kZWZfbW9kZSBtb2RlKQoreworCXN0cnVjdCBzeW1ib2wgKmNzeW07CisJaW50IGk7CiAKIAlz
eW1fY2xlYXJfYWxsX3ZhbGlkKCk7CiAKZGlmZiAtLWdpdCBhL3NjcmlwdHMva2NvbmZpZy9sa2Mu
aCBiL3NjcmlwdHMva2NvbmZpZy9sa2MuaAppbmRleCBmZWJmMGM5Li42NzJjNzhmIDEwMDY0NAot
LS0gYS9zY3JpcHRzL2tjb25maWcvbGtjLmgKKysrIGIvc2NyaXB0cy9rY29uZmlnL2xrYy5oCkBA
IC05MSw2ICs5MSw3IEBAIGNoYXIgKmNvbmZfZ2V0X2RlZmF1bHRfY29uZm5hbWUodm9pZCk7CiB2
b2lkIHN5bV9zZXRfY2hhbmdlX2NvdW50KGludCBjb3VudCk7CiB2b2lkIHN5bV9hZGRfY2hhbmdl
X2NvdW50KGludCBjb3VudCk7CiB2b2lkIGNvbmZfc2V0X2FsbF9uZXdfc3ltYm9scyhlbnVtIGNv
bmZfZGVmX21vZGUgbW9kZSk7Cit2b2lkIGNvbmZfc2V0X2FsbF9uZXdfY2hvaWNlX3N5bWJvbHMo
ZW51bSBjb25mX2RlZl9tb2RlIG1vZGUpOwogCiAvKiBjb25mZGF0YS5jIGFuZCBleHByLmMgKi8K
IHN0YXRpYyBpbmxpbmUgdm9pZCB4ZndyaXRlKGNvbnN0IHZvaWQgKnN0ciwgc2l6ZV90IGxlbiwg
c2l6ZV90IGNvdW50LCBGSUxFICpvdXQpCi0tIAoxLjcuMy40LjU3NC5nNjA4Yi5kaXJ0eQoK
--bcaec521627119bf0a04a665f307--
