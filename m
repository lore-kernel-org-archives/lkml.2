Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab0K0Vcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 16:32:43 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44423 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0K0Vcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 16:32:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qTqTIPIWmO5v8vzT6lmLIMF4cAUQmN7Czj4bL91RhGFB1hclkc6zVdkvB5mgWeE2lq
         bWYluywE88OTP2VLX7GZ757dfOgZjaIL4dN6OCx/YCcu4SdUcLuyZMAZAWn5lzgJMiez
         rvGy+WXJKRKlOpNRl2/UM6hPZbWzSJC+q5ja8=
Date: Sun, 28 Nov 2010 00:32:36 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, penberg@kernel.org
Subject: Re: [PATCH 04/16] x86: Use local variable to cache
	smp_processor_id() in setup_local_APIC()
Message-ID: <20101127213236.GA10123@lenovo>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290871325-3055-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 04:21:53PM +0100, Tejun Heo wrote:
> This is a trivial clean up.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/kernel/apic/apic.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 

 Hi Tejun, I belive we should put in change log that it's
not a trivial change. The cpu gets cached before preemption
disabled and used after preemption enabled, which is not
1:1 like it was before.

 Though at moment all setup_local_APIC callers have preemption
disabled this might be changed in future and heck knows what side
effect we would have :)

 Perhaps the easiest would be to make cpu = smp_processor_id()
after preempt_disable() call and leave the last snippet in this
function

#ifdef CONFIG_X86_MCE_INTEL
	/* Recheck CMCI information after local APIC is up on CPU #0 */
	if (smp_processor_id() == 0)
		cmci_recheck();
#endif

untouched.

 On the other hands I might be too paranoid ;)

  Cyrill
