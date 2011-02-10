Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1BJTRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:17:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40073 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756339Ab1BJTRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:17:23 -0500
MIME-Version: 1.0
In-Reply-To: <20110210144057.GA7193@mail.hallyn.com>
References: <20110210144057.GA7193@mail.hallyn.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Feb 2011 11:16:58 -0800
Message-ID: <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
Subject: Re: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now (v3)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Gergely Nagy <algernon@balabit.hu>, david@lang.hm,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
        Nick Bowler <nbowler@elliptictech.com>
Content-Type: multipart/mixed; boundary=90e6ba4fc4a2239bff049bf26e0c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--90e6ba4fc4a2239bff049bf26e0c
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Feb 10, 2011 at 6:40 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
>
> Please apply.

Hmm. So I detest the duplication and the ugly resulting code.  It was
a bit hard to follow before, now it's just nasty.

Why not make this all into some nicer helper functions instead -
something simple like the attached?

UNTESTED! I'm not going to apply it unless I get acks/tested-by's.

                                  Linus

--90e6ba4fc4a2239bff049bf26e0c
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gk01ugb20

IGtlcm5lbC9wcmludGsuYyB8ICAgNTQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDM1IGluc2VydGlvbnMoKyks
IDE5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2tlcm5lbC9wcmludGsuYyBiL2tlcm5lbC9w
cmludGsuYwppbmRleCAyZGRiZGM3Li5mNTEyMTRjIDEwMDY0NAotLS0gYS9rZXJuZWwvcHJpbnRr
LmMKKysrIGIva2VybmVsL3ByaW50ay5jCkBAIC0yNjIsMjUgKzI2Miw0NyBAQCBpbnQgZG1lc2df
cmVzdHJpY3QgPSAxOwogaW50IGRtZXNnX3Jlc3RyaWN0OwogI2VuZGlmCiAKK3N0YXRpYyBpbnQg
c3lzbG9nX2FjdGlvbl9yZXN0cmljdGVkKGludCB0eXBlKQoreworCWlmIChkbWVzZ19yZXN0cmlj
dCkKKwkJcmV0dXJuIDE7CisJLyogVW5sZXNzIHJlc3RyaWN0ZWQsIHdlIGFsbG93ICJyZWFkIGFs
bCIgYW5kICJnZXQgYnVmZmVyIHNpemUiIGZvciBldmVyeWJvZHkgKi8KKwlyZXR1cm4gdHlwZSAh
PSBTWVNMT0dfQUNUSU9OX1JFQURfQUxMICYmIHR5cGUgIT0gU1lTTE9HX0FDVElPTl9TSVpFX0JV
RkZFUjsKK30KKworc3RhdGljIGludCBjaGVja19zeXNsb2dfcGVybWlzc2lvbnMoaW50IHR5cGUs
IGJvb2wgZnJvbV9maWxlKQoreworCS8qCisJICogSWYgdGhpcyBpcyBmcm9tIC9wcm9jL2ttc2cg
YW5kIHdlJ3ZlIGFscmVhZHkgb3BlbmVkIGl0LCB0aGVuIHdlJ3ZlCisJICogYWxyZWFkeSB0aGUg
Y2FwYWJpbGl0aWVzIGNoZWNrcyBhdCBvcGVuIHRpbWUuCisJICovCisJaWYgKGZyb21fZmlsZSAm
JiB0eXBlICE9IFNZU0xPR19BQ1RJT05fT1BFTikKKwkJcmV0dXJuIDA7CisKKwlpZiAoc3lzbG9n
X2FjdGlvbl9yZXN0cmljdGVkKHR5cGUpKSB7CisJCWlmIChjYXBhYmxlKENBUF9TWVNMT0cpKQor
CQkJcmV0dXJuIDA7CisJCS8qIEZvciBoaXN0b3JpY2FsIHJlYXNvbnMsIGFjY2VwdCBDQVBfU1lT
X0FETUlOIHRvbywgd2l0aCBhIHdhcm5pbmcgKi8KKwkJaWYgKGNhcGFibGUoQ0FQX1NZU19BRE1J
TikpIHsKKwkJCVdBUk5fT05DRSgxLCAiQXR0ZW1wdCB0byBhY2Nlc3Mgc3lzbG9nIHdpdGggQ0FQ
X1NZU19BRE1JTiAiCisJCQkJICJidXQgbm8gQ0FQX1NZU0xPRyAoZGVwcmVjYXRlZCkuXG4iKTsK
KwkJCXJldHVybiAwOworCQl9CisJCXJldHVybiAtRVBFUk07CisJfQorCXJldHVybiAwOworfQor
CiBpbnQgZG9fc3lzbG9nKGludCB0eXBlLCBjaGFyIF9fdXNlciAqYnVmLCBpbnQgbGVuLCBib29s
IGZyb21fZmlsZSkKIHsKIAl1bnNpZ25lZCBpLCBqLCBsaW1pdCwgY291bnQ7CiAJaW50IGRvX2Ns
ZWFyID0gMDsKIAljaGFyIGM7Ci0JaW50IGVycm9yID0gMDsKKwlpbnQgZXJyb3I7CiAKLQkvKgot
CSAqIElmIHRoaXMgaXMgZnJvbSAvcHJvYy9rbXNnIHdlIG9ubHkgZG8gdGhlIGNhcGFiaWxpdGll
cyBjaGVja3MKLQkgKiBhdCBvcGVuIHRpbWUuCi0JICovCi0JaWYgKHR5cGUgPT0gU1lTTE9HX0FD
VElPTl9PUEVOIHx8ICFmcm9tX2ZpbGUpIHsKLQkJaWYgKGRtZXNnX3Jlc3RyaWN0ICYmICFjYXBh
YmxlKENBUF9TWVNMT0cpKQotCQkJZ290byB3YXJuOyAvKiBzd2l0Y2ggdG8gcmV0dXJuIC1FUEVS
TSBhZnRlciAyLjYuMzkgKi8KLQkJaWYgKCh0eXBlICE9IFNZU0xPR19BQ1RJT05fUkVBRF9BTEwg
JiYKLQkJICAgICB0eXBlICE9IFNZU0xPR19BQ1RJT05fU0laRV9CVUZGRVIpICYmCi0JCSAgICAh
Y2FwYWJsZShDQVBfU1lTTE9HKSkKLQkJCWdvdG8gd2FybjsgLyogc3dpdGNoIHRvIHJldHVybiAt
RVBFUk0gYWZ0ZXIgMi42LjM5ICovCi0JfQorCWVycm9yID0gY2hlY2tfc3lzbG9nX3Blcm1pc3Np
b25zKHR5cGUsIGZyb21fZmlsZSk7CisJaWYgKGVycm9yKQorCQlnb3RvIG91dDsKIAogCWVycm9y
ID0gc2VjdXJpdHlfc3lzbG9nKHR5cGUpOwogCWlmIChlcnJvcikKQEAgLTQyMywxMiArNDQ1LDYg
QEAgaW50IGRvX3N5c2xvZyhpbnQgdHlwZSwgY2hhciBfX3VzZXIgKmJ1ZiwgaW50IGxlbiwgYm9v
bCBmcm9tX2ZpbGUpCiAJfQogb3V0OgogCXJldHVybiBlcnJvcjsKLXdhcm46Ci0JLyogcmVtb3Zl
IGFmdGVyIDIuNi4zOSAqLwotCWlmIChjYXBhYmxlKENBUF9TWVNfQURNSU4pKQotCQlXQVJOX09O
Q0UoMSwgIkF0dGVtcHQgdG8gYWNjZXNzIHN5c2xvZyB3aXRoIENBUF9TWVNfQURNSU4gIgotCQkg
ICJidXQgbm8gQ0FQX1NZU0xPRyAoZGVwcmVjYXRlZCBhbmQgZGVuaWVkKS5cbiIpOwotCXJldHVy
biAtRVBFUk07CiB9CiAKIFNZU0NBTExfREVGSU5FMyhzeXNsb2csIGludCwgdHlwZSwgY2hhciBf
X3VzZXIgKiwgYnVmLCBpbnQsIGxlbikK
--90e6ba4fc4a2239bff049bf26e0c--
