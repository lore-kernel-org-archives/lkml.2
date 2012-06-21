Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab2FUMMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:12:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40163 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab2FUMMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:12:33 -0400
Message-ID: <1340280742.18025.5.camel@twins>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date: Thu, 21 Jun 2012 14:12:22 +0200
In-Reply-To: <1340280437-7718-2-git-send-email-bp@amd64.org>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
	 <1340280437-7718-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 14:07 +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Microcode reloading in a per-core manner is a very bad idea for both
> major x86 vendors. And the thing is, we have such interface with which
> we can end up with different microcode versions applied on different
> cores of an otherwise homogeneous wrt (family,model,stepping) system.
> 
> So turn off the possibility of doing that per core and allow it only
> system-wide.
> 
> This is a minimal fix which we'd like to see in stable too thus the
> more-or-less arbitrary decision to allow system-wide reloading only on
> the BSP:
> 
> $ echo 1 > /sys/devices/system/cpu/cpu0/microcode/reload
> ...
> 
> and disable the interface on the other cores:
> 
> $ echo 1 > /sys/devices/system/cpu/cpu23/microcode/reload
> -bash: echo: write error: Invalid argument
> 
> Also, allowing the reload only from one CPU (the BSP in
> that case) doesn't allow the reload procedure to degenerate
> into an O(n^2) deal when triggering reloads from all
> /sys/devices/system/cpu/cpuX/microcode/reload sysfs nodes
> simultaneously.
> 
> A more generic fix will follow.
> 
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Peter Zijlstra <peterz@infradead.org> 
