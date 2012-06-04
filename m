Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab2FDPOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:14:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48429 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab2FDPON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:14:13 -0400
Date: Mon, 4 Jun 2012 19:14:07 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>
Subject: Probleam reading fdinfo symlinks after
 30a08bf2d31d275c6fc71dd1811342777e95c831
Message-ID: <20120604151407.GD23701@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

just tried 3.5-rc1 out and found that with commit
30a08bf2d31d275c6fc71dd1811342777e95c831 the reading
of fdinfo files returns "Too many levels of symbolic links"
error.

 | [root@neptune~]# cat /proc/`pidof crond`/fdinfo/0
 | cat: /proc/1417/fdinfo/0: Too many levels of symbolic links

so I reverted it manually and now it works as expected

 | [root@neptune ~]# cat /proc/`pidof crond`/fdinfo/0
 | pos:	0
 | flags:	0100002

I suspect this is unintentional behaviour of the commit.
