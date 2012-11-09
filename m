Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2KIEpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 23:45:35 -0500
Received: from ozlabs.org ([203.10.76.45]:45081 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab2KIEpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 23:45:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Cornelia Huck <cornelia.huck@de.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: Don't access index after unregister.
In-Reply-To: <1352371427-32363-1-git-send-email-cornelia.huck@de.ibm.com>
References: <1352371427-32363-1-git-send-email-cornelia.huck@de.ibm.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 09 Nov 2012 14:54:50 +1030
Message-ID: <877gpv2yjx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:
> Virtio wants to release used indices after the corresponding
> virtio device has been unregistered. However, virtio does not
> hold an extra reference, giving up its last reference with
> device_unregister(), making accessing dev->index afterwards
> invalid.
>
> I actually saw problems when testing my (not-yet-merged)
> virtio-ccw code:
>
> - device_add virtio-net,id=xxx
> -> creates device virtio<n> with n>0
>
> - device_del xxx
> -> deletes virtio<n>, but calls ida_simple_remove with an
>    index of 0
>
> - device_add virtio-net,id=xxx
> -> tries to add virtio0, which is still in use...
>
> So let's save the index we want to release before calling
> device_unregister().

Great catch!  I've add a CC:stable.

Applied,
Rusty.
