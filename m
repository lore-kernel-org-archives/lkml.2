Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0CaAHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:07:54 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61267 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab0C3XSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=gxTeqJ1H/C3BP/RgirmszutGF8KzpiQ0tbT24kjggAZFAk38lmOab4AaQQ1bNq4/ka
         9j3hPSbiRwdAUw3z6ra5HbdwgombQgepdW7xNgID2Ux8QudGdXH8BM4RrEBHxloJHEUY
         ZOTu9llRKaShryeZkYJWpbXIM5Yl97V50TDQM=
Date: Wed, 31 Mar 2010 01:18:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: x86: fix callgraphs of 32-bit processes on
	64-bit kernels V4.
Message-ID: <20100330231819.GB5817@nowhere>
References: <1268815776-29501-1-git-send-email-edwintorok@gmail.com> <1268820436-13145-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1268820436-13145-1-git-send-email-edwintorok@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 12:07:16PM +0200, Török Edwin wrote:
> When profiling a 32-bit process on a 64-bit kernel, callgraph tracing
> stopped after the first function, because it has seen a garbage memory address
> (tried to interpret the frame pointer, and return address as a 64-bit pointer).
> 
> Fix this by using a struct stack_frame with 32-bit pointers when the TIF_IA32 flag is set.
> 
> Note that TIF_IA32 flag must be used, and not is_compat_task(), because the
> latter is only set when the 32-bit process is executing a syscall,
> which may not always be the case (when tracing page fault events for example).
> 
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Török Edwin <edwintorok@gmail.com>


Queued, thanks!

