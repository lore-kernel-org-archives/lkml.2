Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751031Ab2LSU5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 15:57:41 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39072 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab2LSU5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 15:57:34 -0500
Date: Wed, 19 Dec 2012 21:57:32 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v6 03/27] x86, boot: move verify_cpu.S and no_longmode
 after 0x200
Message-ID: <20121219205732.GI24895@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-4-git-send-email-yinghai@kernel.org>
 <20121215170625.GA9875@liondog.tnic>
 <CAE9FiQUSoSvtFMMQt3eZkrXFCkzXhLu6GfqYMGNb3=uA052Axw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQUSoSvtFMMQt3eZkrXFCkzXhLu6GfqYMGNb3=uA052Axw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 07:44:55PM -0800, Yinghai Lu wrote:
> On Sat, Dec 15, 2012 at 9:06 AM, Borislav Petkov <bp@alien8.de> wrote:
> > On Thu, Dec 13, 2012 at 02:01:57PM -0800, Yinghai Lu wrote:
> >> We are short of space before 0x200 that is entry for startup_64.
> >
> > And you're moving this down because of the couple of bytes the next
> > patch is adding? If so, then explain that here.
> 
> better?
> 
> ---
> Subject: [PATCH] x86, boot: move verify_cpu.S and no_longmode down
> 
> We need to move some code with 32bit section in following patch:
> 
>    x86, boot: Move lldt/ltr out of 64bit code section
> 
> but that will push startup_64 down from 0x200.
> 
> According to hpa, we can not change startup_64 to other offset and
> that become ABI now.
> 
> We could move function verify_cpu and no_longmode down, because
> verify_cpu is used via function call and no_longmode will not
> return.
> ---

Almost.

So this explains what you're doing but I'd like to know why?

Why do you need to free some more room between startup_32 and
startup_64? Do you need this room in another patch, maybe the next one:

"[PATCH v7 14/27] x86, boot: Move lldt/ltr out of 64bit code section"

Is that so? If yes, please write that in the commit message so that we
know why you're doing that change.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
