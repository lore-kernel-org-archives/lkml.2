Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab1BIWJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:09:22 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48733 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab1BIWJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:09:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KvF8oBeXQQxzqBPqq8zpJ+D/K70D7lFYQYEt0+IuqQrPC1scVL1sgUTJ2W+6Gpzvt0
         /hFTjpQDCKZ6bpU0HVtL/xtFwmTn4OWitlFFda5FypAyU1QTHtiqNiMz4rmpZgKySROc
         f5N2fuY4nbYaUG/8U6ACOlDyf9uAqIVUkJsjQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
References: <4D51AD03.7030401@gmail.com>
	<AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
Date: Wed, 9 Feb 2011 17:09:18 -0500
Message-ID: <AANLkTimBwM=iacwPosrYXU_jN=DXnEkWL3jvFcarDN23@mail.gmail.com>
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen
 flicker like its broken or half plugged in
From: Alex Deucher <alexdeucher@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Content-Type: multipart/mixed; boundary=20cf30433f1a69a403049be0b736
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf30433f1a69a403049be0b736
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 8, 2011 at 4:20 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Tue, Feb 8, 2011 at 3:52 PM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
>> With the current HEAD Im getting screen flickering really bad to point w=
here
>> it looks like the screen is damaged and/or half plugged-in etc..
>>
>> the bisect pointed to here:
>>
>> commit 619efb105924d8cafa0c1dd9389e9ab506f5425d
>>
>> doing a git revert 619efb10592
>> gets the screen working properly again.
>> I havent looked much through the code to see if I can fix this. for the =
time
>> being I'll revert this on my machine with the current, until later on.
>
> The attached patch should fix it assuming I got your pci ids correct.
> I'm done with the pll stuff; too may fixes break other boards. =A0Just
> add a quirk table and be done with it.
>

The attached patch builds on the previous one and fixes an additional
regression.

Alex


> Alex
>
>>
>> lspci -vv shows my card info(let me know if you need anymore)
>>
>> 01:00.0 VGA compatible controller: ATI Technologies Inc M56P [Radeon
>> Mobility X1600] (prog-if 00 [VGA controller])
>> =A0 =A0 =A0 =A0Subsystem: Apple Computer Inc. MacBook Pro
>> =A0 =A0 =A0 =A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoo=
p- ParErr-
>> Stepping- SERR- FastB2B- DisINTx+
>> =A0 =A0 =A0 =A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >=
TAbort-
>> <TAbort- <MAbort- >SERR- <PERR- INTx-
>> =A0 =A0 =A0 =A0Latency: 0, Cache Line Size: 256 bytes
>> =A0 =A0 =A0 =A0Interrupt: pin A routed to IRQ 42
>> =A0 =A0 =A0 =A0Region 0: Memory at 40000000 (32-bit, prefetchable) [size=
=3D128M]
>> =A0 =A0 =A0 =A0Region 1: I/O ports at 3000 [size=3D256]
>> =A0 =A0 =A0 =A0Region 2: Memory at 50300000 (32-bit, non-prefetchable) [=
size=3D64K]
>> =A0 =A0 =A0 =A0Expansion ROM at 50320000 [disabled] [size=3D128K]
>> =A0 =A0 =A0 =A0Capabilities: <access denied>
>> =A0 =A0 =A0 =A0Kernel driver in use: radeon
>> =A0 =A0 =A0 =A0Kernel modules: radeon
>>
>>
>> Justin P. Mattock
>>
>

--20cf30433f1a69a403049be0b736
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-pll-quirk-cleanup.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-pll-quirk-cleanup.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjysl0pc1

