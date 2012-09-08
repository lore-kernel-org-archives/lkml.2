Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2IHJkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 05:40:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57906 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2IHJkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 05:40:43 -0400
Date: Sat, 8 Sep 2012 17:41:05 +0800
From: "Jianpeng Ma" <majianpeng@gmail.com>
To: gregkh <gregkh@linuxfoundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: About function __create_file  in debugfs
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201209081741013286843@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q889fdEo010958

Hi:
	At present,i used blktrace to trace block io.But i always met error, the message like:
>BLKTRACESETUP(2) /dev/sdc failed: 2/No such file or directory
>Thread 0 failed open /sys/kernel/debug/block/(null)/trace0: 2/No such file or directory
>Thread 2 failed open /sys/kernel/debug/block/(null)/trace2: 2/No such file or directory
>Thread 3 failed open /sys/kernel/debug/block/(null)/trace3: 2/No such file or directory

>Thread 1 failed open /sys/kernel/debug/block/(null)/trace1: 2/No such file or directory
>FAILED to start thread on CPU 0: 1/Operation not permitted
>FAILED to start thread on CPU 1: 1/Operation not permitted
>FAILED to start thread on CPU 2: 1/Operation not permitted
>FAILED to start thread on CPU 3: 1/Operation not permitted

But those isn't important. I add some message in kernel and found the reason is inode already existed.
But the function __create_file dosen't return correctly errno.So blktrace tool can't print correctly message.
I think func __create_file should return correctly message(ERR_PTR(error)) not NULL.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
