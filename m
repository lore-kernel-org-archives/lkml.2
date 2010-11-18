Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332Ab0KRUDN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:03:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab0KRUDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:03:12 -0500
Date: Thu, 18 Nov 2010 15:02:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] x86, nmi_watchdog: Remove the old nmi_watchdog
Message-ID: <20101118200250.GB8131@redhat.com>
References: <1289578944-28564-2-git-send-email-dzickus@redhat.com>
 <tip-5f2b0ba4d94b3ac23cbc4b7f675d98eb677a760a@git.kernel.org>
 <4CE57A4A.30200@kernel.org>
 <4CE58106.5070009@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE58106.5070009@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:39:50AM -0800, Yinghai Lu wrote:
> > 
> > Please update the kernel-parameters.txt accordingly.
> > 
> > and you need to keep unknown_nmi_panic or else as early_param().
> > 
> > Also any corresponding part like "nmi_watchdog=off" ?
> > 
> 
> also you have some other left-over...
> 
> Documentation/kernel-parameters.txt:    unknown_nmi_panic
> Documentation/kernel-parameters.txt:                    Set unknown_nmi_panic=1 early on boot.
> Documentation/sysctl/kernel.txt:- unknown_nmi_panic
> Documentation/sysctl/kernel.txt:unknown_nmi_panic:
> arch/x86/include/asm/nmi.h:extern int unknown_nmi_panic;
> arch/x86/kernel/apic/hw_nmi.c:int unknown_nmi_panic;
> kernel/sysctl_binary.c: { CTL_INT,      KERN_UNKNOWN_NMI_PANIC,         "unknown_nmi_panic" },
> 
> may still have left for nmi_watchdog too.

Yes the first part of the patch left in stubs.  The second piece should
clean up stuff like nmi_watchdog.

On the other side unknown_nmi_panic is actually going to be added back in
with another patch that re-arranges the default_do_nmi() call that I
posted in another patch series.

Cheers,
Don
