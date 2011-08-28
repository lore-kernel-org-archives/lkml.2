Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab1H1SnK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 14:43:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44207 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1H1SnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 14:43:09 -0400
MIME-Version: 1.0
Date: Sun, 28 Aug 2011 15:43:07 -0300
Message-ID: <CAK1XTrvcXHwDAOdh7SDevuer-eZuhMjXwvuoRCr0BUEOCr6HgA@mail.gmail.com>
Subject: ptrace() behaviour when doing PTRACE_KILL
From: Pablo Antonio <pabloa@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
    I was writing some user code that uses the ptrace() system call
and found it wasn't behaving as I expected. Maybe this is simply
because I don't know enough about ptrace()'s behaviour, so I'd like
someone to enlighten me with some information.

So, here's the code: http://codepad.org/TJ7Lua4Q Basically, I was
expecting the parent process to kill the child when the later
attempted to use the kill() system call, not letting it send signals
to other processes. I had done this before with pretty much the same
code, but instead of killing when kill() was called, I was doing it
when a fork() or clone() was attempted. And it worked. If the child
process tried to create a new process via fork() or clone(), then it
was immediately killed and no process was created.

But now that I'm doing the same thing with kill(), I'm seeing that the
child process ends up killed, as expected, but the signal is sent
nonetheless. I understand that when I do the PTRACE_KILL, a SIGKILL
signal is sent to the child. And PTRACE_KILL is used on syscall
entrance in that code. If the SIGKILL signal is delivered to the
process before it continues executing the system call in kernelspace,
then I don't understand why this code doesn't work as expected. If the
signal is delivered after the system call is completely executed, then
I don't understand why this was working for the fork() and clone()
case.

I'd really appreciate if someone told me what's happening here, or
what I'm not seeing.

Thanks,

-- 
Pablo Antonio (AKA crazy2k)
http://www.pablo-a.com.ar/
