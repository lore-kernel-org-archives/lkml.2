Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2LYFZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 00:25:40 -0500
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:49966 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2LYFZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 00:25:38 -0500
Date: Tue, 25 Dec 2012 14:26:09 +0900
From: Takuya Yoshikawa <yoshikawa_takuya_b1@lab.ntt.co.jp>
To: Gleb Natapov <gleb@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] KVM: Write protect the updated slot only when we
 start dirty logging
Message-Id: <20121225142609.b586df5e.yoshikawa_takuya_b1@lab.ntt.co.jp>
In-Reply-To: <20121225050555.GD29007@redhat.com>
References: <20121218162558.65a8bfd3.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121218162647.009f468e.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121224132717.GW17584@redhat.com>
	<20121225130840.74996653.yoshikawa_takuya_b1@lab.ntt.co.jp>
	<20121225050555.GD29007@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Dec 2012 07:05:55 +0200
Gleb Natapov <gleb@redhat.com> wrote:

> > Other parts are doing "if (!slot->dirty_bitmap)" to see if the slot
> > is in dirty logging mode.  If you prefer, we can do the same here.
> > 
> Does not matter to me. If you think it will be more consistent do it.

No preference at the moment.  But since .dirty_bitmap and .rmap may be
changed to control free_physmem(new, old) behaviour, I'll keep the code
as is.

I'll send some patches to clean up the current "mem, new, old, slot"
games in __kvm_set_memory_region() later.  I was confused many times
by these.

In addition, passing old slot by value to kvm_arch_commit_memory_region()
should be fixed as well.  The structure is too big to copy.

Thanks,
	Takuya
