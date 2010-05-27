Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219Ab0E0MIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 08:08:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754767Ab0E0MIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 08:08:19 -0400
Message-ID: <4BFE6098.9010000@redhat.com>
Date: Thu, 27 May 2010 15:07:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       qemu-devel@nongnu.org
Subject: Re: [PATCHv2-RFC 0/2] virtio: put last seen used index into ring
 itself
References: <cover.1274903328.git.mst@redhat.com>
In-Reply-To: <cover.1274903328.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2010 10:50 PM, Michael S. Tsirkin wrote:
> Here's a rewrite of the original patch with a new layout.
> I haven't tested it yet so no idea how this performs, but
> I think this addresses the cache bounce issue raised by Avi.
> Posting for early flames/comments.
>
> Generally, the Host end of the virtio ring doesn't need to see where
> Guest is up to in consuming the ring.  However, to completely understand
> what's going on from the outside, this information must be exposed.
> For example, host can reduce the number of interrupts by detecting
> that the guest is currently handling previous buffers.
>
> We add a feature bit so the guest can tell the host that it's writing
> out the current value there, if it wants to use that.
>
> This differs from original approach in that the used index
> is put after avail index (they are typically written out together).
> To avoid cache bounces on descriptor access,
> and make future extensions easier, we put the ring itself at start of
> page, and move the control after it.
>    

I missed the spec patch, can you repost it?

-- 
error compiling committee.c: too many arguments to function

