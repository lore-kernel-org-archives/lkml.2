Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2DNBcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 21:32:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab2DNBcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 21:32:11 -0400
Date: Fri, 13 Apr 2012 22:25:39 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: dont clear TMR on EOI
Message-ID: <20120414012539.GA9043@amt.cnet>
References: <20120411154953.GA24008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120411154953.GA24008@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 06:49:55PM +0300, Michael S. Tsirkin wrote:
> Intel spec says that TMR needs to be set/cleared
> when IRR is set, but kvm also clears it on  EOI.
> 
> I did some tests on a real (AMD based) system,
> and I see same TMR values both before
> and after EOI, so I think it's a minor bug in kvm.
> 
> This patch fixes TMR to be set/cleared on IRR set
> only as per spec.
> 
> And now that we don't clear TMR, we can save
> an atomic read of TMR on EOI that's not propagated
> to ioapic, by checking whether ioapic needs
> a specific vector first and calculating
> the mode afterwards.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/x86/kvm/lapic.c |   19 +++++++++++++------
>  virt/kvm/ioapic.c    |   10 +++++++---
>  virt/kvm/ioapic.h    |    1 +
>  3 files changed, 21 insertions(+), 9 deletions(-)

Applied, thanks.

