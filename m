Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab0JZR7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 13:59:47 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:32797 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933272Ab0JZR7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 13:59:43 -0400
X-ClientAddr: 91.118.60.26
Date: Tue, 26 Oct 2010 19:53:06 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] telephony: fix return value
Message-ID: <20101026195306.6a61a358@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-m2soft-MailScanner-Information: Please contact the ISP for more information
X-m2soft-MailScanner-ID: o9QHsmAB029111
X-m2soft-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-m2soft-MailScanner-From: nikai@nikai.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If copy_from_user fails, the return value gets overwritten.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/telephony/ixj.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 0d236f4..2d1280a 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -6581,7 +6581,8 @@ static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long ar
 	case IXJCTL_SET_FILTER:
 		if (copy_from_user(&jf, argp, sizeof(jf))) 
 			retval = -EFAULT;
-		retval = ixj_init_filter(j, &jf);
+		else
+			retval = ixj_init_filter(j, &jf);
 		break;
 	case IXJCTL_SET_FILTER_RAW:
 		if (copy_from_user(&jfr, argp, sizeof(jfr))) 
-- 
1.7.2.2
