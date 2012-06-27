Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811Ab2F0Jt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:49:26 -0400
Received: from ozlabs.org ([203.10.76.45]:45850 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab2F0JtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:49:24 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, Frank Swiderski <fes@google.com>
Cc: riel@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mikew@google.com
Subject: Re: [PATCH] Add a page cache-backed balloon device driver.
In-Reply-To: <20120626214106.GC14054@redhat.com>
References: <1340742778-11282-1-git-send-email-fes@google.com> <20120626214106.GC14054@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 27 Jun 2012 12:26:55 +0930
Message-ID: <87lij91myw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 00:41:06 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Tue, Jun 26, 2012 at 01:32:58PM -0700, Frank Swiderski wrote:
> > This implementation of a virtio balloon driver uses the page cache to
> > "store" pages that have been released to the host.  The communication
> > (outside of target counts) is one way--the guest notifies the host when
> > it adds a page to the page cache, allowing the host to madvise(2) with
> > MADV_DONTNEED.  Reclaim in the guest is therefore automatic and implicit
> > (via the regular page reclaim).  This means that inflating the balloon
> > is similar to the existing balloon mechanism, but the deflate is
> > different--it re-uses existing Linux kernel functionality to
> > automatically reclaim.
> > 
> > Signed-off-by: Frank Swiderski <fes@google.com>
> 
> I'm pondering this:
> 
> Should it really be a separate driver/device ID?
> If it behaves the same from host POV, maybe it
> should be up to the guest how to inflate/deflate
> the balloon internally?

Well, it shouldn't steal ID 10, either way :)  Either use a completely
bogus number, or ask for an id.

But AFAICT this should be a an alternate driver of for the same device:
it's not really a separate device, is it?

Cheers,
Rusty.
