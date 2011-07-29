Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1G2SMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:12:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:53923 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1G2SMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:12:32 -0400
Message-ID: <4E32F7F2.4080607@us.ibm.com>
Date: Fri, 29 Jul 2011 11:12:02 -0700
From: Badari Pulavarty <pbadari@us.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.16) Gecko/20101125 Thunderbird/3.0.11
MIME-Version: 1.0
To: Liu Yuan <namei.unix@gmail.com>
CC: Stefan Hajnoczi <stefanha@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Khoa Huynh <khoa@us.ibm.com>
Subject: Re: [RFC PATCH]vhost-blk: In-kernel accelerator for virtio block
 device
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com> <CAJSP0QUKz7LFuARF_n2LcBi_uuSzfmkjrWsHAWrXXkEaQJKkEA@mail.gmail.com> <4E325F98.5090308@gmail.com>
In-Reply-To: <4E325F98.5090308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu Yuan,

I am glad to see that you started looking at vhost-blk.   I did an 
attempt year ago to improve block
performance using vhost-blk approach.

http://lwn.net/Articles/379864/
http://lwn.net/Articles/382543/

I will take a closer look at your patchset to find differences and 
similarities.

- I focused on using vfs interfaces in the kernel, so that I can use it 
for file-backed devices.
Our use-case scenario is mostly file-backed images.

- In few cases, virtio-blk did outperform vhost-blk -- which was counter 
intuitive - but
couldn't exactly nail down. why ?

- I had to implement my own threads for parellism. I see that you are 
using aio infrastructure
to get around it.

- In our high scale performance testing, what we found is block-backed 
device performance is
pretty close to bare-metal (91% of bare-metal). vhost-blk didn't add any 
major benefits to it.
I am curious on your performance analysis & data on where you see the 
gains and why ?

Hence I prioritized my work low :(

Now that you are interested in driving this, I am happy to work with you 
and see what
vhost-blk brings to the tables. (even if helps us improve virtio-blk).

Thanks,
Badari


