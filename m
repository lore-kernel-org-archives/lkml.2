Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534Ab1GEN2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:28:30 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46954 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932305Ab1GEN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:28:29 -0400
Date: Tue, 5 Jul 2011 17:28:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org
Subject: Re: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from 64
 bit.
Message-ID: <20110705132825.GA3900@sun>
References: <20110705111525.GR17941@sun>
 <1309870814-14181-1-git-send-email-ian.campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309870814-14181-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 02:00:12PM +0100, Ian Campbell wrote:
> For no reason that I can determine 64 bit x86 saves the current eflags
> in cpu_init purely for use in ret_from_fork. The equivalent 32 bit
> code simply hard codes 0x0202 as the new EFLAGS which seems safer than
> relying on a potentially arbitrary EFLAGS saved during cpu_init.
> 
> Original i386 changeset
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=47a5c6fa0e204a2b63309c648bb2fde36836c826
> Original x86_64 changset
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=658fdbef66e5e9be79b457edc2cbbb3add840aa9
> 
> The only comment in the later indicates that it is following the
> former, but not why it differs in this way.
> 
> This change makes 64 bit use the same mechanism to setup the initial
> EFLAGS on fork. Note that 64 bit resets EFLAGS before calling
> schedule_tail() as opposed to 32 bit which calls schedule_tail()
> first. Therefore the correct value for EFLAGS has opposite IF
> bit. This will be fixed in a subsequent patch.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: x86@kernel.org

The whole series looks good to me, thanks Ian! I hope I don't
miss anything, so lets wait for more feedback ;)

	Cyrill
