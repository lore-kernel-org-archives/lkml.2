Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2FEVvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 17:51:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:63093 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2FEVvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 17:51:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175219751"
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v2 3/9] ftrace/x86: Support SAVE_REGS feature on i386
References: <20120605102734.27845.43401.stgit@localhost.localdomain>
	<20120605102802.27845.49309.stgit@localhost.localdomain>
Date: Tue, 05 Jun 2012 14:51:18 -0700
In-Reply-To: <20120605102802.27845.49309.stgit@localhost.localdomain> (Masami
	Hiramatsu's message of "Tue, 05 Jun 2012 19:28:02 +0900")
Message-ID: <m2ehptjull.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> writes:
>  
> +	.macro FTRACE_SAVE_ALL
> +	/* eflags is saved on cs */
> +	subl $8, %esp		/* skip ip and orig_ax */
> +	pushl %gs
> +	pushl %fs

For pure in kernel use you don't need to save/restore fs/gs
This is only needed on kernel/user space boundaries.

And for this usage probably also not flags


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
