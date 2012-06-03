Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab2FCF66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 01:58:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46086 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2FCF64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 01:58:56 -0400
MIME-Version: 1.0
Date: Sun, 3 Jun 2012 01:58:55 -0400
Message-ID: <CALKntY1xQ7v5VRKxqT3A3G+W3s3CK_JtqWB5GkBcN08J6Hn=-A@mail.gmail.com>
Subject: futex system call in write
From: Xin Tong <xerox.time.tech@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am a program with 2 threads, each of which calling printf in a loop.
when i strace this programs. i see besides write() gets calls a good
number of times. futex gets call many times as well. it seems to be
related to the write system call ? how is the futex system call used
here ? maybe write() is blocking and futex is used to wait the thread
up when the write finishes ? if that is the case, what about other
blocking system calls ?

[pid  9057] [      377b4f542e] futex(0x377b78be10, FUTEX_WAIT_PRIVATE,
2, NULL <unfinished ...>
[pid  9058] [      377b4f545f] futex(0x377b78be10, FUTEX_WAKE_PRIVATE,
1 <unfinished ...>
[pid  9057] [      377b4f542e] <... futex resumed> ) = -1 EAGAIN
(Resource temporarily unavailable)
[pid  9058] [      377b4f545f] <... futex resumed> ) = 0
[pid  9057] [      377b4d8a2d] write(1, "Hello World! It's me, thread
#0!"..., 33Hello World! It's me, thread #0!
 <unfinished ...>
[pid  9058] [      377b4f542e] futex(0x377b78be10, FUTEX_WAIT_PRIVATE,
2, NULL <unfinished ...>
[pid  9057] [      377b4d8a2d] <... write resumed> ) = 33
[pid  9057] [      377b4f545f] futex(0x377b78be10, FUTEX_WAKE_PRIVATE,
1 <unfinished ...>
[pid  9058] [      377b4f542e] <... futex resumed> ) = 0
[pid  9057] [      377b4f545f] <... futex resumed> ) = 1
[pid  9058] [      377b4d8a2d] write(1, "Hello World! It's me, thread
#1!"..., 33Hello World! It's me, thread #1!
 <unfinished ...>
[pid  9057] [      377b4f542e] futex(0x377b78be10, FUTEX_WAIT_PRIVATE,
2, NULL <unfinished ...>
[pid  9058] [      377b4d8a2d] <... write resumed> ) = 33
[pid  9058] [      377b4f545f] futex(0x377b78be10, FUTEX_WAKE_PRIVATE, 1) = 1
[pid  9057] [      377b4f542e] <... futex resumed> ) = 0
[pid  9058] [      377b4d8a2d] write(1, "Hello World! It's me, thread
#1!"..., 33Hello World! It's me, thread #1!
 <unfinished ...>
