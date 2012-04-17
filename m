Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab2DQUVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:21:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59042 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2DQUVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:21:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120417172142.GA30237@redhat.com>
References: <20120417172142.GA30237@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Apr 2012 13:20:51 -0700
X-Google-Sender-Auth: HBlEyv1qAHqi511aWaaQIAsOqTM
Message-ID: <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 10:21 AM, Dave Jones <davej@redhat.com> wrote:
> My syscall fuzzer started showing up some cases where it we seem to be
> overrunning the stack.  I added a WARN_ON when the stack is really low,
> to see if there's a deep call trace, but it's not really telling me much ..

You seem to have added the WARN_ON() to check_stack_usage() itself.

That's not very useful, because it uses the *current* stack pointer.
Instead, how about just calling "show_trace()" with the actual lowest
stack pointer at that point? That should show you the stack as it was
when it was at its lowest, and that could actually be useful.

IOW, just something like

    show_trace(NULL, NULL, (void *)end_of_stack(p) + lowest_to_date, NULL);

Or something kind of like that. Yes?

                           Linus
