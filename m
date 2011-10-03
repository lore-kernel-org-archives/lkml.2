Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab1JCIsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:48:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49066 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab1JCIr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:47:58 -0400
Date: Mon, 3 Oct 2011 10:47:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111003084754.GB4411@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, mingo@elte.hu,
	hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <4E88B5E0.6080503@linux.vnet.ibm.com>
 <20111002195023.GC31799@mtj.dyndns.org>
 <4E88C3D4.2020300@linux.vnet.ibm.com>
 <20111003004051.GD31799@mtj.dyndns.org>
 <4E894D75.808@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E894D75.808@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srivatsa,

On Mon, Oct 03, 2011 at 11:21:49AM +0530, Srivatsa S. Bhat wrote:
> So my one-liner patch here tries to solve this problem by not
> invalidating the microcode at all, to handle the corner case of a CPU
> hotplug going on in parallel with freezer operations. But it creates
> issues with the usecase you described.

I think your patch makes sense because re-loading the ucode during
a suspend/resume cycle is unnecessary. If one wants to update the
microcode, it should happen later when the box is resumed again: you
simply put the new microcode image in /lib/firmware/... and on AMD
unload/reload the microcode module and on Intel you do either that or
use the deprecated microcode_ctl.

However, let me test it on a couple of AMD boxes tomorrow to verify.

> At the moment I can't think of any clean solution that solves both these problems - 
>   a. The problem of requesting microcode from userspace when it is frozen (which can be individually
>      solved by my patch).
>   b. The possible need for a revised microcode during CPU online (due to the remote usecase of 
>      physically plugging-out and plugging-in a new CPU), when the tasks are frozen.

Yeah, let me remind you guys, we're talking about x86 CPUs here. AFAICT,
I don't think that physical unplug is supported by any vendor yet but
I'd welcome surprises :-).

Thanks.

-- 
Regards/Gruss,
    Boris.
