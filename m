Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2LDP0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 10:26:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab2LDP0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 10:26:44 -0500
Message-ID: <1354634801.1809.411.camel@bling.home>
Subject: Re: [RFC PATCH 0/6] kvm: Growable memory slot array
From: Alex Williamson <alex.williamson@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Dec 2012 08:26:41 -0700
In-Reply-To: <20121204234829.65472b5ec4aedcf86cccc05f@gmail.com>
References: <20121203231912.3661.57179.stgit@bling.home>
	 <20121204234829.65472b5ec4aedcf86cccc05f@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 23:48 +0900, Takuya Yoshikawa wrote:
> On Mon, 03 Dec 2012 16:39:05 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > A couple notes/questions; in the previous version we had a
> > kvm_arch_flush_shadow() call when we increased the number of slots.
> > I'm not sure if this is still necessary.  I had also made the x86
> > specific slot_bitmap dynamically grow as well and switch between a
> > direct bitmap and indirect pointer to a bitmap.  That may have
> > contributed to needing the flush.  I haven't done that yet here
> > because it seems like an unnecessary complication if we have a max
> > on the order of 512 or 1024 entries.  A bit per slot isn't a lot of
> > overhead.  If we want to go more, maybe we should make it switch.
> 
> I have a patch set which removes the slot_bitmap in kvm mmu page
> by using reverse mappings for write protecting a memslot.
> 
> A bit of concern I still have is the total write protection time
> for large memslots.  But since this approach allows us to control
> mmu_lock hold time, I think this is a reasonable trade-off.
> ... and this should be much better than introducing any complication
> for slot_bitmap handling.

Great!  A bi-modal bitmap would be rather ugly, so I look forward to
your patches to remove it entirely ;)  Thanks,

Alex

