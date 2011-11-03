Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab1KCDwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:52:10 -0400
Received: from ozlabs.org ([203.10.76.45]:43725 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab1KCDwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:52:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: virtio-pci new configuration proposal
In-Reply-To: <1320259767.22582.2.camel@lappy>
References: <1320259767.22582.2.camel@lappy>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 03 Nov 2011 12:28:46 +1030
Message-ID: <8762j2t19l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Nov 2011 20:49:27 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> This is a proposal for a new layout of the virtio-pci config space.
> 
> We will separate the current configuration into two: A virtio-pci common
> configuration and a device specific configuration. This allows more flexibility
> with adding features and makes usage easier, specifically in cases like the
> ones in virtio-net where device specific configurations depend on device
> specific features.

Thanks for this Sasha.  Several general comments:

1) How to we distinguish the two layouts?  In theory, we need to do this
   forever.  In practice we can deprecate the old layout in several
   years' time.

2) I don't think we want to turn the device-specific config into a
   linked list.  We haven't needed variable-length config (yet!), and
   it's (slightly) more complex.  That's also the part of the spec which
   is shared with non-PCI virtio implementations.

3) If we're changing the queue layout, it's a chance to fix a
   longstanding bug: let the guest notify the host of preferred
   queue size and alignment.

Cheers,
Rusty.
