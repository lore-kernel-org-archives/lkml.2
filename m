Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab1JYJsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:48:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37333 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab1JYJsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:48:04 -0400
MIME-Version: 1.0
Date: Tue, 25 Oct 2011 17:48:02 +0800
Message-ID: <CADUXgx6px7VzcnnGGTHKGgGEEbDsKmw0AjKbpEUKO1Mk50qpHw@mail.gmail.com>
Subject: NSIG/_NSIG sigset_t definition for 32 bit x86 in kernel head file
From: Fengwei Yin <yfw.kernel@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
In arch/x86/include/asm/signal.h, _NSIG/NSIG and sigset_t definition don't match
for kernel (64, 8 bytes) and for user space (32, 4 bytes). But the
syscall rt_sigaction
checks the sigset size from user space. If it doesn't match sigset
size in kernel,
the syscall return failure.

I checked the glibc and it doesn't inherit the definition from kernel head file.
It use its own definition. So should these definition for user space
in kernel head be
removed and just let user space use its own definition?

I know it doesn't impact generic code because libc implementation
hides it. But what
about the libc (not glibc) implementation?

Regards
yfw
