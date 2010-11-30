Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0K3SW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:22:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45912 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab0K3SWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m25jeh4mRldHKH2JH5Th05u5lScxPBAmoaQObFAB/pl/+MQdpZzXjXcGpg+lEtWqZk
         4LxskmUzAcVaeiMLyNLbI1Ha2WJZFLDabAZ3sPl27ID+nyahU2+HzRPjwYHrdX+yRbZc
         EI11HfEXHUEDnQPS00oX/Agzy9YY3IKWsLPPU=
Date: Tue, 30 Nov 2010 21:22:51 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org, brgerst@gmail.com, penberg@kernel.org
Subject: Re: [PATCH UPDATED#2 04/16] x86: Use local variable to cache
	smp_processor_id() in setup_local_APIC()
Message-ID: <20101130182251.GC20818@lenovo>
References: <1290871325-3055-1-git-send-email-tj@kernel.org> <1290871325-3055-5-git-send-email-tj@kernel.org> <4CF53E61.1030307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF53E61.1030307@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 07:11:45PM +0100, Tejun Heo wrote:
> This is a trivial clean up.
> 
> * Move initialization of @cpu inside preemption disabled region as
>   suggested by Cyrill Gorcunov.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> Alright, updated yet again, but I frankly don't see the point in these

code structure, if we would be referring variable taken inside preempt
off this always look suspicious, i think you agree with me :)

> changes.  If setup_local_APIC() is being run from a different CPU, we
> have a much larger problem.  We're already accessing cpu local
> resources (tsc, lapic) outside of preemption disabled area.  But,
> anyways, I don't think it matters one way or the other.
> 
> Thanks.
> 
