Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab2BIRI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:08:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51451 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab2BIRIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:08:25 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
 <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 09:08:05 -0800
X-Google-Sender-Auth: a20HpdjWKXgrD8JP3QvWFN0P1LE
Message-ID: <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com>
Subject: Re: [PATCH] Reduce the number of expensive division instructions done
 by _parse_integer()
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Howells <dhowells@redhat.com>, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=e89a8ff1cc1267d44f04b88b0fcf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8ff1cc1267d44f04b88b0fcf
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Feb 9, 2012 at 8:58 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So David's patch looks ok, although if this really is
> performance-critical (and I could imagine some crazy /proc or /sys
> access loads where the divide really does show up very clearly) I do
> think it could be even done more efficiently. But probably only if we
> start doing some arch-specific stuff.

Looking at the code generated, the "val >> 60" thing actually does
generate a shift, and at least on x86-64, the attached patch generates
better code.

David, does this work for you? I also removed the nasty pointer
indirection crap.

                        Linus

--e89a8ff1cc1267d44f04b88b0fcf
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gyg1jgpe0

IGxpYi9rc3RydG94LmMgfCAgIDE4ICsrKysrKysrKysrKystLS0tLQogMSBmaWxlcyBjaGFuZ2Vk
LCAxMyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2xpYi9rc3Ry
dG94LmMgYi9saWIva3N0cnRveC5jCmluZGV4IDdhOTRjOGYxNGUyOS4uYjFkZDNlN2Q4OGNiIDEw
MDY0NAotLS0gYS9saWIva3N0cnRveC5jCisrKyBiL2xpYi9rc3RydG94LmMKQEAgLTQ0LDEyICs0
NCwxMyBAQCBjb25zdCBjaGFyICpfcGFyc2VfaW50ZWdlcl9maXh1cF9yYWRpeChjb25zdCBjaGFy
ICpzLCB1bnNpZ25lZCBpbnQgKmJhc2UpCiAgKgogICogRG9uJ3QgeW91IGRhcmUgdXNlIHRoaXMg
ZnVuY3Rpb24uCiAgKi8KLXVuc2lnbmVkIGludCBfcGFyc2VfaW50ZWdlcihjb25zdCBjaGFyICpz
LCB1bnNpZ25lZCBpbnQgYmFzZSwgdW5zaWduZWQgbG9uZyBsb25nICpyZXMpCit1bnNpZ25lZCBp
bnQgX3BhcnNlX2ludGVnZXIoY29uc3QgY2hhciAqcywgdW5zaWduZWQgaW50IGJhc2UsIHVuc2ln
bmVkIGxvbmcgbG9uZyAqcCkKIHsKKwl1bnNpZ25lZCBsb25nIGxvbmcgcmVzOwogCXVuc2lnbmVk
IGludCBydjsKIAlpbnQgb3ZlcmZsb3c7CiAKLQkqcmVzID0gMDsKKwlyZXMgPSAwOwogCXJ2ID0g
MDsKIAlvdmVyZmxvdyA9IDA7CiAJd2hpbGUgKCpzKSB7CkBAIC02NCwxMiArNjUsMTkgQEAgdW5z
aWduZWQgaW50IF9wYXJzZV9pbnRlZ2VyKGNvbnN0IGNoYXIgKnMsIHVuc2lnbmVkIGludCBiYXNl
LCB1bnNpZ25lZCBsb25nIGxvbmcKIAogCQlpZiAodmFsID49IGJhc2UpCiAJCQlicmVhazsKLQkJ
aWYgKCpyZXMgPiBkaXZfdTY0KFVMTE9OR19NQVggLSB2YWwsIGJhc2UpKQotCQkJb3ZlcmZsb3cg
PSAxOwotCQkqcmVzID0gKnJlcyAqIGJhc2UgKyB2YWw7CisJCS8qCisJCSAqIENoZWNrIGZvciBv
dmVyZmxvdyBvbmx5IGlmIHdlIGFyZSB3aXRoaW4gcmFuZ2Ugb2YKKwkJICogaXQgaW4gdGhlIG1h
eCBiYXNlIHdlIHN1cHBvcnQgKDE2KQorCQkgKi8KKwkJaWYgKHVubGlrZWx5KHJlcyAmICh+MHVs
bCA8PCA2MCkpKSB7CisJCQlpZiAocmVzID4gZGl2X3U2NChVTExPTkdfTUFYIC0gdmFsLCBiYXNl
KSkKKwkJCQlvdmVyZmxvdyA9IDE7CisJCX0KKwkJcmVzID0gcmVzICogYmFzZSArIHZhbDsKIAkJ
cnYrKzsKIAkJcysrOwogCX0KKwkqcCA9IHJlczsKIAlpZiAob3ZlcmZsb3cpCiAJCXJ2IHw9IEtT
VFJUT1hfT1ZFUkZMT1c7CiAJcmV0dXJuIHJ2Owo=
--e89a8ff1cc1267d44f04b88b0fcf--
