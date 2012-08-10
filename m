Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2HJLoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:44:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63828 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2HJLoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:44:22 -0400
Date: Fri, 10 Aug 2012 19:44:40 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: "Shaohua Li" <shli@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Fix problems about handling bio to plug when bio merged failed.
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208101944375001710@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7ABiTHm032405

There are some problems about handling bio which merge to plug failed.
Patch1 will avoid unnecessary plug should_sort test,although it's not a bug.
Patch2 correct a bug when handle more devices,it leak some devices to trace plug-operation.

Because the patch2,so it's not necessary to sort when flush plug.Although patch2 has 
O(n*n) complexity,it's more than list_sort which has O(nlog(n)) complexity.But the plug 
list is unlikely too long,so i think patch3 can accept.


Jianpeng Ma (3):
  block: avoid unnecessary plug should_sort test.
  block: Fix not tracing all device plug-operation.
  block: Remove unnecessary requests sort.

 block/blk-core.c |   35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
