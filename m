Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1IVMrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 08:47:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:43176 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1IVMrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 08:47:09 -0400
Message-ID: <4E7B2E43.3080609@infradead.org>
Date: Thu, 22 Sep 2011 09:46:59 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20110922131232.56210b544f587210621ae339@canb.auug.org.au>
In-Reply-To: <20110922131232.56210b544f587210621ae339@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 22-09-2011 00:12, Stephen Rothwell escreveu:
> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/dt3155v4l/dt3155v4l.c: In function 'dt3155_start_acq':
> drivers/staging/dt3155v4l/dt3155v4l.c:210:2: error: implicit declaration of function 'vb2_dma_contig_plane_paddr'
> drivers/staging/dt3155v4l/dt3155v4l.c: At top level:
> drivers/staging/dt3155v4l/dt3155v4l.c:321:2: warning: initialization from incompatible pointer type
> drivers/staging/dt3155v4l/dt3155v4l.c:325:2: warning: initialization from incompatible pointer type
> 
> Casued by commit ba7fcb0c9549 ("[media] media: vb2: dma contig allocator:
> use dma_addr instread of paddr").
> 
> I have used the v4l-dvb tree from next-20110921 for today.

Hi Stephen,

I think that the right thing to do is to disable the building of this
staging driver, if it is not using the current media core API's.

Greg,

If possible, I prefer to merge those staging drivers for the media
subsystem via my tree, as it helps me to solve in advance conflicts
like that. Maybe we could add a drivers/staging/media tree or
drivers/media/staging, and move those beasts to there.

What do you think?

Thanks,
Mauro
