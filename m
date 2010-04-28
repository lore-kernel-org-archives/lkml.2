Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab0D1Tzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:55:35 -0400
Received: from relay02.digicable.hu ([92.249.128.188]:54614 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab0D1Tzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:55:33 -0400
Date: Wed, 28 Apr 2010 21:55:29 +0200
From: Gabor Gombas <gombasg@digikabel.hu>
To: Tracy Reed <treed@ultraviolet.org>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       Pasi =?iso-8859-2?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
       xen-devel@lists.xensource.com, Aoetools-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Aoetools-discuss] [Xen-devel] domU is causing misaligned disk
 writes
Message-ID: <20100428195528.GA10354@twister.home>
Mail-Followup-To: Tracy Reed <treed@ultraviolet.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Pasi =?iso-8859-2?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
	xen-devel@lists.xensource.com,
	Aoetools-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20100420080958.GN5660@tracyreed.org>
 <20100420084955.GV1878@reaktio.net>
 <20100420200004.GQ5660@tracyreed.org>
 <20100420202519.GB9220@phenom.dumpdata.com>
 <20100420211913.GV5660@tracyreed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20100420211913.GV5660@tracyreed.org>
X-Original: 94.21.135.186
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 02:19:13PM -0700, Tracy Reed wrote:

> > How do you know this is a mis-aligned sectors issue? Is this what your
> > AOE vendor is telling you ?
> 
> No AoE vendor involved. I am using the free stuff. I think it is a
> misalignment issue because during a purely write test it is doing
> massive amounts of reading according to iostat.

How about actually verifying that by e.g. using wireshark and comparing
the I/O patterns in the fast and slow cases? The differences in the
patterns may give clues where to look further.

> #dd if=/dev/zero of=/dev/etherd/e6.1 oflag=direct bs=4096
> count=3000000
> 1764883+0 records in
> 1764883+0 records out
> 7228960768 bytes (7.2 GB) copied, 402.852 seconds, 17.9 MB/s
> 
> But even on my local directly attached SATA workstation disk when
> doing that same dd on an otherwise idle machine I see performance
> like:
> 
> $ dd if=/dev/zero of=foo.test bs=4096 count=4000000
> C755202+0 records in
> 755202+0 records out
> 3093307392 bytes (3.1 GB) copied, 128.552 s, 24.1 MB/s
> 
> which again suggests that oflag=direct isn't doing quite what I expect.

oflag=direct turns off caching on the host dd is running on, i.e. the
initiator. The target still caches writes of course, unless you tell it
not to by passing the "-d" flag to vblade.

Gabor
