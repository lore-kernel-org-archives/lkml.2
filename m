Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1BPQM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:12:28 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:26370 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1BPQMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:12:25 -0500
X-IronPort-AV: E=Sophos;i="4.60,480,1291611600"; 
   d="scan'208";a="136169527"
Subject: Re: Xen and incorporating event channels in to nr_irqs
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: xen-devel <xen-devel@lists.xensource.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.1102161638320.2701@localhost6.localdomain6>
References: <1297868399.16356.180.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102161638320.2701@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 16 Feb 2011 16:12:19 +0000
Message-ID: <1297872739.16356.261.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-16 at 15:56 +0000, Thomas Gleixner wrote:
> I'm about to remove the nr_irqs NR_IRQS limitation. It's silly when we
> deal with sparse irqs. So the idea is to have the initial nr_irqs set
> in early boot to have a sensible size for allocating stuff. Later on
> we can expand nr_irqs when the need arises.

> It's not only Xen which wants to eliminate the limitation. Think about
> irq expanders which are detected late in the boot. We have no sensible
> way to reserve enough numbers for them at early boot as we dont know
> whether that hardware is there or not.
> 
> So my plan for .39 is to ignore the NR_IRQS limitation in the sparse
> case and make nr_irqs expandable of course with a sensible upper limit
> in the core code itself. It's basically the allocation bitmap which
> limits it, but I doubt we'll hit 1 Million irq numbers in the
> forseeable future.

That sounds ideal, thanks! 

I was hoping to get rid of the workaround in Xen events.c in the 2.6.39
timeframe too.

If you let me know when you have something I can test I'll combine with
the Xen side and give it a spin.

On a vaguely related note, what is the future of non-sparse IRQs (on x86
and/or generally)?

Ian.

