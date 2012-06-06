Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2FFOZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:25:10 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43399 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2FFOZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:25:09 -0400
X-AuditID: b753bd60-925c5ba000002ea5-1d-4fcf6842e9d0
X-AuditID: b753bd60-925c5ba000002ea5-1d-4fcf6842e9d0
Message-ID: <4FCF683A.90202@hitachi.com>
Date: Wed, 06 Jun 2012 23:24:58 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on
 i386
References: <20120605102734.27845.43401.stgit@localhost.localdomain> <20120605102802.27845.49309.stgit@localhost.localdomain> <m2ehptjull.fsf@firstfloor.org>
In-Reply-To: <m2ehptjull.fsf@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/06 6:51), Andi Kleen wrote:
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>>  
>> +	.macro FTRACE_SAVE_ALL
>> +	/* eflags is saved on cs */
>> +	subl $8, %esp		/* skip ip and orig_ax */
>> +	pushl %gs
>> +	pushl %fs
> 
> For pure in kernel use you don't need to save/restore fs/gs
> This is only needed on kernel/user space boundaries.
> 
> And for this usage probably also not flags

I see, most of the case, user doesn't really need it.
But in some case, it can be easily imagined that pt_regs
is used for dumping all registers. Suppose that this
ftrace-based kprobe optimization is done transparently,
they may see that the results of dumping registers
are different even if the probe moves just one instruction
ahead. I'd like to avoid this kind of differences.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
