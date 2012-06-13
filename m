Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2FMJZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:25:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab2FMJZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:25:44 -0400
Date: Wed, 13 Jun 2012 12:26:05 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv6 2/8] kvm: optimize ISR lookups
Message-ID: <20120613092604.GA17828@redhat.com>
References: <cover.1338474301.git.mst@redhat.com>
 <d054c34a0765aee4e4f751bde73615befa33cc87.1338474301.git.mst@redhat.com>
 <20120612210833.GA639@amt.cnet>
 <20120613090242.GA17357@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613090242.GA17357@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 12:02:42PM +0300, Michael S. Tsirkin wrote:
> > Instead of isr_cache what about a highest_isr field?
> 
> > 
> > When setting ISR:
> > 
> > if (apic->highest_isr < me)
> > 	apic->highest_isr = me;
> > 
> > To be invalidated on TPR updates properly.
> > 
> > Its more meaningful.
> 
> OK, I'll rename it highest_isr

Even better - highest_isr_cache.
Makes it explicit that it can be invalid.

-- 
MST
