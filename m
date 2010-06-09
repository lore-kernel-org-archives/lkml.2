Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0FIK5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:57:10 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:48551 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab0FIK5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:57:08 -0400
From: "Pavel N. Iakovenko" <yak@ispras.ru>
To: <linux-kernel@vger.kernel.org>
Subject: setgroups32 syscall changes RCX register
Date: Wed, 9 Jun 2010 14:57:03 +0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Thread-Index: AcsHvWBny95jSKvjRBWst9es3+YdugABP9lg
Message-Id: <20100609105115.6EB2D5D40B9@smtp.ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o59AvFim012416

Hello

I noticed that setgroups32 syscall changes the value of RCX register. In my
case š- it is increased by PAGE_SIZE. Is it an acceptable behavior?
Kernel version is 2.6.31.6. Testing program is enclosed.

Please CC me on reply.

Best regards,
Pavel Iakovenko

#include <unistd.h>
#include <sys/types.h>
#include <syscall.h>
#include <grp.h>
#include <stdio.h>
#include <errno.h>

int main()
{
ššššššššššš gid_t groups;
ššššššššššš unsigned long rcx;
ššššššššššš int r ;

ššššššššššš r = initgroups("root", groups);
ššššššššššš if (r) {
ššššššššššš ššš printf("initgroups failed\n");
ššššššššššš ššš goto out;
ššššššššššš }
ššššššššššš 
ššššššššššš printf("before setgroups32: RCX = 0x%lx\n", (unsigned
long)&groups);

ššššššššššš asm
ššššššššššš (
ššššššššššššššššššššššš "int $0x80"
ššššššššššššššššššššššš : "=a" (r), "=c" (rcx)
ššššššššššššššššššššššš : "a" (SYS_setgroups32), "b"(1), "c" (&groups)
ššššššššššš );

ššššššššššš if (r) {
ššššššššššš ššš printf("setgroups32 failed\n");
ššššššššššš ššš goto out;
ššššššššššš }
ššššššššššš 
ššššššššššš printf("after setgroups32: RCX = 0x%lx\n", rcx);

out:
ššššššššššš return 0;
}
 

__________ Information from ESET NOD32 Antivirus, version of virus signature
database 5184 (20100609) __________

The message was checked by ESET NOD32 Antivirus.

http://www.esetnod32.ru/.ml
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
