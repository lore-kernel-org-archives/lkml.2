Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab1EEIeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 04:34:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57342 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1EEIer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 04:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cG7IeQAf8iyK0KeamEhDPK4VVLl4vZRxsxW6emwYpXLwDGYqvxLY0h+dThT4gdVR7x
         X9PDy2UkcqrrGuEFz3YOwO/JV0r5XQGYMaMMK7WC9b+szVE9wqsaA0o/3bFMXXwk7/50
         U2c3t6KwxBITF4pxRbkX6hl3m9U+bbrH6fdkQ=
MIME-Version: 1.0
In-Reply-To: <cc4596a5ecdbf8dd37b5567a36667e3841f18ca3.1304541919.git.mst@redhat.com>
References: <cover.1304541918.git.mst@redhat.com>
	<cc4596a5ecdbf8dd37b5567a36667e3841f18ca3.1304541919.git.mst@redhat.com>
Date: Thu, 5 May 2011 09:34:46 +0100
Message-ID: <BANLkTi=eH-iK7L2LBAm0eqidapqXqhSqxw@mail.gmail.com>
Subject: Re: [PATCH 07/18] virtio ring: inline function to check for events
From: Stefan Hajnoczi <stefanha@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Krishna Kumar <krkumar2@in.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, lguest@lists.ozlabs.org,
        Shirley Ma <xma@us.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        virtualization@lists.linux-foundation.org, steved@us.ibm.com,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 9:51 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> With the new used_event and avail_event and features, both
> host and guest need similar logic to check whether events are
> enabled, so it helps to put the common code in the header.
>
> Note that Xen has similar logic for notification hold-off
> in include/xen/interface/io/ring.h with req_event and req_prod
> corresponding to event_idx + 1 and new_idx respectively.
> +1 comes from the fact that req_event and req_prod in Xen start at 1,
> while event index in virtio starts at 0.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_ring.h |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index f791772..2a3b0ea 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -124,6 +124,20 @@ static inline unsigned vring_size(unsigned int num, unsigned long align)
>                + sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
>  }
>
> +/* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */
> +/* Assuming a given event_idx value from the other size, if

s/other size/other side/ ?

Stefan
