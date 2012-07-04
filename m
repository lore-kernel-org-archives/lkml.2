Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab2GDEIF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 00:08:05 -0400
Received: from ozlabs.org ([203.10.76.45]:51996 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab2GDEHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 00:07:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH RFC] virtio-balloon: fix add/get API use
In-Reply-To: <20120702073308.GB8268@redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6> <f3831c1617c86a51d875.1320306173@localhost6.localdomain6> <20120701092051.GA4515@redhat.com> <87d34fx990.fsf@rustcorp.com.au> <20120702073308.GB8268@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 04 Jul 2012 12:57:40 +0930
Message-ID: <87ipe4w6hf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 10:33:08 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> In virtio balloon virtqueue_get_buf might now run concurrently with
> virtqueue_kick.  I audited both and this seems safe in practice but
> this is not guaranteed by the API.
> Additionally, a spurious interrupt might in theory make
> virtqueue_get_buf run in parallel with virtqueue_add_buf, which is racy.
> 
> While we might try to protect against spurious callbacks it's
> easier to fix the driver: balloon seems to be the only one
> (mis)using the API like this, so let's just fix balloon.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

I was thinking of a spinlock, but this is far more elegant.

And I added an explicit reference to the 'virtio: expose added
descriptors immediately.' commit in your commit msg.

Kudos!
Rusty.
