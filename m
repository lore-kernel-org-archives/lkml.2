Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348Ab0JLV2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:28:49 -0400
Received: from www.tglx.de ([62.245.132.106]:46479 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab0JLV2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:28:48 -0400
Date: Tue, 12 Oct 2010 23:28:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] x86: Sanitize apb timer interrupt handling
In-Reply-To: <20101012142000.00001358@unknown>
Message-ID: <alpine.LFD.2.00.1010122327260.2909@localhost6.localdomain6>
References: <tip-a5ef2e70405c8a9ee380b5ff33a008c75454791f@git.kernel.org> <20101012142000.00001358@unknown>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Jacob Pan wrote:

> 
> >x86: Sanitize apb timer interrupt handling
> >
> >Disable the interrupt in CPU_DEAD where it belongs.
> My main concern is the performance cost. The power management code for
> Moorestown system make use of the cpu hotplug code (disable_nonboot_cpus)
> but much more frequently. The system low power states are call S0 idle
> state (s0ix).
> 
> Leaving the irq enabled at the chip and desc level between S0ix states
> might give some performance benefit. That was my original thought.
> Will it cause problems?

Errm. I merily moved it to the place where it should be. You do the
disable/enable dance already today.

Thanks,

	tglx
