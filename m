Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab2AJQtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 11:49:40 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62306 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2AJQtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 11:49:39 -0500
MIME-Version: 1.0
In-Reply-To: <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1326171444.6638.3.camel@edumazet-laptop> <1326171798.6638.4.camel@edumazet-laptop>
 <1326183371.6638.6.camel@edumazet-laptop> <1326212033.19095.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFwNVutn=Z8N9k3CHLri=EKWX2UcN8skZvMfJ9Tg1LHCpg@mail.gmail.com> <1326213442.19095.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 10 Jan 2012 08:49:16 -0800
X-Google-Sender-Auth: OXlnp5pDuf0-NfcfS6-AhrZtml8
Message-ID: <CA+55aFyyZUJHELdbKfk2Gzpx9np7Ov74idttCo6+wi2+MAVG=g@mail.gmail.com>
Subject: Re: [BUG] kernel freezes with latest tree
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=f46d043893c5fd246504b62f4cca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d043893c5fd246504b62f4cca
Content-Type: text/plain; charset=ISO-8859-1

On Tue, Jan 10, 2012 at 8:37 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> Just to make sure I understood well, here is what I tested :

Yup, that was it.

That was the obvious thing about the merge to check.

I suspect that what remains is now the sparse cleanups and
usecs_to_cputime64() interaction. I note that you are running on a
32-bit setup, which is where such problems would show up (because any
new casts to "unsigned long" due to the forced sparse casting would
now actually truncate a 64-bit value down.

Just to test that theory, can you try this attached patch that simply
removes the casts? That's what we used to have before adding the
stricter type-checking (other things changed too, so this may not make
any difference, but this is a "test a small change to *maybe* narrow
things down")

Martin - mind re-running sparse on the 32-bit case to see if that
shows some messed-up case?

                   Linus

--f46d043893c5fd246504b62f4cca
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx95kbff0

IGluY2x1ZGUvYXNtLWdlbmVyaWMvY3B1dGltZS5oIHwgICAgOCArKysrLS0tLQogMSBmaWxlcyBj
aGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9hc20tZ2VuZXJpYy9jcHV0aW1lLmggYi9pbmNsdWRlL2FzbS1nZW5lcmljL2NwdXRpbWUu
aAppbmRleCA5YTYyOTM3YzU2Y2EuLmFhOGJiNzA4MDg1YiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9h
c20tZ2VuZXJpYy9jcHV0aW1lLmgKKysrIGIvaW5jbHVkZS9hc20tZ2VuZXJpYy9jcHV0aW1lLmgK
QEAgLTcsMTQgKzcsMTQgQEAKIHR5cGVkZWYgdW5zaWduZWQgbG9uZyBfX25vY2FzdCBjcHV0aW1l
X3Q7CiAKICNkZWZpbmUgY3B1dGltZV9vbmVfamlmZnkJCWppZmZpZXNfdG9fY3B1dGltZSgxKQot
I2RlZmluZSBjcHV0aW1lX3RvX2ppZmZpZXMoX19jdCkJKF9fZm9yY2UgdW5zaWduZWQgbG9uZyko
X19jdCkKKyNkZWZpbmUgY3B1dGltZV90b19qaWZmaWVzKF9fY3QpCShfX2N0KQogI2RlZmluZSBj
cHV0aW1lX3RvX3NjYWxlZChfX2N0KQkJKF9fY3QpCi0jZGVmaW5lIGppZmZpZXNfdG9fY3B1dGlt
ZShfX2h6KQkoX19mb3JjZSBjcHV0aW1lX3QpKF9faHopCisjZGVmaW5lIGppZmZpZXNfdG9fY3B1
dGltZShfX2h6KQkoX19oeikKIAogdHlwZWRlZiB1NjQgX19ub2Nhc3QgY3B1dGltZTY0X3Q7CiAK
LSNkZWZpbmUgY3B1dGltZTY0X3RvX2ppZmZpZXM2NChfX2N0KQkoX19mb3JjZSB1NjQpKF9fY3Qp
Ci0jZGVmaW5lIGppZmZpZXM2NF90b19jcHV0aW1lNjQoX19qaWYpCShfX2ZvcmNlIGNwdXRpbWU2
NF90KShfX2ppZikKKyNkZWZpbmUgY3B1dGltZTY0X3RvX2ppZmZpZXM2NChfX2N0KQkoX19jdCkK
KyNkZWZpbmUgamlmZmllczY0X3RvX2NwdXRpbWU2NChfX2ppZikJKF9famlmKQogCiAjZGVmaW5l
IG5zZWNzX3RvX2NwdXRpbWU2NChfX2N0KQlcCiAJamlmZmllczY0X3RvX2NwdXRpbWU2NChuc2Vj
c190b19qaWZmaWVzNjQoX19jdCkpCg==
--f46d043893c5fd246504b62f4cca--
