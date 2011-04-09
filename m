Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1DJAmG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 20:42:06 -0400
Received: from ozlabs.org ([203.10.76.45]:54454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1DJAmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 20:42:03 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] virtio balloon: kill tell-host-first logic
In-Reply-To: <20110407174325.ED21C82B@kernel>
References: <20110407174325.ED21C82B@kernel>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Sun, 10 Apr 2011 08:18:22 +0930
Message-ID: <87ei5bdosp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Apr 2011 10:43:25 -0700, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
> The virtio balloon driver has a VIRTIO_BALLOON_F_MUST_TELL_HOST
> feature bit.  Whenever the bit is set, we must always tell the
> host before we free pages back to the allocator.  Without this
> we might free a page (and have another user touch it) while the
> hypervisor is unprepared for it.
> 
> But, if the bit is _not_ set, we are under no obligation to
> reverse the order.  Furthermore, all modern qemus set this bit.
> So, the "tell second" code is completely unused and untestable.
> Quoting Anthony: "untested code is broken code".
> 
> This _also_ means that we don't have to preserve a pfn list
> after the pages are freed, which should let us get rid of some
> temporary storage (vb->pfns) eventually.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Thanks, applied!

Rusty.
