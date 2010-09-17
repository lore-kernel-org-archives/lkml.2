Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0IQAuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:50:55 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51143 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753997Ab0IQAuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:50:54 -0400
Message-Id: <1284684653.10161.1395434085@webmail.messagingengine.com>
X-Sasl-Enc: rUcIa4Lui6oCm93zstogAlBPplgBnvCoDWC0OcgUutBW 1284684653
From: "Robert Mueller" <robm@fastmail.fm>
To: "Christoph Lameter" <cl@linux.com>,
        "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "Bron Gondwana" <brong@fastmail.fm>,
        "linux-mm" <linux-mm@kvack.org>, "Mel Gorman" <mel@csn.ul.ie>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <1284349152.15254.1394658481@webmail.messagingengine.com>
 <20100916184240.3BC9.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1009161153210.22849@router.home>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad for
 file/email/web servers
In-Reply-To: <alpine.DEB.2.00.1009161153210.22849@router.home>
Reply-To: robm@fastmail.fm
Date: Fri, 17 Sep 2010 10:50:53 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Having very little knowledge of what this actually does, I'd just
> > > like to point out that from a users point of view, it's really
> > > annoying for your machine to be crippled by a default kernel
> > > setting that's pretty obscure.
>
> Thats an issue of the NUMA BIOS information. Kernel defaults to zone
> reclaim if the cost of accessing remote memory vs local memory crosses
> a certain threshhold which usually impacts performance.

We use what I thought was a fairly standard server type motherboard and
CPU combination, and I was surprised that things were so badly broken
for a standard usage scenario with a vanilla kernel with a default
configuration.

I'd point out that the cost of a remote memory access is many, many
orders of magnitude less than having to go back to disk! The problem is
that with zone_reclaim_mode = 1 it seems lots of memory was being wasted
that could be used as disk cache.

> > Yes, sadly intel motherboard turn on zone_reclaim_mode by
> > default. and current zone_reclaim_mode doesn't fit file/web
> > server usecase ;-)
>
> Or one could also say that the web servers are not designed to
> properly distribute the load on a complex NUMA based memory
> architecture of todays Intel machines.

I don't think this is any fault of how the software works. It's a *very*
standard "pre-fork child processes, allocate incoming connections to a
child process, open and mmap one or more files to read data from them".
That's not exactly a weird programming model, and it's bad that the
kernel is handling that case very badly with everything default.

> So would enabling memory interleave in the BIOS to get the machine to
> not consider the memory distances but average out the NUMA effects.

We'll see if the BIOS has an option for that and try it out. I'd like to
document for others that encounter this problem ways around it.

Rob
