Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0I0Kbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 06:31:31 -0400
Received: from 8bytes.org ([88.198.83.132]:35010 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab0I0Kba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 06:31:30 -0400
Date: Mon, 27 Sep 2010 12:31:29 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86, nmi: workaround sti; hlt race vs nmi; intr
Message-ID: <20100927103128.GO15338@8bytes.org>
References: <1284913699-14986-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284913699-14986-1-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 06:28:19PM +0200, Avi Kivity wrote:
> On machines without monitor/mwait we use an sti; hlt sequence to atomically
> enable interrupts and put the cpu to sleep.  The sequence uses the "interrupt
> shadow" property of the sti instruction: interrupts are enabled only after
> the instruction following sti has been executed.  This means an interrupt
> cannot happen in the middle of the sequence, which would leave us with
> the interrupt processed but the cpu halted.
> 
> The interrupt shadow, however, can be broken by an nmi; the following
> sequence
> 
>    sti
>      nmi ... iret
>      # interrupt shadow disabled
>      intr ... iret
>    hlt
> 
> puts the cpu to sleep, even though the interrupt may need additional
> processing after the hlt (like scheduling a task).

Doesn't the interrupt return path check for a re-schedule condition
before iret? So to my believe the handler would not jump back to the
idle task if something else becomes running in the interrupt handler,
no?

	Joerg

