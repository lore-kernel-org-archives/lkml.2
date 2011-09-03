Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1ICDeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 23:34:37 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45898 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1ICDee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 23:34:34 -0400
MIME-Version: 1.0
From: Pavel Ivanov <paivanof@gmail.com>
Date: Fri, 2 Sep 2011 23:34:01 -0400
Message-ID: <CAG1a4rvdYnOSWu3DJ+DL+Q_bfsfTv_px20vP06fBKRm6B8cwMw@mail.gmail.com>
Subject: Full lockup when compiling kernel with "optimal" number of threads
To: ecryptfs@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I can reliably reproduce a complete machine lockup when compiling
kernel sources with "make -j". After making some progress machine
stops responding to anything (including CapsLock/NumLock switching or
mouse moving) and after hard reboot nothing is left in kern.log or
syslog. Only attaching a serial console gives me the following clues
to what happens:

[  376.460584] INFO: task cc1:6839 blocked for more than 60 seconds.
[  376.533411] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  376.627129] INFO: task cc1:6840 blocked for more than 60 seconds.
[  376.699991] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  376.793636] INFO: task cc1:6850 blocked for more than 60 seconds.
[  376.866397] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  376.960026] INFO: task cc1:7017 blocked for more than 60 seconds.
[  377.032776] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  377.128156] INFO: task cc1:7079 blocked for more than 60 seconds.
[  377.200907] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  377.294522] INFO: task cc1:7188 blocked for more than 60 seconds.
[  377.367274] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  377.460984] INFO: task cc1:8342 blocked for more than 60 seconds.
[  377.533746] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  377.627372] INFO: task cc1:8425 blocked for more than 60 seconds.
[  377.700119] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  377.793737] INFO: task cc1:8502 blocked for more than 60 seconds.
[  377.866488] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  377.960103] INFO: task cc1:8535 blocked for more than 60 seconds.
[  378.034788] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.

Interesting thing is that after such hang happens, I reboot the
machine and try to build again (this time with limited number of
threads) I get lots of "input/output errors" from make and messages
like the following in kern.log:

[  186.518188] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[  186.522951] ecryptfs_decrypt_page: Error attempting to read lower
page; rc = [-4]
[  186.522955] ecryptfs_readpage: Error decrypting page; rc = [-4]
[  186.542690] Valid eCryptfs headers not found in file header region
or xattr region
[  186.542694] Either the lower file is not in a valid eCryptfs
format, or the key could not be retrieved. Plaintext passthrough mode
is not enabled; returning -EIO

(As you can guess I'm building in my home directory which is ecryptfs.)

After that only doing "make distclean" allows me to compile kernel
again. And note that when I build with "make -j 10" everything works
fine (I have 2 CPUs with 4 cores each without hyper-threading).


So is it some bug or a known bad usage of ecryptfs?


Thank you,
Pavel
