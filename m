Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0EFKAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:00:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753302Ab0EFKAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:00:44 -0400
Message-ID: <4BE29320.5090506@redhat.com>
Date: Thu, 06 May 2010 13:00:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] [PATCH RFC] virtio: put last seen used index into
 ring	itself
References: <20100505205814.GA7090@redhat.com>
In-Reply-To: <20100505205814.GA7090@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2010 11:58 PM, Michael S. Tsirkin wrote:
> +	/* We publish the last-seen used index at the end of the available ring.
> +	 * It is at the end for backwards compatibility. */
> +	vr->last_used_idx =&(vr)->avail->ring[num];
> +	/* Verify that last used index does not spill over the used ring. */
> +	BUG_ON((void *)vr->last_used_idx +
> +	       sizeof *vr->last_used_idx>  (void *)vr->used);
>   }
>    

Shouldn't this be on its own cache line?

One way to achieve this is to allocate it at the end.

-- 
error compiling committee.c: too many arguments to function

