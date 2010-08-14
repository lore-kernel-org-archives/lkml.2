Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab0HNRPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 13:15:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757179Ab0HNRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 13:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com>
References: <AANLkTimNborh0AtHkdnN-aCizDu4+S6ORmeoKzS_nEVH@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Aug 2010 10:14:24 -0700
Message-ID: <AANLkTik0gSCA4YAH5VAfmW+a4d5R_nybgLiXa_koWn48@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
To: sedat.dilek@gmail.com
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        penberg@kernel.org, arthur@psw.ro
Content-Type: multipart/mixed; boundary=00504501477a55e8f9048dcbbc2a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00504501477a55e8f9048dcbbc2a
Content-Type: text/plain; charset=ISO-8859-1

On Sat, Aug 14, 2010 at 5:37 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>
> root@tbox:~# grep "Aug 14 13:00:5" /var/log/syslog
> Aug 14 13:00:53 tbox kernel: [ 1084.804086] BUG: scheduling while atomic: bash/3256/0x10000001

Gaah. Locking problem. We really should have let this one simmer in
-devel a bit longer before rushing it into -stable.

Attached potential patch. Untested, but I forgot about the locking in
the first version of the patch, and then the "trivial one-liner fix"
missed the deeper problem.

Greg - please don't use this patch yet. I'll test it. And wait for
verification that it fixes other peoblems too.

                    Linus

--00504501477a55e8f9048dcbbc2a
Content-Type: text/plain; charset=US-ASCII; name="diff.txt"
Content-Disposition: attachment; filename="diff.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcuq0yui0

IG1tL21lbW9yeS5jIHwgICAxMyArKysrKystLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9tbS9tZW1vcnkuYyBiL21t
L21lbW9yeS5jCmluZGV4IDliM2I3M2YuLmI2ZTVmZDIgMTAwNjQ0Ci0tLSBhL21tL21lbW9yeS5j
CisrKyBiL21tL21lbW9yeS5jCkBAIC0yNzkyLDI0ICsyNzkyLDIzIEBAIHN0YXRpYyBpbnQgZG9f
YW5vbnltb3VzX3BhZ2Uoc3RydWN0IG1tX3N0cnVjdCAqbW0sIHN0cnVjdCB2bV9hcmVhX3N0cnVj
dCAqdm1hLAogCXNwaW5sb2NrX3QgKnB0bDsKIAlwdGVfdCBlbnRyeTsKIAotCWlmIChjaGVja19z
dGFja19ndWFyZF9wYWdlKHZtYSwgYWRkcmVzcykgPCAwKSB7Ci0JCXB0ZV91bm1hcChwYWdlX3Rh
YmxlKTsKKwlwdGVfdW5tYXAocGFnZV90YWJsZSk7CisKKwkvKiBDaGVjayBpZiB3ZSBuZWVkIHRv
IGFkZCBhIGd1YXJkIHBhZ2UgdG8gdGhlIHN0YWNrICovCisJaWYgKGNoZWNrX3N0YWNrX2d1YXJk
X3BhZ2Uodm1hLCBhZGRyZXNzKSA8IDApCiAJCXJldHVybiBWTV9GQVVMVF9TSUdCVVM7Ci0JfQog
CisJLyogVXNlIHRoZSB6ZXJvLXBhZ2UgZm9yIHJlYWRzICovCiAJaWYgKCEoZmxhZ3MgJiBGQVVM
VF9GTEFHX1dSSVRFKSkgewogCQllbnRyeSA9IHB0ZV9ta3NwZWNpYWwocGZuX3B0ZShteV96ZXJv
X3BmbihhZGRyZXNzKSwKIAkJCQkJCXZtYS0+dm1fcGFnZV9wcm90KSk7Ci0JCXB0bCA9IHB0ZV9s
b2NrcHRyKG1tLCBwbWQpOwotCQlzcGluX2xvY2socHRsKTsKKwkJcGFnZV90YWJsZSA9IHB0ZV9v
ZmZzZXRfbWFwX2xvY2sobW0sIHBtZCwgYWRkcmVzcywgJnB0bCk7CiAJCWlmICghcHRlX25vbmUo
KnBhZ2VfdGFibGUpKQogCQkJZ290byB1bmxvY2s7CiAJCWdvdG8gc2V0cHRlOwogCX0KIAogCS8q
IEFsbG9jYXRlIG91ciBvd24gcHJpdmF0ZSBwYWdlLiAqLwotCXB0ZV91bm1hcChwYWdlX3RhYmxl
KTsKLQogCWlmICh1bmxpa2VseShhbm9uX3ZtYV9wcmVwYXJlKHZtYSkpKQogCQlnb3RvIG9vbTsK
IAlwYWdlID0gYWxsb2NfemVyb2VkX3VzZXJfaGlnaHBhZ2VfbW92YWJsZSh2bWEsIGFkZHJlc3Mp
Owo=
--00504501477a55e8f9048dcbbc2a--
