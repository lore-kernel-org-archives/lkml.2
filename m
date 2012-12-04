Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2LDOsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:48:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54311 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2LDOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:48:33 -0500
Date: Tue, 4 Dec 2012 23:48:29 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] kvm: Growable memory slot array
Message-Id: <20121204234829.65472b5ec4aedcf86cccc05f@gmail.com>
In-Reply-To: <20121203231912.3661.57179.stgit@bling.home>
References: <20121203231912.3661.57179.stgit@bling.home>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Dec 2012 16:39:05 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> A couple notes/questions; in the previous version we had a
> kvm_arch_flush_shadow() call when we increased the number of slots.
> I'm not sure if this is still necessary.  I had also made the x86
> specific slot_bitmap dynamically grow as well and switch between a
> direct bitmap and indirect pointer to a bitmap.  That may have
> contributed to needing the flush.  I haven't done that yet here
> because it seems like an unnecessary complication if we have a max
> on the order of 512 or 1024 entries.  A bit per slot isn't a lot of
> overhead.  If we want to go more, maybe we should make it switch.

I have a patch set which removes the slot_bitmap in kvm mmu page
by using reverse mappings for write protecting a memslot.

A bit of concern I still have is the total write protection time
for large memslots.  But since this approach allows us to control
mmu_lock hold time, I think this is a reasonable trade-off.
... and this should be much better than introducing any complication
for slot_bitmap handling.

Thanks,
	Takuya
