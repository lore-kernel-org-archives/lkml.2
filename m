Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208Ab2BXQrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:47:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab2BXQrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:47:23 -0500
Subject: Re: [PATCH, v2] x86-64: fix CFI annotations for NMI nesting code
From: Steven Rostedt <srostedt@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <4F47B2BD0200007800074AD7@nat28.tlf.novell.com>
References: <4F47B2BD0200007800074AD7@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 24 Feb 2012 11:47:03 -0500
Message-ID: <1330102023.3306.22.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-24 at 14:54 +0000, Jan Beulich wrote:
> The saving and restoring of %rdx wasn't annotated at all, and the
> jumping over sections where state gets partly restored wasn't handled
> either.
> 
> Further, by folding the pushing of the previous frame in repeat_nmi
> into that which so far was immediately preceding restart_nmi (after
> moving the restore of %rdx ahead of that, since it doesn't get used
> anymore when pushing prior frames), annotations of the replicated
> frame creations can be made consistent too.
> 
> v2: Fully fold repeat_nmi into the normal code flow (adding a single
>     redundant instruction to the "normal" code path), thus retaining
>     the special protection of all instructions between repeat_nmi and
>     end_repeat_nmi.

Thanks, I'll start testing it.

> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Steven Rostedt <srostedt@redhat.com>

FYI, please send to my rostedt@goodmis.org account. My RH account is a
second class citizen that I use to read RH status updates and such. I
don't conduct upstream work from it and I may ignore it for long periods
of time.

I author code with it just to give credit to the company that pays me,
but my SOB is always the goodmis.org account.

Thanks,

-- Steve


