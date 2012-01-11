Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2AKBbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:31:06 -0500
Received: from ozlabs.org ([203.10.76.45]:48312 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409Ab2AKBbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:31:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mike Waychison <mikew@google.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, earhart@google.com,
        virtualization@lists.linux-foundation.org, digitaleric@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] virtio_net: Split receive buffer alloc/add
In-Reply-To: <20120110174100.4505.8939.stgit@mike2.sea.corp.google.com>
References: <20120110174052.4505.66514.stgit@mike2.sea.corp.google.com> <20120110174100.4505.8939.stgit@mike2.sea.corp.google.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 11 Jan 2012 12:00:25 +1030
Message-ID: <8739bn6n66.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012 09:41:01 -0800, Mike Waychison <mikew@google.com> wrote:
> In preparation for allocating receive buffers in the slow path without
> disabling NAPI, split the allocation and addition of receive buffers
> apart into two separate functions (per receive buffer type).
> 
> While here, move the vi->num accounting into the add functions.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>

Hi Mike...

        This exposes a nasty ugliness in the way virtio_net works.  We
allocate an skbuff for the small packet case, and just allocate the
pages for the large packet cases, and alloc the skbuff when we fill the
pages.

        I think all the allocators should return a populated skbuff;
this uses a bit more memory in theory, but should make the code simpler.
As an added bonus, your life should get much simpler for these patches.

I'll try to create such a patch tonight, but I'm busy finalizing my
linux.conf.au presentation, so it might take longer :(

Thanks,
Rusty.
