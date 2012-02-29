Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030995Ab2B2OSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 09:18:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59993 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab2B2OSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 09:18:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of takuya.yoshikawa@gmail.com designates 10.68.203.135 as permitted sender) smtp.mail=takuya.yoshikawa@gmail.com; dkim=pass header.i=takuya.yoshikawa@gmail.com
Date: Wed, 29 Feb 2012 23:18:26 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, mtosatti@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
Message-Id: <20120229231826.2b257637368d6e9139054bec@gmail.com>
In-Reply-To: <4F4E1999.3060303@redhat.com>
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
	<20120223203541.f51c11c9.yoshikawa.takuya@oss.ntt.co.jp>
	<4F4CBEAA.5030708@redhat.com>
	<20120229164934.745d08f5.yoshikawa.takuya@oss.ntt.co.jp>
	<4F4DEEFA.6000506@redhat.com>
	<20120229191623.d1edb0aa.yoshikawa.takuya@oss.ntt.co.jp>
	<4F4E1999.3060303@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> > We cannot get a complete snapshot without mmu_lock; if the guest faults on
> > the Nth page during xchg'ing i = 1, 2, ... then the i = N alone will
> > become newer.
> 
> Ah, so there is no data corruption (missed dirty bits), just the display
> is updated inconsistently?

Yes, no data corruption and just a matter of ... feeling.

The basic rule I wrote in the comment in this patch should be enough to
not lose dirty bits.

> I don't think we can get a consistent snapshot anyway, since the guest
> can update the framebuffer while userspace is processing it.

Yes, nothing will be broken.  I was just not sure what the API should promise
to the userspace.

To some extent the inconsistency may be felt more than before.

> Understood.  I don't think we can get a consistent vga snapshot without
> stopping the guest, and even then, it depends on how the guest updates
> the framebuffer.

OKay, I will not care about this from now.

> > So I want to see how much improvement the proposed API can achieve.
> >
> > I thought this might be a good GSoC project but ...
> 
> It may be too involved for GSoC, the issues are difficult.

I am now checking QEMU code closely - rather readable than before!

Though I can make experimental KVM patches for the student, just changing
QEMU's live migration code seems to be difficult - but not sure now.

Anyway, we should try this before deciding the new API: I mean if I cannot
find anyone who want to try this, no need to be a student, I may do instead
at some point.

	Takuya
