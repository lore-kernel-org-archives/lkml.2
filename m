Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556Ab1JaPyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:54:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49595 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab1JaPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:54:21 -0400
MIME-Version: 1.0
In-Reply-To: <1320049150.8283.19.camel@dabdike>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <1320049150.8283.19.camel@dabdike>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 08:53:59 -0700
X-Google-Sender-Auth: IMJ3a0cCQBPrDhU0LbvLXIsCxuw
Message-ID: <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Junio C Hamano <gitster@pobox.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e64403247c626804b09a4038
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64403247c626804b09a4038
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 31, 2011 at 1:19 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
>> That said, even the "BEGIN PGP SIGNED MESSAGE" things are a massive
>> pain in the butt. We need to automate this some sane way, both for the
>> sender and for the recipient.
>
> But this doesn't help with what practise you want us to follow. =A0Do you
> want us to send full signed email using pgp encapsulation for pull
> requests in spite of the mangling it does to attached patches and the
> amount of extra pain it causes you?

No. I don't want the *whole* email signed, because that is quite
inconvenient: it means that I can't just cut-and-paste some signature,
I have to save the email and verify it etc etc.

So my preferred thing would literally be to make the signed part as
small as possible with no odd characters or whitespace (top commit and
probably repository name), so that I can cut-and-paste it and just
have a terminal window open with "gpg --verify + paste + ^D" and I'm
done.

For the people who use "git request-pull", I'm attaching a trivial
patch to make it add this kind of signature if you give it the "-s"
flag. It basically just adds a hunk like the appended crazy example to
the pull request, and it's small enough and simple enough that it
makes verification simple too with just the above kind of trivial
cut-and-paste thing.

(Junio cc'd, I think he had something more complicated in mind)

Now, admittedly it would be *even nicer* if this gpg-signed block was
instead uploaded as a signed tag automatically, and "git pull" would
notice such a signed tag (tagname the same as the branch name + date
or something) and would download and verify the tag as I pull. Then I
wouldn't even need to actually do the cut-and-paste at all. But this
is the *really* simple approach that gets up 95% of the way there.

And the attached patch is so trivial that if you aren't actually using
"git request-pull" but instead have some home-cooked script to do the
same, then you can just look at this patch and trivially change your
script to do something very similar.

                 Linus

[ Example gpg-signed small block that the attached patch adds to the
pull request: ]

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Commit be3fa9125e708348c7baf04ebe9507a72a9d1800
from git.kernel.org/pub/git
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJOrsILAAoJEHm+PkMAQRiGxZcH/31e0RrBitXUPKxHJajD58yh
SIEe/7i6E2RUSFva3KybEuFslcR8p8DYzDQTPLejStvnkO8v0lXu9s9R53tvjLMF
aaQXLOgrOC2RqvzP4F27O972h32YpLBkwIdWQGAhYcUOdKYDZ9RfgEgtdJwSYuL+
oJ7TjLrtkcILaFmr9nYZC+0Fh7z+84R8kR53v0iBHJQOFfssuMjUWCoj9aEY12t+
pywXuVk2FsuYvhniCAcyU6Y1K9aXaf6w5iOY2hx/ysXtUBnv92F7lcathxQkvgjO
fA7/TXEcummOv5KQFc9vckd5Z1gN2ync5jhfnmlT2uiobE6mNdCbOVlCOpsKQkU=3D
=3Dl5PG
-----END PGP SIGNATURE-----

--0016e64403247c626804b09a4038
Content-Type: text/x-patch; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gufndvf30

IGdpdC1yZXF1ZXN0LXB1bGwuc2ggfCAgICA5ICsrKysrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA5
IGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZ2l0LXJlcXVlc3Qt
cHVsbC5zaCBiL2dpdC1yZXF1ZXN0LXB1bGwuc2gKaW5kZXggZmMwODBjYzVlNDVkLi4yMmI1MTkz
MDk1OWYgMTAwNzU1Ci0tLSBhL2dpdC1yZXF1ZXN0LXB1bGwuc2gKKysrIGIvZ2l0LXJlcXVlc3Qt
cHVsbC5zaApAQCAtMjAsMTEgKzIwLDE0IEBAIEdJVF9QQUdFUj0KIGV4cG9ydCBHSVRfUEFHRVIK
IAogcGF0Y2g9CitzaWduPQogd2hpbGUJY2FzZSAiJCMiIGluIDApIGJyZWFrIDs7IGVzYWMKIGRv
CiAJY2FzZSAiJDEiIGluCiAJLXApCiAJCXBhdGNoPS1wIDs7CisJLXMpCisJCXNpZ249LXMgOzsK
IAktLSkKIAkJc2hpZnQ7IGJyZWFrIDs7CiAJLSopCkBAIC03Myw2ICs3NiwxMiBAQCBhcmUgYXZh
aWxhYmxlIGluIHRoZSBnaXQgcmVwb3NpdG9yeSBhdDonICRiYXNlcmV2ICYmCiBlY2hvICIgICR1
cmwgJGJyYW5jaCIgJiYKIGVjaG8gJiYKIAoraWYgdGVzdCAtbiAiJHNpZ24iCit0aGVuCisJcHJp
bnRmICJDb21taXQgJGhlYWRyZXZcbmZyb20gJHVybFxuIiB8IGdwZyAtLWNsZWFyc2lnbgorCWVj
aG8KK2ZpICYmCisKIGdpdCBzaG9ydGxvZyBeJGJhc2VyZXYgJGhlYWRyZXYgJiYKIGdpdCBkaWZm
IC1NIC0tc3RhdCAtLXN1bW1hcnkgJHBhdGNoICRtZXJnZV9iYXNlLi4kaGVhZHJldiB8fCBleGl0
CiBleGl0ICRzdGF0dXMK
--0016e64403247c626804b09a4038--
