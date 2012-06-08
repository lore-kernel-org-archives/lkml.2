Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266Ab2FHUTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 16:19:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34970 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab2FHUTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 16:19:16 -0400
MIME-Version: 1.0
Date: Fri, 8 Jun 2012 13:19:15 -0700
Message-ID: <CAH5vBdLPhd8Q4ZwFP7Zy_yLfNEezRGrkeFJeO1eyh+dcF+oYsw@mail.gmail.com>
Subject: 67 kworker threads ?
From: cheng renquan <crquan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have kernel v3.4.0 up & running over 2 weeks on a 4-cores typical
lenovo laptop,
with suspend & resume only, every day; have just found after a resume the kernel
may spawn too many kworker threads, totally 67 kworker threads now,
I think this is abnormal

$ ps fu -e |awk 'NR <=2 || /[k]worker/'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         2  0.0  0.0      0     0 ?        S    Jun07   0:00 [kthreadd]
root     10271  0.0  0.0      0     0 ?        S    11:35   0:00  \_
[kworker/0:3]
root     11683  0.0  0.0      0     0 ?        S    11:46   0:00  \_
[kworker/u:0]
root     14364  0.0  0.0      0     0 ?        S    12:08   0:01  \_
[kworker/0:0]
root     14965  0.1  0.0      0     0 ?        S    12:13   0:03  \_
[kworker/u:1]
root     17154  0.0  0.0      0     0 ?        S    12:31   0:00  \_
[kworker/u:2]
root     17937  0.0  0.0      0     0 ?        S    12:38   0:00  \_
[kworker/u:3]
root     18286  0.0  0.0      0     0 ?        S    12:39   0:00  \_
[kworker/u:4]
root     18287  0.0  0.0      0     0 ?        S    12:39   0:00  \_
[kworker/u:5]
root     18288  0.0  0.0      0     0 ?        S    12:39   0:00  \_
[kworker/u:6]
root     18289  0.0  0.0      0     0 ?        S    12:39   0:00  \_
[kworker/u:7]
root     18290  0.0  0.0      0     0 ?        S    12:39   0:00  \_
[kworker/u:8]
root     18291  0.0  0.0      0     0 ?        S    12:39   0:00  \_
[kworker/u:9]
root     18292  0.0  0.0      0     0 ?        S    12:39   0:00  \_
[kworker/u:10]
root     18300  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/1:2]
root     18303  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/2:2]
root     18306  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/3:0]
root     18320  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:11]
root     18321  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:12]
root     18322  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:13]
root     18323  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:14]
root     18324  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:15]
root     18325  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:16]
root     18326  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:17]
root     18327  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:18]
root     18328  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:19]
root     18329  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:20]
root     18330  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:21]
root     18331  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:22]
root     18332  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:23]
root     18333  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:24]
root     18334  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:25]
root     18335  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:26]
root     18336  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:27]
root     18337  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:28]
root     18338  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:29]
root     18339  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:30]
root     18340  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:31]
root     18341  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:32]
root     18342  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:33]
root     18343  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:34]
root     18344  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:35]
root     18345  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:36]
root     18346  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:37]
root     18347  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:38]
root     18348  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:39]
root     18349  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:40]
root     18350  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:41]
root     18351  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:42]
root     18352  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:43]
root     18353  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:44]
root     18354  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:45]
root     18355  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:46]
root     18356  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:47]
root     18357  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:48]
root     18358  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:49]
root     18359  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:50]
root     18360  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:51]
root     18361  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:52]
root     18362  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:53]
root     18363  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:54]
root     18364  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:55]
root     18365  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:56]
root     18366  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:57]
root     18367  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:58]
root     18368  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/u:59]
root     18369  0.9  0.0      0     0 ?        S    13:05   0:01  \_
[kworker/3:1]
root     18370  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/0:1]
root     18374  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/0:2]
root     18380  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/1:0]
root     18393  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/2:0]
root     18506  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/3:2]
root     18571  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[kworker/2:1]
