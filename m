Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187Ab1GZEtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 00:49:14 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47964 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1GZEtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 00:49:09 -0400
MIME-Version: 1.0
Date: Tue, 26 Jul 2011 12:49:08 +0800
Message-ID: <CACVXFVOYYZt-XfbPx_dEOm9qOAuGqmviH4TdXxg6xTrrB8PaMQ@mail.gmail.com>
Subject: block: BUG: using smp_processor_id() in preemptible [00000000] code
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=20cf303b3cc1f51a0304a8f1a6b5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--20cf303b3cc1f51a0304a8f1a6b5
Content-Type: text/plain; charset=ISO-8859-1

Hi,

The bug is observed in -next-20110725, follows the stack trace[1], and
seems the attachment patch can fix the bug.



[1], stack trace

[   22.247222] BUG: using smp_processor_id() in preemptible [00000000]
code: kjournald/514
[   22.255737] caller is __make_request+0x1b8/0x308
[   22.260681] [<c0019f44>] (unwind_backtrace+0x0/0xe8) from
[<c024b4cc>] (debug_smp_processor_id+0xbc/0xf0)
[   22.270751] [<c024b4cc>] (debug_smp_processor_id+0xbc/0xf0) from
[<c0223d14>] (__make_request+0x1b8/0x308)
[   22.280944] [<c0223d14>] (__make_request+0x1b8/0x308) from
[<c02215ac>] (generic_make_request+0x4dc/0x558)
[   22.291107] [<c02215ac>] (generic_make_request+0x4dc/0x558) from
[<c022173c>] (submit_bio+0x114/0x138)
[   22.300903] [<c022173c>] (submit_bio+0x114/0x138) from [<c011f504>]
(submit_bh+0x148/0x16c)
[   22.309692] [<c011f504>] (submit_bh+0x148/0x16c) from [<c0121ed8>]
(__sync_dirty_buffer+0x88/0xd8)
[   22.319122] [<c0121ed8>] (__sync_dirty_buffer+0x88/0xd8) from
[<c01aff78>] (journal_commit_transaction+0x1198/0
x1688)
[   22.330322] [<c01aff78>] (journal_commit_transaction+0x1198/0x1688)
from [<c01b4034>] (kjournald+0xb4/0x224)
[   22.340667] [<c01b4034>] (kjournald+0xb4/0x224) from [<c0069ea0>]
(kthread+0x8c/0x94)
[   22.348937] [<c0069ea0>] (kthread+0x8c/0x94) from [<c00137f8>]
(kernel_thread_exit+0x0/0x8)


thanks,
-- 
Ming Lei

--20cf303b3cc1f51a0304a8f1a6b5
Content-Type: text/x-patch; charset=US-ASCII; name="fix_blk_bug_smp_processor_id.patch"
Content-Disposition: attachment; 
	filename="fix_blk_bug_smp_processor_id.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqkdxs830

ZGlmZiAtLWdpdCBhL2Jsb2NrL2Jsay1jb3JlLmMgYi9ibG9jay9ibGstY29yZS5jCmluZGV4IGY4
Y2IwOTkuLjdlOTg2NzcgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2Jsay1jb3JlLmMKKysrIGIvYmxvY2sv
YmxrLWNvcmUuYwpAQCAtMTI4Miw4ICsxMjgyLDEwIEBAIGdldF9ycToKIAlpbml0X3JlcXVlc3Rf
ZnJvbV9iaW8ocmVxLCBiaW8pOwogCiAJaWYgKHRlc3RfYml0KFFVRVVFX0ZMQUdfU0FNRV9DT01Q
LCAmcS0+cXVldWVfZmxhZ3MpIHx8Ci0JICAgIGJpb19mbGFnZ2VkKGJpbywgQklPX0NQVV9BRkZJ
TkUpKQotCQlyZXEtPmNwdSA9IHNtcF9wcm9jZXNzb3JfaWQoKTsKKwkgICAgYmlvX2ZsYWdnZWQo
YmlvLCBCSU9fQ1BVX0FGRklORSkpIHsKKwkJcmVxLT5jcHUgPSBnZXRfY3B1KCk7CisJCXB1dF9j
cHUoKTsKKwl9CiAKIAlwbHVnID0gY3VycmVudC0+cGx1ZzsKIAlpZiAocGx1Zykgewo=
--20cf303b3cc1f51a0304a8f1a6b5--
