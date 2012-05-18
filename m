Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966911Ab2ERAZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:25:46 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51442 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab2ERAZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:25:45 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
References: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
 <CA+55aFxB6YSz-KEwVKtOesS7yrdvYw6sP3mfpuWBOheJVL6e+w@mail.gmail.com> <CA+8MBbK_xeN5HWnSvbDYwzZ+E0pSpbDte30RH2deo0r1OzYBGA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 May 2012 17:25:24 -0700
X-Google-Sender-Auth: FAks29Fd46e_goHD5deUdd5WUmM
Message-ID: <CA+55aFxvjBQ+nn2JEnrMeHrRq9O7-aost1ZYrQbOFySkU_piWg@mail.gmail.com>
Subject: Re: [git pull] machine check recovery fix
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 5:14 PM, Tony Luck <tony.luck@intel.com> wrote:
> On Thu, May 17, 2012 at 3:45 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Also, the whole "nonrestartable state flag" means - if I understood
>> things correctly - that you really cannot do the "iret" even from the
>> NMI handler.
>
> Not quite ... we can "iret" ... but not back to the instruction that was
> executing when the machine check occurred. We need to go some
> place else .... hence we send a signal that will either kill the process

Tony, I don't think you understand.

If the machine check happened in kernel space, we currently *are*
returning to the instruction that executed. With or without your
patch. That's my argument.

Your _TIF_MCE_NOTIFY games do *nothing*, because they only get tested
at return to user space - not on return to the MC faulting kernel
space instruction.

This is what I was talking about - the thing looks to work entirely
*accidentally* - and only for the user-space case.

                        Linus
