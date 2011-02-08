Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab1BHVUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:20:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33790 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab1BHVUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:20:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JGLBKRPxuvsLltq0G9iu7lpJsuPRm+wCptnJPSJlqej8mnx+N2Lv1+8R+x8I3CE19B
         nHAXpTAhD+Sw/uah2FTs1Xr7Kf4V6lfwVsifO17erl1pRWR5GHL9mokdHX3MQt4oAFAE
         Jbr/Cp2zNjmU0cd8AFIQbnej+DWDGEZJPIhBM=
MIME-Version: 1.0
In-Reply-To: <4D51AD03.7030401@gmail.com>
References: <4D51AD03.7030401@gmail.com>
Date: Tue, 8 Feb 2011 16:20:35 -0500
Message-ID: <AANLkTimXbbCJHs7WEfkbbQLpKqMM1G_qZ-cN1hcQ+3KJ@mail.gmail.com>
Subject: Re: [BISECTED] commit 619efb1059 makes the MacBookPro2,2 screen
 flicker like its broken or half plugged in
From: Alex Deucher <alexdeucher@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        airlied@redhat.com
Content-Type: multipart/mixed; boundary=0015174796485595bd049bcbebcb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015174796485595bd049bcbebcb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 8, 2011 at 3:52 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> With the current HEAD Im getting screen flickering really bad to point wh=
ere
> it looks like the screen is damaged and/or half plugged-in etc..
>
> the bisect pointed to here:
>
> commit 619efb105924d8cafa0c1dd9389e9ab506f5425d
>
> doing a git revert 619efb10592
> gets the screen working properly again.
> I havent looked much through the code to see if I can fix this. for the t=
ime
> being I'll revert this on my machine with the current, until later on.

The attached patch should fix it assuming I got your pci ids correct.
I'm done with the pll stuff; too may fixes break other boards.  Just
add a quirk table and be done with it.

Alex

>
> lspci -vv shows my card info(let me know if you need anymore)
>
> 01:00.0 VGA compatible controller: ATI Technologies Inc M56P [Radeon
> Mobility X1600] (prog-if 00 [VGA controller])
> =A0 =A0 =A0 =A0Subsystem: Apple Computer Inc. MacBook Pro
> =A0 =A0 =A0 =A0Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop=
- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> =A0 =A0 =A0 =A0Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >T=
Abort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> =A0 =A0 =A0 =A0Latency: 0, Cache Line Size: 256 bytes
> =A0 =A0 =A0 =A0Interrupt: pin A routed to IRQ 42
> =A0 =A0 =A0 =A0Region 0: Memory at 40000000 (32-bit, prefetchable) [size=
=3D128M]
> =A0 =A0 =A0 =A0Region 1: I/O ports at 3000 [size=3D256]
> =A0 =A0 =A0 =A0Region 2: Memory at 50300000 (32-bit, non-prefetchable) [s=
ize=3D64K]
> =A0 =A0 =A0 =A0Expansion ROM at 50320000 [disabled] [size=3D128K]
> =A0 =A0 =A0 =A0Capabilities: <access denied>
> =A0 =A0 =A0 =A0Kernel driver in use: radeon
> =A0 =A0 =A0 =A0Kernel modules: radeon
>
>
> Justin P. Mattock
>

--0015174796485595bd049bcbebcb
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-drm-radeon-kms-fix-pll-algo-quirk-function.patch"
Content-Disposition: attachment; 
	filename="0001-drm-radeon-kms-fix-pll-algo-quirk-function.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gjxbdik20

