Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab0HJSv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:51:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab0HJSvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:51:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [GIT] writable_limits for 2.6.36
Date: Tue, 10 Aug 2010 20:50:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <4C5D4E50.5050105@suse.cz> <AANLkTimPS_WFvEwyx+odwof5_AF5ZTOhu-3uK6m_VhYa@mail.gmail.com> <4C617C94.5010808@tilera.com>
In-Reply-To: <4C617C94.5010808@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008102050.12558.arnd@arndb.de>
X-Provags-ID: V02:K0:vvnxScHB6nzcC1gIAiNQMzUIhrGbq2mybphIph9QBeV
 qXoyj9BJq9MAxWUioVXq6I/mEyjVS5E9OYMkAv/PGX8XYcxh3n
 i8xEJDowpizpuYEGH4J6yEMHNNuw3Rd8cQa4p0q7pWTht74EYb
 qp17GkW8x46paKvFcAGNKRuVmKc6eHNHkJPRzQU3Fmhw4YDxa2
 LZPitr2NN6DtPRHsA+mlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 August 2010, Chris Metcalf wrote:
> In any case, obviously the larger question is how many
> architecture-specific syscalls are appropriate, and where they should be
> located in the syscall number space.  To be clear, the model for new
> generic system calls is that they just continue on after the 16
> architecture-specific ones, and in fact __NR_wait4 is already an example
> of just this -- done that way to avoid making trouble for the "score"
> architecture, since it was deprecated and then later un-deprecated.  So
> new generic syscalls are not a problem.

Right. The writable_rlimits syscall should just go after wait4 at 262.

In retrospect, it would have been nicer to have the architecture specific
syscalls start at zero, but it's too late for that. Since we don't have
an architecture with more than a handful of arch specific calls, I think
16 will get us a very long way, while trying to leave "enough" space
between the generic and the arch specific calls would result either
in wasting space in the table or chosing a too small value.

	Arnd
