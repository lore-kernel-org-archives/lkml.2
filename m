Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1DAUe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:34:26 -0400
Received: from mail.cariden.com ([204.2.128.131]:26540 "EHLO mail.cariden.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753127Ab1DAUeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:34:25 -0400
From: Charles Samuels <charles@cariden.com>
Organization: Cariden Technologies
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Queuing of disk writes
Date: Fri, 1 Apr 2011 13:34:24 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-amd64; KDE/4.4.5; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <201104011259.53936.charles@cariden.com> <20110401211049.6c183cfc@lxorguk.ukuu.org.uk>
In-Reply-To: <20110401211049.6c183cfc@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-ID: <201104011334.24182.charles@cariden.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 01, 2011 1:10:49 pm Alan Cox wrote:
> > the kernel's write cache, and then consequently the disk drive's DMA
> > queue. As a result of that, the harddrive can pick the correct order to
> > do these writes, significantly reducing seek times.
> 
> Well that depends a lot on the data, if its very scattered and random it
> may not help much.
Generally 64KiB - I don't know disk geometry, but I guess that's a lot smaller 
than a cylinder.

But I don't really care about throughput (much), I care more about my 
application not blocking everything while the fsync happens.

> 
> > And yes, I *know* fsync is a poor method to determine if data is actually
> > committed to something non-volatile. :)
> 
> fsync/fdatasync should at least make sure it hit the disk. If barriers
> are enabled the rest too.
> 
> What file system are you using - some of the file systems have serious
> limits in this are around fsync and ordering and you may be hitting those.

I've seen this on ext3, ext4, and XFS. Reiser3 not so much. I've also 
convinced my users to use write-backed cache. They're Enterprise customers and 
have loads of money to spend on hardware, such as Warp Cores.

> 
> The ultima answer is probably an SSD of course 8)
Well, that would solve the throughput, but it doesn't solve the blocking!

Charles
