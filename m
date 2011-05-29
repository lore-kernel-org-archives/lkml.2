Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab1E2UeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:34:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36977 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1E2UeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:34:05 -0400
Date: Sun, 29 May 2011 22:34:02 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] x86-64: Give vvars their own page
Message-ID: <20110529203402.GB1192@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@MIT.EDU>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <cover.1306517576.git.luto@mit.edu>
 <80895427afdff1cb56c7f02d567f92ce2e1fa9d8.1306517576.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <80895427afdff1cb56c7f02d567f92ce2e1fa9d8.1306517576.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:38:39PM -0400, Andy Lutomirski wrote:
> Move vvars out of the vsyscall page into their own page and mark it
> NX.
> 
> Without this patch, an attacker who can force a daemon to call some
> fixed address could wait until the time contains, say, 0xCD80, and
> then execute the current time.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> ---
>  arch/x86/include/asm/fixmap.h        |    1 +
>  arch/x86/include/asm/pgtable_types.h |    2 ++
>  arch/x86/include/asm/vvar.h          |   22 ++++++++++------------
>  arch/x86/kernel/vmlinux.lds.S        |   27 ++++++++++++++++-----------
>  arch/x86/kernel/vsyscall_64.c        |    5 +++++
>  tools/power/x86/turbostat/turbostat  |  Bin 0 -> 29200 bytes

You've added the turbostat binary to the diffstat too. I believe this
wasn't your intention, no? :)

-- 
Regards/Gruss,
    Boris.