RnJvbSBjODhjZjljMjQ2MzYyOWFiMGNlZjdkZjhhZGUzNDc1MGNkZTliNDBhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogV2VkLCA5IEZlYiAyMDExIDE3OjA1OjA3IC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gZHJt
L3JhZGVvbi9rbXM6IHBsbCBxdWlyayBjbGVhbnVwCgpEZWZhdWx0IHRvIGxlZ2FjeSBwbGwgYWxn
bywgYWRkIHF1aXJrcyBmb3Igc3BlY2lmaWMKcmVncmVzc2lvbnMuICBGaXhlcyByZWdyZXNzaW9u
cyByZXBvcnRlZCBpbjoKaHR0cHM6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9p
ZD0yNjU1MgoKU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4ZGV1Y2hlckBnbWFpbC5j
b20+CkNjOiBzdGFibGVAa2VybmVsLm9yZwotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRv
bWJpb3NfY3J0Yy5jIHwgICA1MiArKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tCiBkcml2
ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9tb2RlLmggICB8ICAgIDggKysrKysKIDIgZmlsZXMg
Y2hhbmdlZCwgNTAgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMgYi9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL2F0b21iaW9zX2NydGMuYwppbmRleCA0YTUwNWJhLi5jYzZiZGQ4IDEwMDY0NAotLS0g
YS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYworKysgYi9kcml2ZXJzL2dw
dS9kcm0vcmFkZW9uL2F0b21iaW9zX2NydGMuYwpAQCAtMzEsNiArMzEsMTEgQEAKICNpbmNsdWRl
ICJhdG9tLmgiCiAjaW5jbHVkZSAiYXRvbS1iaXRzLmgiCiAKK3N0YXRpYyBlbnVtIHJhZGVvbl9w
bGxfYWxnbworYXRvbWJpb3NfY3J0Y19waWNrX3BsbF9hbGdvKHN0cnVjdCBkcm1fY3J0YyAqY3J0
YywKKwkJCSAgICBzdHJ1Y3QgZHJtX2Rpc3BsYXlfbW9kZSAqbW9kZSwKKwkJCSAgICB1aW50MzJf
dCBhY3RpdmVfZGV2aWNlKTsKKwogc3RhdGljIHZvaWQgYXRvbWJpb3Nfb3ZlcnNjYW5fc2V0dXAo
c3RydWN0IGRybV9jcnRjICpjcnRjLAogCQkJCSAgICBzdHJ1Y3QgZHJtX2Rpc3BsYXlfbW9kZSAq
bW9kZSwKIAkJCQkgICAgc3RydWN0IGRybV9kaXNwbGF5X21vZGUgKmFkanVzdGVkX21vZGUpCkBA
IC01MTksNiArNTI0LDcgQEAgc3RhdGljIHUzMiBhdG9tYmlvc19hZGp1c3RfcGxsKHN0cnVjdCBk
cm1fY3J0YyAqY3J0YywKIAogCS8qIHJlc2V0IHRoZSBwbGwgZmxhZ3MgKi8KIAlwbGwtPmZsYWdz
ID0gMDsKKwlwbGwtPmFsZ28gPSBSQURFT05fUExMX0FMR09fTEVHQUNZOwogCiAJaWYgKEFTSUNf
SVNfQVZJVk8ocmRldikpIHsKIAkJaWYgKChyZGV2LT5mYW1pbHkgPT0gQ0hJUF9SUzYwMCkgfHwK
QEAgLTU4NCw2ICs1OTAsNyBAQCBzdGF0aWMgdTMyIGF0b21iaW9zX2FkanVzdF9wbGwoc3RydWN0
IGRybV9jcnRjICpjcnRjLAogCQkJCWlmIChlbmNvZGVyLT5lbmNvZGVyX3R5cGUgPT0gRFJNX01P
REVfRU5DT0RFUl9MVkRTKQogCQkJCQlwbGwtPmZsYWdzIHw9IFJBREVPTl9QTExfVVNFX1JFRl9E
SVY7CiAJCQl9CisJCQlwbGwtPmFsZ28gPSBhdG9tYmlvc19jcnRjX3BpY2tfcGxsX2FsZ28oY3J0
YywgbW9kZSwgcmFkZW9uX2VuY29kZXItPmFjdGl2ZV9kZXZpY2UpOwogCQkJYnJlYWs7CiAJCX0K
IAl9CkBAIC04MzksMjkgKzg0Niw1NCBAQCBzdGF0aWMgdm9pZCBhdG9tYmlvc19jcnRjX3Byb2dy
YW1fcGxsKHN0cnVjdCBkcm1fY3J0YyAqY3J0YywKIAlhdG9tX2V4ZWN1dGVfdGFibGUocmRldi0+
bW9kZV9pbmZvLmF0b21fY29udGV4dCwgaW5kZXgsICh1aW50MzJfdCAqKSZhcmdzKTsKIH0KIAot
I2RlZmluZSBSQURFT05fUExMX0FMR09fTEVHQUNZIDAKLSNkZWZpbmUgUkFERU9OX1BMTF9BTEdP
X0FWSVZPICAxCiAKLXN0YXRpYyBpbnQgYXRvbWJpb3NfY3J0Y19waWNrX3BsbF9hbGdvKHN0cnVj
dCBkcm1fY3J0YyAqY3J0Yywgc3RydWN0IGRybV9kaXNwbGF5X21vZGUgKm1vZGUpCitzdGF0aWMg
ZW51bSByYWRlb25fcGxsX2FsZ28KK2F0b21iaW9zX2NydGNfcGlja19wbGxfYWxnbyhzdHJ1Y3Qg
ZHJtX2NydGMgKmNydGMsCisJCQkgICAgc3RydWN0IGRybV9kaXNwbGF5X21vZGUgKm1vZGUsCisJ
CQkgICAgdWludDMyX3QgYWN0aXZlX2RldmljZSkKIHsKIAlzdHJ1Y3QgZHJtX2RldmljZSAqZGV2
ID0gY3J0Yy0+ZGV2OwotCXN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2ID0gZGV2LT5kZXZfcHJp
dmF0ZTsKIAogCS8qIGJvYXJkIHNwZWNpZmljIHF1aXJrcyAqLwotCS8qIGZ1bmt5IG1hY2Jvb2tz
ICovCisKKwkvKiBsZWdhY3kgYWxnbyAqLworCS8qIG1hY2Jvb2twcm8yLDIgKi8KIAlpZiAoKGRl
di0+cGRldi0+ZGV2aWNlID09IDB4NzFDNSkgJiYKIAkgICAgKGRldi0+cGRldi0+c3Vic3lzdGVt
X3ZlbmRvciA9PSAweDEwNmIpICYmCiAJICAgIChkZXYtPnBkZXYtPnN1YnN5c3RlbV9kZXZpY2Ug
PT0gMHgwMDgwKSkgewogCQlyZXR1cm4gUkFERU9OX1BMTF9BTEdPX0xFR0FDWTsKIAl9CiAKLQkv
KiBkZWZhdWx0cyAgKi8KLQkvKiBydjUxNSBzZWVtcyBoYXBwaWVyIHdpdGggdGhlIG9sZCBhbGdv
ICovCi0JaWYgKHJkZXYtPmZhbWlseSA9PSBDSElQX1JWNTE1KQorCS8qIFRoaW5rcGFkIFQ2MCAq
LworCWlmICgoZGV2LT5wZGV2LT5kZXZpY2UgPT0gMHg3MTQ1KSAmJgorCSAgICAoZGV2LT5wZGV2
LT5zdWJzeXN0ZW1fdmVuZG9yID09IDB4MTdhYSkgJiYKKwkgICAgKGRldi0+cGRldi0+c3Vic3lz
dGVtX2RldmljZSA9PSAweDIwMDYpKSB7CiAJCXJldHVybiBSQURFT05fUExMX0FMR09fTEVHQUNZ
OwotCWVsc2UgaWYgKEFTSUNfSVNfQVZJVk8ocmRldikpCisJfQorCisJLyogQWNlciBSUzg4MCAq
LworCWlmICgoZGV2LT5wZGV2LT5kZXZpY2UgPT0gMHg5NzEyKSAmJgorCSAgICAoZGV2LT5wZGV2
LT5zdWJzeXN0ZW1fdmVuZG9yID09IDB4MTAyNSkgJiYKKwkgICAgKGRldi0+cGRldi0+c3Vic3lz
dGVtX2RldmljZSA9PSAweDAyN2QpKSB7CisJCXJldHVybiBSQURFT05fUExMX0FMR09fTEVHQUNZ
OworCX0KKworCS8qIGF2aXZvIGFsZ28gKi8KKwkvKiBQQyBQYXJ0bmVyIFJWNjMwICovCisJaWYg
KChkZXYtPnBkZXYtPmRldmljZSA9PSAweDk1ODkpICYmCisJICAgIChkZXYtPnBkZXYtPnN1YnN5
c3RlbV92ZW5kb3IgPT0gMHgxNzRiKSAmJgorCSAgICAoZGV2LT5wZGV2LT5zdWJzeXN0ZW1fZGV2
aWNlID09IDB4ZTQxMCkpIHsKIAkJcmV0dXJuIFJBREVPTl9QTExfQUxHT19BVklWTzsKKwl9CisK
KwkvKiBUb3NoaWJhIFNhdGVsbGl0ZSBBMTAwICovCisJaWYgKChkZXYtPnBkZXYtPmRldmljZSA9
PSAweDcxQzUpICYmCisJICAgIChkZXYtPnBkZXYtPnN1YnN5c3RlbV92ZW5kb3IgPT0gMHgxMTc5
KSAmJgorCSAgICAoZGV2LT5wZGV2LT5zdWJzeXN0ZW1fZGV2aWNlID09IDB4ZmYxMCkpIHsKKwkJ
cmV0dXJuIFJBREVPTl9QTExfQUxHT19BVklWTzsKKwl9CiAKKwkvKiBkZWZhdWx0IHRvIHRoZSBs
ZWdhY3kgYWxnbyAqLwogCXJldHVybiBSQURFT05fUExMX0FMR09fTEVHQUNZOwogfQogCkBAIC05
ODMsNyArMTAxNSw3IEBAIHN0YXRpYyB2b2lkIGF0b21iaW9zX2NydGNfc2V0X3BsbChzdHJ1Y3Qg
ZHJtX2NydGMgKmNydGMsIHN0cnVjdCBkcm1fZGlzcGxheV9tb2RlCiAJLyogYWRqdXN0IHBpeGVs
IGNsb2NrIGFzIG5lZWRlZCAqLwogCWFkanVzdGVkX2Nsb2NrID0gYXRvbWJpb3NfYWRqdXN0X3Bs
bChjcnRjLCBtb2RlLCBwbGwsIHNzX2VuYWJsZWQsICZzcyk7CiAKLQlzd2l0Y2ggKGF0b21iaW9z
X2NydGNfcGlja19wbGxfYWxnbyhjcnRjLCBtb2RlKSkgeworCXN3aXRjaCAocGxsLT5hbGdvKSB7
CiAJY2FzZSBSQURFT05fUExMX0FMR09fTEVHQUNZOgogCWRlZmF1bHQ6CiAJCXJhZGVvbl9jb21w
dXRlX3BsbF9sZWdhY3kocGxsLCBhZGp1c3RlZF9jbG9jaywgJnBsbF9jbG9jaywgJmZiX2Rpdiwg
JmZyYWNfZmJfZGl2LApkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25f
bW9kZS5oIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fbW9kZS5oCmluZGV4IGE2NzBj
YWEuLjFkNzYwYzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX21v
ZGUuaAorKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9tb2RlLmgKQEAgLTE1MSw2
ICsxNTEsMTIgQEAgc3RydWN0IHJhZGVvbl90bWRzX3BsbCB7CiAjZGVmaW5lIFJBREVPTl9QTExf
SVNfTENEICAgICAgICAgICAgICAgKDEgPDwgMTMpCiAjZGVmaW5lIFJBREVPTl9QTExfUFJFRkVS
X01JTk1fT1ZFUl9NQVhQICgxIDw8IDE0KQogCisvKiBwbGwgYWxnbyAqLworZW51bSByYWRlb25f
cGxsX2FsZ28geworCVJBREVPTl9QTExfQUxHT19MRUdBQ1ksCisJUkFERU9OX1BMTF9BTEdPX0FW
SVZPCit9OworCiBzdHJ1Y3QgcmFkZW9uX3BsbCB7CiAJLyogcmVmZXJlbmNlIGZyZXF1ZW5jeSAq
LwogCXVpbnQzMl90IHJlZmVyZW5jZV9mcmVxOwpAQCAtMTgzLDYgKzE4OSw4IEBAIHN0cnVjdCBy
YWRlb25fcGxsIHsKIAogCS8qIHBsbCBpZCAqLwogCXVpbnQzMl90IGlkOworCS8qIHBsbCBhbGdv
ICovCisJZW51bSByYWRlb25fcGxsX2FsZ28gYWxnbzsKIH07CiAKIHN0cnVjdCByYWRlb25faTJj
X2NoYW4gewotLSAKMS43LjEuMQoK
--20cf30433f1a69a403049be0b736--
