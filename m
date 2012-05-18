Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030687Ab2ERChH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:37:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60022 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030509Ab2ERChE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
	<CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com>
	<CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
	<CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
Date: Thu, 17 May 2012 19:37:03 -0700
X-Google-Sender-Auth: EfX-TfuzqgGeRWJsMcjVa70kVto
Message-ID: <CA+8MBbLw9ySj5VDjJJ04fW383=8AUhDfyvqdrPnAR7+-etGFqQ@mail.gmail.com>
Subject: Re: [git pull] machine check recovery fix
From: Tony Luck <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 5:25 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> If the machine check happened in kernel space, we currently *are*
> returning to the instruction that executed. With or without your
> patch. That's my argument.

When we assign the severity for the error we check for kernel vs. user
space. If we took the machine check in kernel space it will get assigned
MCE_PANIC_SEVERITY severity ... and we won;t try to do any
recovery.  We only play the games with TIF_MCE_NOTIFY if we
see severity MCE_AR_SEVERITY ... which we will only do if the
machine check happened in user mode.

So current recovery code only tries to deal with the user case.

Machine checks in kernel space are a future project ... and I agree
will be a monster pain because we'll have to figure out everything
in machine check context.

-Tony
