Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0KNMzn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 07:55:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab0KNMzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 07:55:40 -0500
Message-ID: <4CDFDC2B.6040205@redhat.com>
Date: Sun, 14 Nov 2010 14:55:07 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Ian Kent <raven@themaw.net>, autofs@linux.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: autofs4 hang in 2.6.37-rc1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A 2.6.37-rc1 (f6614b7bb405a) setup hangs in autofs4:

INFO: task automount:10399 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
automount     D 0000000000000000     0 10399      1 0x00000000
  ffff88012a059da8 0000000000000082 0000000000000000 0000000000000000
  ffff88012a058010 ffff88012a059fd8 0000000000011800 ffff8801290f2c40
  ffff8801290f2fb0 ffff8801290f2fa8 0000000000011800 0000000000011800
Call Trace:
  [<ffffffff813a3c3c>] __mutex_lock_common+0x126/0x18b
  [<ffffffff813a3cb5>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff813a3dbc>] mutex_lock+0x31/0x4b
  [<ffffffff811b17f7>] autofs4_root_ioctl+0x28/0x53
  [<ffffffff810f5e5c>] do_vfs_ioctl+0x557/0x5bb
  [<ffffffff810eca65>] ? sys_newlstat+0x2d/0x38
  [<ffffffff810f5f02>] sys_ioctl+0x42/0x65
  [<ffffffff81002b42>] system_call_fastpath+0x16/0x1b

This is a simple /home automount.  More info on request.

-- 
error compiling committee.c: too many arguments to function

