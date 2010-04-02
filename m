Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab0DBO2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 10:28:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756958Ab0DBO2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 10:28:00 -0400
Message-ID: <4BB5FED3.4020809@redhat.com>
Date: Fri, 02 Apr 2010 10:27:31 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] "perf probe" updates, kprobes jump optimization, for
 	v2.6.34
References: <20100301194109.GA10847@elte.hu> <t2o12c511ca1004011450wf862bf81gcf714281be40ee4e@mail.gmail.com>
In-Reply-To: <t2o12c511ca1004011450wf862bf81gcf714281be40ee4e@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

Tony Luck wrote:
> On Mon, Mar 1, 2010 at 11:41 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> Please pull the latest perf-probes-for-linus git tree from:
> 
> Since this went in I'm seeing:
> 
> kernel/kprobes.c:719: warning: ‘arm_kprobe’ defined but not used
> 
> from the arch/ia64/configs/zx1_defconfig build on ia64
> 
> Looks to be because that config ends up with:
> 
> CONFIG_KPROBES=y
> 
> together with
> 
> # CONFIG_DEBUG_FS is not set

Ah, thank you for reporting!
Hmm, it seems that the place of definitions of enable_kprobe/disable_kprobe
which call arm_kprobe/disarm_kprobe, are incorrect, because those functions
are just API and don't depend on debugfs.
I'll fix that.


Thank you,

> 
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
