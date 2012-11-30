Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab2K3S5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:57:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35830 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2K3S5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:57:33 -0500
Message-ID: <50B90181.4070705@zytor.com>
Date: Fri, 30 Nov 2012 10:57:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vincent Palatin <vpalatin@chromium.org>
CC: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Duncan Laurie <dlaurie@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] x86, fpu: avoid FPU lazy restore after suspend
References: <1354301523-5252-1-git-send-email-vpalatin@chromium.org> <1354301523-5252-2-git-send-email-vpalatin@chromium.org>
In-Reply-To: <1354301523-5252-2-git-send-email-vpalatin@chromium.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 10:52 AM, Vincent Palatin wrote:
> When a cpu enters S3 state, the FPU state is lost.
> After resuming for S3, if we try to lazy restore the FPU for a process running
> on the same CPU, this will result in a corrupted FPU context.
> 
> We can just invalidate the "fpu_owner_task", so nobody will try to
> lazy restore a state which no longer exists in the hardware.
> 
> Tested with a 64-bit kernel on a 4-core Ivybridge CPU with eagerfpu=off,
> by doing thousands of suspend/resume cycles with 4 processes doing FPU
> operations running. Without the patch, a process is killed after a
> few hundreds cycles by a SIGFPE.
> 
> The issue seems to exist since 3.4 (after the FPU lazy restore was actually implemented),
> to apply the change to 3.4, "this_cpu_write" needs to be replaced by percpu_write.
> 
> Cc: Duncan Laurie <dlaurie@chromium.org>
> Cc: Olof Johansson <olofj@chromium.org>
> Cc: <stable@kernel.org> [v3.4+] # for 3.4 need to replace this_cpu_write by percpu_write
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>

Ouch!  Thank you for catching this!

	-hpa


