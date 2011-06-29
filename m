Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1F2QXC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:23:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773Ab1F2QW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <4E0ADF27.5070805@akkadia.org>
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
 <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com> <4E0ADF27.5070805@akkadia.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Jun 2011 09:22:35 -0700
Message-ID: <BANLkTi=dQRi82gkDwtR3Kh2R7f0uGu7HpQ@mail.gmail.com>
Subject: Re: [PATCH] Add cloexec information to fdinfo
To: Ulrich Drepper <drepper@akkadia.org>
Cc: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Content-Type: multipart/mixed; boundary=0016e659f5a26146b604a6dc3267
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e659f5a26146b604a6dc3267
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 29, 2011 at 1:15 AM, Ulrich Drepper <drepper@akkadia.org> wrote=
:
>
> In this specific case I was trying to re-implement the pfiles program.
> For normal file descriptors (not sockets) this was the last piece of
> information which wasn't available. =A0This is all part of my "give
> Solaris users no reason to not switch" effort. =A0I intend to offer the
> code to the util-linux-ng maintainers.

Ok.

So the part I really dislike about the patch is how it makes O_CLOEXEC
so magically different from the other O_xyz flags.

Wouldn't it be much nicer to just show it in the "flags:" line?

Also, I don't think you need the rcu locking, since we hold the
files->file_lock here anyway.

>> Also, it's by no means the only thing not visible in /proc. Things
>> like file locking status, leases, file descriptor ownership, signal
>> number associated with the setown etc.
>
> True, and maybe that will be useful as well.
>
> I might actually have some more patches to get to socket information but
> I haven't fully checked out yet what is available.

So at least O_CLOEXEC seems to have a real reason, and fits the
existing model. I think a patch like the attached would be ok. Does
that work for you? It's entirely untested here.

                                Linus

--0016e659f5a26146b604a6dc3267
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gpihtdrr1

IGZzL3Byb2MvYmFzZS5jIHwgICAxMCArKysrKysrKystCiAxIGZpbGVzIGNoYW5nZWQsIDkgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9mcy9wcm9jL2Jhc2UuYyBi
L2ZzL3Byb2MvYmFzZS5jCmluZGV4IGZjNWJjMjc2NzY5Mi4uZTJhMDE2ZjI0ZDM4IDEwMDY0NAot
LS0gYS9mcy9wcm9jL2Jhc2UuYworKysgYi9mcy9wcm9jL2Jhc2UuYwpAQCAtMTkyMCw2ICsxOTIw
LDE0IEBAIHN0YXRpYyBpbnQgcHJvY19mZF9pbmZvKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0cnVj
dCBwYXRoICpwYXRoLCBjaGFyICppbmZvKQogCQlzcGluX2xvY2soJmZpbGVzLT5maWxlX2xvY2sp
OwogCQlmaWxlID0gZmNoZWNrX2ZpbGVzKGZpbGVzLCBmZCk7CiAJCWlmIChmaWxlKSB7CisJCQl1
bnNpZ25lZCBpbnQgZl9mbGFnczsKKwkJCXN0cnVjdCBmZHRhYmxlICpmZHQ7CisKKwkJCWZkdCA9
IGZpbGVzX2ZkdGFibGUoZmlsZXMpOworCQkJZl9mbGFncyA9IGZpbGUtPmZfZmxhZ3MgJiB+T19D
TE9FWEVDOworCQkJaWYgKEZEX0lTU0VUKGZkLCBmZHQtPmNsb3NlX29uX2V4ZWMpKQorCQkJCWZf
ZmxhZ3MgfD0gT19DTE9FWEVDOworCiAJCQlpZiAocGF0aCkgewogCQkJCSpwYXRoID0gZmlsZS0+
Zl9wYXRoOwogCQkJCXBhdGhfZ2V0KCZmaWxlLT5mX3BhdGgpOwpAQCAtMTkyOSw3ICsxOTM3LDcg
QEAgc3RhdGljIGludCBwcm9jX2ZkX2luZm8oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IHBh
dGggKnBhdGgsIGNoYXIgKmluZm8pCiAJCQkJCSAicG9zOlx0JWxsaVxuIgogCQkJCQkgImZsYWdz
Olx0MCVvXG4iLAogCQkJCQkgKGxvbmcgbG9uZykgZmlsZS0+Zl9wb3MsCi0JCQkJCSBmaWxlLT5m
X2ZsYWdzKTsKKwkJCQkJIGZfZmxhZ3MpOwogCQkJc3Bpbl91bmxvY2soJmZpbGVzLT5maWxlX2xv
Y2spOwogCQkJcHV0X2ZpbGVzX3N0cnVjdChmaWxlcyk7CiAJCQlyZXR1cm4gMDsK
--0016e659f5a26146b604a6dc3267--
