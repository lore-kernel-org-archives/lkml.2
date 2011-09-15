Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934448Ab1IOTES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:04:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46261 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab1IOTER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:04:17 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxcibMZbEpJzP-LfV1aYFM-n9ctEqNMZ_k4XJxoZPfbrg@mail.gmail.com>
References: <web-606439650@zbackend1.aha.ru> <CA+55aFwyC7s=YK10Wkpr+GzdukXp-JUtf_=MgWcrhBOtTg4eTg@mail.gmail.com>
 <web-606798161@zbackend1.aha.ru> <CA+55aFwBuySWa2VErrfud_SFqyfT5ib+Qfq9gWBaBz=cQ6VcHg@mail.gmail.com>
 <web-606831561@zbackend1.aha.ru> <CAObL_7F2Pu0K1Oe3oLe5Pef2kaGE8vdO2qgfc0KEt8TJdUaOWg@mail.gmail.com>
 <CAObL_7E0iyinOyXU=uQHyQN+TBNmVVB89r_hQUb8LTqJ2ix_5A@mail.gmail.com>
 <CA+55aFzay+U5JA0Q6vdjmV73yG0OUXnO_zi6Q0c6iTkmozSSiw@mail.gmail.com>
 <web-607296211@zbackend1.aha.ru> <CAObL_7HAxg0j3ywpTy1-5Y5vBBQLSTiF7AZ0bctRsPOLKA8ZNA@mail.gmail.com>
 <CA+55aFwEKNEN8QPpBhAkDQ4UGFtSDtpdwFRSkTvnhaYRTmrsOA@mail.gmail.com>
 <CAObL_7Gjk91MFSwbaMnfdxwrM0mDGxWtDBaKMoimg2FSUqjAUg@mail.gmail.com>
 <CA+55aFxmW7rFEpanD-ngB-Egx5j1q8b_u31Keo3+s-TJ13UZGA@mail.gmail.com> <CA+55aFxcibMZbEpJzP-LfV1aYFM-n9ctEqNMZ_k4XJxoZPfbrg@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 15 Sep 2011 11:56:35 -0700
X-Google-Sender-Auth: LQh93SprC3kRAvwtRvCb_KJUMlc
Message-ID: <CAObL_7FpzpEcW=Q5Ch0YF3qQC4MTNJ-fOnZJVLRdTwGthJTcPg@mail.gmail.com>
Subject: Re: 3.1-rc6 boot problem reason searching
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        werner <w.landgraf@ru.ru>
Content-Type: multipart/mixed; boundary=e89a8f5037a2bfa9db04acff70d3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e89a8f5037a2bfa9db04acff70d3
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Sep 15, 2011 at 11:23 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Sep 15, 2011 at 11:15 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> It *used* to have an alignment of 8 back before your patch to make the
>> pointers be relative due to the 64-bit pointers. But now all fields
>> are 32-bit, and it could easily have a size of just 12 bytes, getting
>> rid of the 'pad2' field, and getting rid of the '.balign 8's.
>
> IOW, maybe the correct patch is just the attached one.
>
> Werner, does this fix the boot for you? It gets rid of all the bogus
> alignment stuff, it's all wrong anyway, the altinstructions section
> entries are all 12 bytes long so it starts out sufficiently aligned,
> and it *stays* aligned because if anybody ever adds a non-12-byte
> entry that would be a huge bug regardless. So any extra alignment is
> just likely to be buggy and hide much bigger issues.
>
> This is COMPLETELY UNTESTED, just looking at the source.

If you want to apply it this late, fine with me.  It looks generally
sane, but I haven't tested it.

OTOH, I have tested the attached minimal patch on 32-bit and 64-bit.

--Andy

--e89a8f5037a2bfa9db04acff70d3
Content-Type: text/x-patch; charset=US-ASCII; name="my_patch.diff"
Content-Disposition: attachment; filename="my_patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gsm3op5o1

Y29tbWl0IGI1NjRhNmFhZGI3NGQ3MjdjNjllYzQ3YTQwZGNjODFmMTc2OTkyMTQKQXV0aG9yOiBB
bmR5IEx1dG9taXJza2kgPGx1dG9AbWl0LmVkdT4KRGF0ZTogICBUaHUgU2VwIDE1IDEwOjUyOjA1
IDIwMTEgLTA3MDAKCiAgICB4ODY6IEZpeCBhbHRpbnN0cnVjdGlvbl9lbnRyeSBhbGlnbm1lbnQg
b24gMzItYml0IGJ1aWxkcwogICAgCiAgICBUaGUgYWxpZ25tZW50IHNob3VsZCBiZSA0IG9uIDMy
IGJpdCBidWlsZHMgYW5kIDggb24gNjQtYml0IGJ1aWxkcy4KICAgIFRoaXMgZml4ZXMgYSBmYWls
dXJlIHRvIGJvb3Qgb24gc29tZSBjb25maWd1cmF0aW9ucy4KICAgIAogICAgU2lnbmVkLW9mZi1i
eTogQW5keSBMdXRvbWlyc2tpIDxsdXRvQG1pdC5lZHU+CgpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
aW5jbHVkZS9hc20vYWx0ZXJuYXRpdmUtYXNtLmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9hbHRl
cm5hdGl2ZS1hc20uaAppbmRleCA0NTU0Y2M2Li5kMDBkYzJhIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS9hbHRlcm5hdGl2ZS1hc20uaAorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9hbHRlcm5hdGl2ZS1hc20uaApAQCAtMTYsNyArMTYsNyBAQAogI2VuZGlmCiAKIC5tYWNybyBh
bHRpbnN0cnVjdGlvbl9lbnRyeSBvcmlnIGFsdCBmZWF0dXJlIG9yaWdfbGVuIGFsdF9sZW4KLQku
YWxpZ24gOAorCV9BU01fQUxJR04KIAkubG9uZyBcb3JpZyAtIC4KIAkubG9uZyBcYWx0IC0gLgog
CS53b3JkIFxmZWF0dXJlCg==
--e89a8f5037a2bfa9db04acff70d3--
