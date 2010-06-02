Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0FBUju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 16:39:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab0FBUjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 16:39:48 -0400
Message-ID: <4C06C166.3050201@redhat.com>
Date: Wed, 02 Jun 2010 22:39:02 +0200
From: Jes Sorensen <Jes.Sorensen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [Qemu-devel] Re: [PATCHv2-RFC 0/2] virtio: put last seen used
 index	into ring itself
References: <cover.1274903328.git.mst@redhat.com> <201005311716.43573.rusty@rustcorp.com.au>
In-Reply-To: <201005311716.43573.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/10 09:46, Rusty Russell wrote:
> On Thu, 27 May 2010 05:20:35 am Michael S. Tsirkin wrote:
>> Here's a rewrite of the original patch with a new layout.
>> I haven't tested it yet so no idea how this performs, but
>> I think this addresses the cache bounce issue raised by Avi.
>> Posting for early flames/comments.
> 
> Sorry, not without some evidence that it'll actually reduce cacheline
> bouncing.  I *think* it will, but it's not obvious: the host may keep
> looking at avail_idx as we're updating last_seen.  Or does qemu always
> look at both together anyway?
> 
> Can someone convince me this is a win?
> Rusty.

Hi Rusty,

I ran some tests using the vring index publish patch with virtio_blk.
The numbers are based on running IOZone on a ramdisk passed to the guest
via virtio. While I didn't see any throughput improvements, I saw a
20-30% reduction in the VMExit count for the full run. This was measured
grabbing the VMExit count prior and after the run and calculating the
difference.

I have the numbers in a PDF, so I will email it to you in private as I
don't like sending PDFs to the mailing list. However if anybody else
wants the numbers feel free to ping me off list and I'll forward them.

Cheers,
Jes

