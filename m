Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2J1Ton (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:44:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2J1Tol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:44:41 -0400
Date: Sun, 28 Oct 2012 17:44:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>
Subject: Re: linux-next: build warning in Linus' tree
Message-ID: <20121028174423.45b67cab@redhat.com>
In-Reply-To: <20121024134333.baf0c90a323a831675ed7e79@canb.auug.org.au>
References: <20121024134333.baf0c90a323a831675ed7e79@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 24 Oct 2012 13:43:33 +1100
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Mauro,
> 
> After merging the origin tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function 'dvb_usb_ctrl_feed':
> drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:291:12: warning: 'ret' may be used uninitialized in this function [-Wuninitialized]
> 
> Which points out some badly formatted and blocked code ...
> 
> Probably introduced by commit 62a5f449cab5 ("[media] dvb_usb_v2: refactor
> dvb_usb_ctrl_feed() logic").


Hi Stephen,

Thanks for pointing it. It took me some time, but I applied today
a bunch of patches that are fixing all warnings on everything
at drivers/media and drivers/staging/media, with:
	make ARCH=i386 W=1
(allyesconfig, gcc 4.7.2)

Maybe there are still a few ones with random configs and other
archs, but at least on my usual testing environment, we're
warnings-free on drivers/media for now, probably up to the
next gcc version.

-- 
Regards,
Mauro
