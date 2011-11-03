Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1KCIf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 04:35:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34945 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1KCIfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 04:35:22 -0400
Subject: Re: virtio-pci new configuration proposal
From: Sasha Levin <levinsasha928@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <8762j2t19l.fsf@rustcorp.com.au>
References: <1320259767.22582.2.camel@lappy>
	 <8762j2t19l.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 03 Nov 2011 10:33:23 +0200
Message-ID: <1320309203.29407.1.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 12:28 +1030, Rusty Russell wrote: 
> On Wed, 02 Nov 2011 20:49:27 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> > This is a proposal for a new layout of the virtio-pci config space.
> > 
> > We will separate the current configuration into two: A virtio-pci common
> > configuration and a device specific configuration. This allows more flexibility
> > with adding features and makes usage easier, specifically in cases like the
> > ones in virtio-net where device specific configurations depend on device
> > specific features.
> 
> Thanks for this Sasha.  Several general comments:
> 
> 1) How to we distinguish the two layouts?  In theory, we need to do this
>    forever.  In practice we can deprecate the old layout in several
>    years' time.

Old layouts won't have the new virtio-pci cap structure in their PCI
config space.

> 2) I don't think we want to turn the device-specific config into a
>    linked list.  We haven't needed variable-length config (yet!), and
>    it's (slightly) more complex.  That's also the part of the spec which
>    is shared with non-PCI virtio implementations.

Variable length config wasn't used yet because space in the device
specific space was reserved for a feature even if that feature wasn't
used.

For example, the MAC feature reserved 6 bytes in the config space for
the MAC even if VIRTIO_NET_F_MAC wasn't enabled. Here we can just avoid
having it pollute the config space until it's enabled.

I don't think it'll have any impact on non-PCI implementations since the
"pointers" are simply offsets from the beginning of the config space,
and are not PCI specific in any way.

> 3) If we're changing the queue layout, it's a chance to fix a
>    longstanding bug: let the guest notify the host of preferred
>    queue size and alignment.

Yup, we can do that.

-- 

Sasha.


