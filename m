Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab0JUKx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:53:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:53593 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0JUKxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:53:55 -0400
Message-ID: <4CC01BB9.6040609@infradead.org>
Date: Thu, 21 Oct 2010 08:53:45 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Devin Heitmueller <dheitmueller@hauppauge.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure after merge of the final tree (v4l-dvb
 tree related)
References: <20101019180730.5beac8af.sfr@canb.auug.org.au>
In-Reply-To: <20101019180730.5beac8af.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Em 19-10-2010 05:07, Stephen Rothwell escreveu:
> Hi Mauro,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/media/video/cx231xx/cx231xx-417.c: In function 'cx231xx_load_firmware':
> drivers/media/video/cx231xx/cx231xx-417.c:943: error: implicit declaration of function 'vmalloc'
> drivers/media/video/cx231xx/cx231xx-417.c:943: warning: cast to pointer from integer of different size
> drivers/media/video/cx231xx/cx231xx-417.c:950: warning: cast to pointer from integer of different size
> drivers/media/video/cx231xx/cx231xx-417.c:1039: error: implicit declaration of function 'vfree'
> 
> Caused by commit e0bb3704be9decb10985b0886031e76a228b5f32 ("[media]
> cx231xx: Added support for Carraera, Shelby, RDx_253S and VIDEO_GRABBER").
> 
> 
> I added the following patch for today:

Thanks, I'm adding it to my tree. It seems that some header conditionally includes vmalloc.h or slab.h.
At least, on my builds here with i386 and allyesconfig, no build errors appeared.

> Also, I don't think Arnd is going to like the new BKL usage also
> introduced by the commit.  ;-)

Yeah. Well, v4l is already on his list of BKL troubles. We're already addressing those
issues. We should have a BKL-free version of cx231xx-417.c for 2.6.38.

Cheers,
Mauro.
