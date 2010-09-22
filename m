Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0IVO7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:59:15 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65491 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab0IVO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:59:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=SW7UH4JPLsm2UfIr0n35lYgRyH+8lTXHQDy7gKBxq2+JTFDWq5shhviA4zfIKqBnkB
         5AJaqlXnKtrwkDeE7IKKeLIdTb57nynGWhTRTRiqf5KPQR6hRf65MZ1T8zOXm4RK+bGk
         leQlm0RlGOPt4s2JC5Il+8EoeZ3Gl9u3excq0=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 15:59:13 +0100
Message-ID: <AANLkTinwXj92VLVYqDhvUAusY_MdBQPAYnGBKVgfNLrO@mail.gmail.com>
Subject: [PATCH] kconfig: Use PATH_MAX instead of 128 for path buffer sizes.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: multipart/mixed; boundary=0016e64af9f27c68020490da6342
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64af9f27c68020490da6342
Content-Type: text/plain; charset=ISO-8859-1

This prevents the buffers being overflowed when using a config
file with a long name. PATH_MAX is used elsewhere in the same
file, so use it here as well.

Signed-off-by: Will Newton <will.newton@imgtec.com>
---
 scripts/kconfig/confdata.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 515253f..9e2dda2 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -541,7 +541,7 @@ int conf_write(const char *name)
 	struct menu *menu;
 	const char *basename;
 	const char *str;
-	char dirname[128], tmpname[128], newname[128];
+	char dirname[PATH_MAX+1], tmpname[PATH_MAX+1], newname[PATH_MAX+1];
 	enum symbol_type type;
 	time_t now;
 	int use_timestamp = 1;
@@ -662,7 +662,7 @@ next:
 static int conf_split_config(void)
 {
 	const char *name;
-	char path[128];
+	char path[PATH_MAX+1];
 	char *s, *d, c;
 	struct symbol *sym;
 	struct stat sb;
-- 
1.7.2.2

--0016e64af9f27c68020490da6342
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-kconfig-Use-PATH_MAX-instead-of-128-for-path-buffer-.patch"
Content-Disposition: attachment; 
	filename="0001-kconfig-Use-PATH_MAX-instead-of-128-for-path-buffer-.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_geebivw70

RnJvbSA1NmJhODQ5ZTE4ODA1MTU4Y2ExMGNhMWIyOGRiMDUwNGYyNGQ5NTYzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogV2VkLCAyMiBTZXAgMjAxMCAxNTo0OToyMiArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIGtj
b25maWc6IFVzZSBQQVRIX01BWCBpbnN0ZWFkIG9mIDEyOCBmb3IgcGF0aCBidWZmZXIgc2l6ZXMu
CgpUaGlzIHByZXZlbnRzIHRoZSBidWZmZXJzIGJlaW5nIG92ZXJmbG93ZWQgd2hlbiB1c2luZyBh
IGNvbmZpZwpmaWxlIHdpdGggYSBsb25nIG5hbWUuIFBBVEhfTUFYIGlzIHVzZWQgZWxzZXdoZXJl
IGluIHRoZSBzYW1lCmZpbGUsIHNvIHVzZSBpdCBoZXJlIGFzIHdlbGwuCgpTaWduZWQtb2ZmLWJ5
OiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4KLS0tCiBzY3JpcHRzL2tjb25m
aWcvY29uZmRhdGEuYyB8ICAgIDQgKystLQogMSBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc2NyaXB0cy9rY29uZmlnL2NvbmZkYXRh
LmMgYi9zY3JpcHRzL2tjb25maWcvY29uZmRhdGEuYwppbmRleCA1MTUyNTNmLi45ZTJkZGEyIDEw
MDY0NAotLS0gYS9zY3JpcHRzL2tjb25maWcvY29uZmRhdGEuYworKysgYi9zY3JpcHRzL2tjb25m
aWcvY29uZmRhdGEuYwpAQCAtNTQxLDcgKzU0MSw3IEBAIGludCBjb25mX3dyaXRlKGNvbnN0IGNo
YXIgKm5hbWUpCiAJc3RydWN0IG1lbnUgKm1lbnU7CiAJY29uc3QgY2hhciAqYmFzZW5hbWU7CiAJ
Y29uc3QgY2hhciAqc3RyOwotCWNoYXIgZGlybmFtZVsxMjhdLCB0bXBuYW1lWzEyOF0sIG5ld25h
bWVbMTI4XTsKKwljaGFyIGRpcm5hbWVbUEFUSF9NQVgrMV0sIHRtcG5hbWVbUEFUSF9NQVgrMV0s
IG5ld25hbWVbUEFUSF9NQVgrMV07CiAJZW51bSBzeW1ib2xfdHlwZSB0eXBlOwogCXRpbWVfdCBu
b3c7CiAJaW50IHVzZV90aW1lc3RhbXAgPSAxOwpAQCAtNjYyLDcgKzY2Miw3IEBAIG5leHQ6CiBz
dGF0aWMgaW50IGNvbmZfc3BsaXRfY29uZmlnKHZvaWQpCiB7CiAJY29uc3QgY2hhciAqbmFtZTsK
LQljaGFyIHBhdGhbMTI4XTsKKwljaGFyIHBhdGhbUEFUSF9NQVgrMV07CiAJY2hhciAqcywgKmQs
IGM7CiAJc3RydWN0IHN5bWJvbCAqc3ltOwogCXN0cnVjdCBzdGF0IHNiOwotLSAKMS43LjIuMgoK
--0016e64af9f27c68020490da6342--