RnJvbSAxZmNlMDU4ZDdmMDYzYjQ4MWEyNzRiMGE2NTNmZmFkOTRmNWU5YjIzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhkZXVjaGVyQGdtYWlsLmNvbT4K
RGF0ZTogVHVlLCA4IEZlYiAyMDExIDE2OjEzOjI3IC0wNTAwClN1YmplY3Q6IFtQQVRDSF0gZHJt
L3JhZGVvbi9rbXM6IGZpeCBwbGwgYWxnbyBxdWlyayBmdW5jdGlvbgoKSSdtIHNpY2sgb2YgZmln
aHRpbmcgdGhpcy4gIEp1c3QgYWRkIGEgbmV3IHBpY2tfcGxsX2FsZ28oKQpmdW5jdGlvbiBhbmQg
cXVpcmsgc3BlY2lmaWMgYm9hcmRzIGFzIHRoZXkgYXJlIHJlcG9ydGVkLgoKQWRkIGEgcXVpcmsg
Zm9yIHRoZSBwbGwgYWxnbyBzZWxlY3Rpb24gb24gdGhlIE1hY0Jvb2tQcm8yLDIuCgpSZXBvcnRl
ZC1ieTogSnVzdGluIFAuIE1hdHRvY2sgPGp1c3Rpbm1hdHRvY2tAZ21haWwuY29tPgoKU2lnbmVk
LW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4ZGV1Y2hlckBnbWFpbC5jb20+CkNjOiBzdGFibGVA
a2VybmVsLm9yZwotLS0KIGRyaXZlcnMvZ3B1L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jIHwg
ICAzOSArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLQogMSBmaWxlcyBjaGFuZ2VkLCAz
MyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1
L2RybS9yYWRlb24vYXRvbWJpb3NfY3J0Yy5jIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9hdG9t
Ymlvc19jcnRjLmMKaW5kZXggZGQ0ZTNhYy4uNGE1MDViYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9n
cHUvZHJtL3JhZGVvbi9hdG9tYmlvc19jcnRjLmMKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9hdG9tYmlvc19jcnRjLmMKQEAgLTgzOSw2ICs4MzksMzIgQEAgc3RhdGljIHZvaWQgYXRvbWJp
b3NfY3J0Y19wcm9ncmFtX3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMsCiAJYXRvbV9leGVjdXRl
X3RhYmxlKHJkZXYtPm1vZGVfaW5mby5hdG9tX2NvbnRleHQsIGluZGV4LCAodWludDMyX3QgKikm
YXJncyk7CiB9CiAKKyNkZWZpbmUgUkFERU9OX1BMTF9BTEdPX0xFR0FDWSAwCisjZGVmaW5lIFJB
REVPTl9QTExfQUxHT19BVklWTyAgMQorCitzdGF0aWMgaW50IGF0b21iaW9zX2NydGNfcGlja19w
bGxfYWxnbyhzdHJ1Y3QgZHJtX2NydGMgKmNydGMsIHN0cnVjdCBkcm1fZGlzcGxheV9tb2RlICpt
b2RlKQoreworCXN0cnVjdCBkcm1fZGV2aWNlICpkZXYgPSBjcnRjLT5kZXY7CisJc3RydWN0IHJh
ZGVvbl9kZXZpY2UgKnJkZXYgPSBkZXYtPmRldl9wcml2YXRlOworCisJLyogYm9hcmQgc3BlY2lm
aWMgcXVpcmtzICovCisJLyogZnVua3kgbWFjYm9va3MgKi8KKwlpZiAoKGRldi0+cGRldi0+ZGV2
aWNlID09IDB4NzFDNSkgJiYKKwkgICAgKGRldi0+cGRldi0+c3Vic3lzdGVtX3ZlbmRvciA9PSAw
eDEwNmIpICYmCisJICAgIChkZXYtPnBkZXYtPnN1YnN5c3RlbV9kZXZpY2UgPT0gMHgwMDgwKSkg
eworCQlyZXR1cm4gUkFERU9OX1BMTF9BTEdPX0xFR0FDWTsKKwl9CisKKwkvKiBkZWZhdWx0cyAg
Ki8KKwkvKiBydjUxNSBzZWVtcyBoYXBwaWVyIHdpdGggdGhlIG9sZCBhbGdvICovCisJaWYgKHJk
ZXYtPmZhbWlseSA9PSBDSElQX1JWNTE1KQorCQlyZXR1cm4gUkFERU9OX1BMTF9BTEdPX0xFR0FD
WTsKKwllbHNlIGlmIChBU0lDX0lTX0FWSVZPKHJkZXYpKQorCQlyZXR1cm4gUkFERU9OX1BMTF9B
TEdPX0FWSVZPOworCisJcmV0dXJuIFJBREVPTl9QTExfQUxHT19MRUdBQ1k7Cit9CisKIHN0YXRp
YyB2b2lkIGF0b21iaW9zX2NydGNfc2V0X3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMsIHN0cnVj
dCBkcm1fZGlzcGxheV9tb2RlICptb2RlKQogewogCXN0cnVjdCByYWRlb25fY3J0YyAqcmFkZW9u
X2NydGMgPSB0b19yYWRlb25fY3J0YyhjcnRjKTsKQEAgLTk1NywxNiArOTgzLDE3IEBAIHN0YXRp
YyB2b2lkIGF0b21iaW9zX2NydGNfc2V0X3BsbChzdHJ1Y3QgZHJtX2NydGMgKmNydGMsIHN0cnVj
dCBkcm1fZGlzcGxheV9tb2RlCiAJLyogYWRqdXN0IHBpeGVsIGNsb2NrIGFzIG5lZWRlZCAqLwog
CWFkanVzdGVkX2Nsb2NrID0gYXRvbWJpb3NfYWRqdXN0X3BsbChjcnRjLCBtb2RlLCBwbGwsIHNz
X2VuYWJsZWQsICZzcyk7CiAKLQkvKiBydjUxNSBzZWVtcyBoYXBwaWVyIHdpdGggdGhlIG9sZCBh
bGdvICovCi0JaWYgKHJkZXYtPmZhbWlseSA9PSBDSElQX1JWNTE1KQorCXN3aXRjaCAoYXRvbWJp
b3NfY3J0Y19waWNrX3BsbF9hbGdvKGNydGMsIG1vZGUpKSB7CisJY2FzZSBSQURFT05fUExMX0FM
R09fTEVHQUNZOgorCWRlZmF1bHQ6CiAJCXJhZGVvbl9jb21wdXRlX3BsbF9sZWdhY3kocGxsLCBh
ZGp1c3RlZF9jbG9jaywgJnBsbF9jbG9jaywgJmZiX2RpdiwgJmZyYWNfZmJfZGl2LAogCQkJCQkg
ICZyZWZfZGl2LCAmcG9zdF9kaXYpOwotCWVsc2UgaWYgKEFTSUNfSVNfQVZJVk8ocmRldikpCisJ
CWJyZWFrOworCWNhc2UgUkFERU9OX1BMTF9BTEdPX0FWSVZPOgogCQlyYWRlb25fY29tcHV0ZV9w
bGxfYXZpdm8ocGxsLCBhZGp1c3RlZF9jbG9jaywgJnBsbF9jbG9jaywgJmZiX2RpdiwgJmZyYWNf
ZmJfZGl2LAogCQkJCQkgJnJlZl9kaXYsICZwb3N0X2Rpdik7Ci0JZWxzZQotCQlyYWRlb25fY29t
cHV0ZV9wbGxfbGVnYWN5KHBsbCwgYWRqdXN0ZWRfY2xvY2ssICZwbGxfY2xvY2ssICZmYl9kaXYs
ICZmcmFjX2ZiX2RpdiwKLQkJCQkJICAmcmVmX2RpdiwgJnBvc3RfZGl2KTsKKwkJYnJlYWs7CisJ
fTsKIAogCWF0b21iaW9zX2NydGNfcHJvZ3JhbV9zcyhjcnRjLCBBVE9NX0RJU0FCTEUsIHJhZGVv
bl9jcnRjLT5wbGxfaWQsICZzcyk7CiAKLS0gCjEuNy4xLjEKCg==
--0015174796485595bd049bcbebcb--
