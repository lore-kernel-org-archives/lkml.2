Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0HCJfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:35:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35253 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab0HCJfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:35:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=DmdVi+YugqLS9ljkHYS50PlYH+AkMvq9JW1S0EXqCH9DYxyoibDb7yVeYo07SIc1pY
         VfK98MO6sYLyEEBJyOCMG65gJcwf1Q4PWvCj3OsRpHzvTnIEtnQzncxjIc5tzl4Ttukm
         Fm/Qe2lqMk/jP/eTtq9HQy89siMGnCgTSReKc=
Date: Tue, 3 Aug 2010 17:35:40 +0800
From: "hacklu" <embedway.linux@gmail.com>
To: "=?gb2312?B?QW2opnJpY28gV2FuZw==?=" <xiyou.wangcong@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201008031037022524247@gmail.com>,
 <201008031511572638256@gmail.com>
Subject: Re: Re: how about KBUILD_MODNAME
Message-ID: <201008031735377545190@gmail.com>
X-mailer: Foxmail 6, 15, 201, 22 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o739Zuix021683


I am compiling the boardcom's driver now.
the driver had defined EXTRA_CFLAGS = -D"KBUILD_STR(s)=\#s" $(basename_flags) $(modname_flags) 
in the a.makefile.
and the a.makefile was included by b.makefile.
when in the b.makefile,
there is this command.
 $(CC) $(DEPS_OPT) $(CFLAGS) $(EXTRA_CFLAGS) -o $@ -c $< ;) 

I had add "echo $(EXTRA_CFLAGS)" before this line;but returns NULL;

so I suspicion the $(EXTRA_CFLAGS) hasn't been work.

I aslo try to add "export EXTRA_CFLAGS" in a.makefile,but it doesn't work either.

the problem has puzzled me for some days.

help me please~~



2010-08-03 



hacklu 



·¢¼şÈË£º Am¨¦rico Wang 
·¢ËÍÊ±¼ä£º 2010-08-03  16:32:08 
ÊÕ¼şÈË£º hacklu 
³­ËÍ£º linux-kernel 
Ö÷Ìâ£º Re: how about KBUILD_MODNAME 
 
On Tue, Aug 03, 2010 at 03:11:59PM +0800, hacklu wrote:
>
>I don't understand the macro KBUILD_MODNAME .
>when I compile a  driver program. It returns me "linux/pci.h:655: error: 'KBUILD_MODNAME' undeclared (first use in this function) "
>
>In the makefile I had used the "-D" options
>
You don't need to care about KBUILD_MODNAME, it is defined
internally by kbuild and passed to your module via "-DKBUILD_MODNAME=XXX"
automatically.
So, it looks like you didn't write your makefile correctly.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
