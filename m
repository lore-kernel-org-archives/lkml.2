Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab1ETEN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:13:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1ETEN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:13:57 -0400
Date: Fri, 20 May 2011 00:09:03 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, daniel.blueman@gmail.com,
        suresh.b.siddha@intel.com, <stable@kernel.org>
Subject: Re: [patch 1/9] x86, ioapic: fix potential resume deadlock
Message-ID: <20110520000903.2d8d05a4@katamari>
In-Reply-To: <20110518233157.385970138@sbsiddha-MOBL3.sc.intel.com>
References: <20110518233130.524634928@sbsiddha-MOBL3.sc.intel.com>
	<20110518233157.385970138@sbsiddha-MOBL3.sc.intel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 16:31:31 -0700
Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> From: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> Fix a potential deadlock when resuming; here the calling function
> has disabled interrupts, so we cannot sleep.
> 
> Change the memory allocation flag from GFP_KERNEL to GFP_ATOMIC.
> 
> TODO: We can do away with this memory allocation during resume by
> reusing the ioapic suspend/resume code that uses boot time allocated
> buffers.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Cc: <stable@kernel.org>     # v2.6.39

This is happening on 2.6.38 as well.
