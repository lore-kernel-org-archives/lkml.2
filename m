Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2FDR7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 13:59:51 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:32937 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2FDR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 13:59:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120604151407.GD23701@moon>
References: <20120604151407.GD23701@moon>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 4 Jun 2012 10:59:24 -0700
X-Google-Sender-Auth: fkwUXOdenwJJSAfURjp0hZX_u50
Message-ID: <CA+55aFwWpxvPGT2Gopp=y8_=CAsGoted4sg9_+b8yfkEqjLBYw@mail.gmail.com>
Subject: Re: Probleam reading fdinfo symlinks after 30a08bf2d31d275c6fc71dd1811342777e95c831
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>
Content-Type: multipart/mixed; boundary=0016e6d6463d9e39f504c1a94c20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d6463d9e39f504c1a94c20
Content-Type: text/plain; charset=ISO-8859-1

On Mon, Jun 4, 2012 at 8:14 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>
> just tried 3.5-rc1 out and found that with commit
> 30a08bf2d31d275c6fc71dd1811342777e95c831 the reading
> of fdinfo files returns "Too many levels of symbolic links"
> error.

Ugh. The fdinfo files aren't symlinks at all, and share the revalidate function.

My bad. The fix isn't pretty, but still better than reverting things.
This should fix it.

            Linus

--0016e6d6463d9e39f504c1a94c20
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h31ugeoj0

IGZzL3Byb2MvYmFzZS5jIHwgMTcgKysrKysrKysrKy0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAx
MCBpbnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3Byb2MvYmFz
ZS5jIGIvZnMvcHJvYy9iYXNlLmMKaW5kZXggNjE2ZjQxYTdjZGU2Li40MzcxOTVmMjA0ZTEgMTAw
NjQ0Ci0tLSBhL2ZzL3Byb2MvYmFzZS5jCisrKyBiL2ZzL3Byb2MvYmFzZS5jCkBAIC0xODAzLDcg
KzE4MDMsNyBAQCBzdGF0aWMgaW50IHRpZF9mZF9yZXZhbGlkYXRlKHN0cnVjdCBkZW50cnkgKmRl
bnRyeSwgc3RydWN0IG5hbWVpZGF0YSAqbmQpCiAJCQlyY3VfcmVhZF9sb2NrKCk7CiAJCQlmaWxl
ID0gZmNoZWNrX2ZpbGVzKGZpbGVzLCBmZCk7CiAJCQlpZiAoZmlsZSkgewotCQkJCXVuc2lnbmVk
IGlfbW9kZSwgZl9tb2RlID0gZmlsZS0+Zl9tb2RlOworCQkJCXVuc2lnbmVkIGZfbW9kZSA9IGZp
bGUtPmZfbW9kZTsKIAogCQkJCXJjdV9yZWFkX3VubG9jaygpOwogCQkJCXB1dF9maWxlc19zdHJ1
Y3QoZmlsZXMpOwpAQCAtMTgxOSwxMiArMTgxOSwxNCBAQCBzdGF0aWMgaW50IHRpZF9mZF9yZXZh
bGlkYXRlKHN0cnVjdCBkZW50cnkgKmRlbnRyeSwgc3RydWN0IG5hbWVpZGF0YSAqbmQpCiAJCQkJ
CWlub2RlLT5pX2dpZCA9IEdMT0JBTF9ST09UX0dJRDsKIAkJCQl9CiAKLQkJCQlpX21vZGUgPSBT
X0lGTE5LOwotCQkJCWlmIChmX21vZGUgJiBGTU9ERV9SRUFEKQotCQkJCQlpX21vZGUgfD0gU19J
UlVTUiB8IFNfSVhVU1I7Ci0JCQkJaWYgKGZfbW9kZSAmIEZNT0RFX1dSSVRFKQotCQkJCQlpX21v
ZGUgfD0gU19JV1VTUiB8IFNfSVhVU1I7Ci0JCQkJaW5vZGUtPmlfbW9kZSA9IGlfbW9kZTsKKwkJ
CQlpZiAoU19JU0xOSyhpbm9kZS0+aV9tb2RlKSkgeworCQkJCQl1bnNpZ25lZCBpX21vZGUgPSBT
X0lGTE5LOworCQkJCQlpZiAoZl9tb2RlICYgRk1PREVfUkVBRCkKKwkJCQkJCWlfbW9kZSB8PSBT
X0lSVVNSIHwgU19JWFVTUjsKKwkJCQkJaWYgKGZfbW9kZSAmIEZNT0RFX1dSSVRFKQorCQkJCQkJ
aV9tb2RlIHw9IFNfSVdVU1IgfCBTX0lYVVNSOworCQkJCQlpbm9kZS0+aV9tb2RlID0gaV9tb2Rl
OworCQkJCX0KIAogCQkJCXNlY3VyaXR5X3Rhc2tfdG9faW5vZGUodGFzaywgaW5vZGUpOwogCQkJ
CXB1dF90YXNrX3N0cnVjdCh0YXNrKTsKQEAgLTE4NTksNiArMTg2MSw3IEBAIHN0YXRpYyBzdHJ1
Y3QgZGVudHJ5ICpwcm9jX2ZkX2luc3RhbnRpYXRlKHN0cnVjdCBpbm9kZSAqZGlyLAogCWVpID0g
UFJPQ19JKGlub2RlKTsKIAllaS0+ZmQgPSBmZDsKIAorCWlub2RlLT5pX21vZGUgPSBTX0lGTE5L
OwogCWlub2RlLT5pX29wID0gJnByb2NfcGlkX2xpbmtfaW5vZGVfb3BlcmF0aW9uczsKIAlpbm9k
ZS0+aV9zaXplID0gNjQ7CiAJZWktPm9wLnByb2NfZ2V0X2xpbmsgPSBwcm9jX2ZkX2xpbms7Cg==
--0016e6d6463d9e39f504c1a94c20--
