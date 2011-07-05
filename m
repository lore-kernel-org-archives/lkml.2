Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1GEJz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 05:55:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:58981 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1GEJz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 05:55:27 -0400
From: Richard Weinberger <richard@nod.at>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH][Resend v2] Fix infinite loop in search_binary_handler()
Date: Tue, 5 Jul 2011 11:55:18 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.4; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1309779003-8668-1-git-send-email-richard@nod.at> <201107050017.30365.richard@nod.at> <201107050124.p651OExY025046@www262.sakura.ne.jp>
In-Reply-To: <201107050124.p651OExY025046@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051155.18465.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 05 Juli 2011, 03:24:14 schrieb Tetsuo Handa:
> Richard Weinberger wrote:
> > With MAX_KMOD_CONCURRENT=3 it takes only a few seconds until
> > the modprobe storm ends.
> 
> OK. Many years ago, I got a few reports that the kernel panics after
> printing
> 
>   request_module: runaway loop modprobe binfmt-464c
> 
> line. This was because they installed by error a binary x86_32 kernel rpm
> on x86_64 userland tools. So, this error is not specific to UML.
> 
> > How shall we proceed?
> > Applying my ad-hoc patch
> > or lowering MAX_KMOD_CONCURRENT?
> 
> What about disallowing request_module() for ____call_usermodehelper()
> threads?

This patch helps.
But IMHO adding a new attribute to task_struct is a bit overkill.
Why is your variant better than my strcmp() in fs/exec.c?

Thanks,
//richard
