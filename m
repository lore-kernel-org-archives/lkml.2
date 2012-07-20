Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab2GTTW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 15:22:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab2GTTWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 15:22:54 -0400
Date: Fri, 20 Jul 2012 16:04:54 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] kvm: fix race with level interrupts
Message-ID: <20120720190454.GA24024@amt.cnet>
References: <20120719104520.GA14748@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120719104520.GA14748@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2012 at 01:45:20PM +0300, Michael S. Tsirkin wrote:
> When more than 1 source id is in use for the same GSI, we have the
> following race related to handling irq_states race:
> 
> CPU 0 clears bit 0. CPU 0 read irq_state as 0. CPU 1 sets level to 1.
> CPU 1 calls kvm_ioapic_set_irq(1). CPU 0 calls kvm_ioapic_set_irq(0).
> Now ioapic thinks the level is 0 but irq_state is not 0.
> 
> Fix by performing all irq_states bitmap handling under pic/ioapic lock.
> This also removes the need for atomics with irq_states handling.
> 
> Reported-by: Gleb Natapov <gleb@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Applied, thanks.

> Changes from v1:
> 	Address comments by Gleb and Alex:
> 		renamed some variables for clarify
> 		renamed kvm_irq_line_state ->  __kvm_irq_line_state
> 
> Any chance we can put this in 3.5? I know level IRQs are not widely
> used, which is likely why this went unnoticed for so long, but still ...

http://yarchive.net/comp/linux/merge_window.html

"From: Linus Torvalds <torvalds@linux-foundation.org>

The thing is, I don't take bug fixes late in the -rc just because they
are bug fixes.

And I really shouldn't.

If it's an old bug, and doesn't cause an oops or a security issue, it
had damn well better wait for the next merge window. There is absolutely
_no_ reason to just blindly "fix bugs" at the end of the rc stage,
because quite frankly, the risks coming from fixing a bug is often
bigger than the advantage.
"

