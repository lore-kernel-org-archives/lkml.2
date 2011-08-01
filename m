Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab1HAFqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:46:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64260 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab1HAFqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:46:42 -0400
Message-ID: <4E363DB9.70801@gmail.com>
Date: Mon, 01 Aug 2011 13:46:33 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@us.ibm.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com> <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com> <4E325F98.5090308@gmail.com> <4E32F7F2.4080607@us.ibm.com>
In-Reply-To: <4E32F7F2.4080607@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2011 02:12 AM, Badari Pulavarty wrote:
> Hi Liu Yuan,
>
> I am glad to see that you started looking at vhost-blk.   I did an 
> attempt year ago to improve block
> performance using vhost-blk approach.
>
> http://lwn.net/Articles/379864/
> http://lwn.net/Articles/382543/
>
> I will take a closer look at your patchset to find differences and 
> similarities.
>
> - I focused on using vfs interfaces in the kernel, so that I can use 
> it for file-backed devices.
> Our use-case scenario is mostly file-backed images.
>
vhost-blk's that uses Linux AIO also support file-backed images. 
Actually, I have run Guests both on raw partition and raw file images.

> - In few cases, virtio-blk did outperform vhost-blk -- which was 
> counter intuitive - but
> couldn't exactly nail down. why ?
>
> - I had to implement my own threads for parellism. I see that you are 
> using aio infrastructure
> to get around it.
>
> - In our high scale performance testing, what we found is block-backed 
> device performance is
> pretty close to bare-metal (91% of bare-metal). vhost-blk didn't add 
> any major benefits to it.
> I am curious on your performance analysis & data on where you see the 
> gains and why ?
>
Possibly bypass vfs-layer and translate sg lists from virtio buffer into 
BIOs would benefit the block-backed device. I'll give it a try later.

> Hence I prioritized my work low :(
>
> Now that you are interested in driving this, I am happy to work with 
> you and see what
> vhost-blk brings to the tables. (even if helps us improve virtio-blk).
>
> Thanks,
> Badari
>
>

That's great.

Yuan
