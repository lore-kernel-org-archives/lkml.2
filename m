Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761Ab2J3OvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:51:21 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:58522 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2J3OvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:51:20 -0400
MIME-Version: 1.0
Date: Tue, 30 Oct 2012 14:51:18 +0000
Message-ID: <CAFbHwiRtBaHkpZqTm6VZ=fCJcyu+dsdpo_kxMHy1egce=rTuyA@mail.gmail.com>
Subject: [PATCH] scripts/recordmcount.pl: Support build with -ffunction-sections.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Content-Type: multipart/mixed; boundary=bcaec550ac562ab50404cd47eb51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bcaec550ac562ab50404cd47eb51
Content-Type: text/plain; charset=ISO-8859-1

Scan any text section whose name begins with ".text." so
we will find all the functions in a kernel built with
-ffunction-sections.

Signed-off-by: Will Newton <will.newton@imgtec.com>
---
 scripts/recordmcount.pl |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index b33446c..89461c4 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -135,9 +135,13 @@ my %text_sections = (
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
      ".kprobes.text" => 1,
-     ".text.unlikely" => 1,
 );

+sub is_valid_section
+{
+    return defined($text_sections{$1}) || $1 =~ m/^\.text\./;
+}
+
 # Note: we are nice to C-programmers here, thus we skip the '||='-idiom.
 $objdump = 'objdump' if (!$objdump);
 $objcopy = 'objcopy' if (!$objcopy);
@@ -502,7 +506,7 @@ while (<IN>) {
 	$read_headers = 0;

 	# Only record text sections that we know are safe
-	$read_function = defined($text_sections{$1});
+	$read_function = is_valid_section($1);
 	# print out any recorded offsets
 	update_funcs();

-- 
1.7.1

--bcaec550ac562ab50404cd47eb51
Content-Type: application/octet-stream; 
	name="0001-scripts-recordmcount.pl-Support-build-with-ffunction.patch"
Content-Disposition: attachment; 
	filename="0001-scripts-recordmcount.pl-Support-build-with-ffunction.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h8x4qpws0

RnJvbSBmNTZhMzI4OGE5YmJkYThhZjM3MmFmMWQzMzgzZDI0MGNiMGQ3ZmEzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogVGh1LCAxOCBPY3QgMjAxMiAxMTo1NDoxMCArMDEwMApTdWJqZWN0OiBbUEFUQ0hdIHNj
cmlwdHMvcmVjb3JkbWNvdW50LnBsOiBTdXBwb3J0IGJ1aWxkIHdpdGggLWZmdW5jdGlvbi1zZWN0
aW9ucy4KClNjYW4gYW55IHRleHQgc2VjdGlvbiB3aG9zZSBuYW1lIGJlZ2lucyB3aXRoICIudGV4
dC4iIHNvCndlIHdpbGwgZmluZCBhbGwgdGhlIGZ1bmN0aW9ucyBpbiBhIGtlcm5lbCBidWlsdCB3
aXRoCi1mZnVuY3Rpb24tc2VjdGlvbnMuCgpTaWduZWQtb2ZmLWJ5OiBXaWxsIE5ld3RvbiA8d2ls
bC5uZXd0b25AaW1ndGVjLmNvbT4KLS0tCiBzY3JpcHRzL3JlY29yZG1jb3VudC5wbCB8ICAgIDgg
KysrKysrLS0KIDEgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMvcmVjb3JkbWNvdW50LnBsIGIvc2NyaXB0cy9yZWNvcmRt
Y291bnQucGwKaW5kZXggYjMzNDQ2Yy4uODk0NjFjNCAxMDA3NTUKLS0tIGEvc2NyaXB0cy9yZWNv
cmRtY291bnQucGwKKysrIGIvc2NyaXB0cy9yZWNvcmRtY291bnQucGwKQEAgLTEzNSw5ICsxMzUs
MTMgQEAgbXkgJXRleHRfc2VjdGlvbnMgPSAoCiAgICAgICIuc3BpbmxvY2sudGV4dCIgPT4gMSwK
ICAgICAgIi5pcnFlbnRyeS50ZXh0IiA9PiAxLAogICAgICAiLmtwcm9iZXMudGV4dCIgPT4gMSwK
LSAgICAgIi50ZXh0LnVubGlrZWx5IiA9PiAxLAogKTsKIAorc3ViIGlzX3ZhbGlkX3NlY3Rpb24K
K3sKKyAgICByZXR1cm4gZGVmaW5lZCgkdGV4dF9zZWN0aW9uc3skMX0pIHx8ICQxID1+IG0vXlwu
dGV4dFwuLzsKK30KKwogIyBOb3RlOiB3ZSBhcmUgbmljZSB0byBDLXByb2dyYW1tZXJzIGhlcmUs
IHRodXMgd2Ugc2tpcCB0aGUgJ3x8PSctaWRpb20uCiAkb2JqZHVtcCA9ICdvYmpkdW1wJyBpZiAo
ISRvYmpkdW1wKTsKICRvYmpjb3B5ID0gJ29iamNvcHknIGlmICghJG9iamNvcHkpOwpAQCAtNTAy
LDcgKzUwNiw3IEBAIHdoaWxlICg8SU4+KSB7CiAJJHJlYWRfaGVhZGVycyA9IDA7CiAKIAkjIE9u
bHkgcmVjb3JkIHRleHQgc2VjdGlvbnMgdGhhdCB3ZSBrbm93IGFyZSBzYWZlCi0JJHJlYWRfZnVu
Y3Rpb24gPSBkZWZpbmVkKCR0ZXh0X3NlY3Rpb25zeyQxfSk7CisJJHJlYWRfZnVuY3Rpb24gPSBp
c192YWxpZF9zZWN0aW9uKCQxKTsKIAkjIHByaW50IG91dCBhbnkgcmVjb3JkZWQgb2Zmc2V0cwog
CXVwZGF0ZV9mdW5jcygpOwogCi0tIAoxLjcuMQoK
--bcaec550ac562ab50404cd47eb51--
