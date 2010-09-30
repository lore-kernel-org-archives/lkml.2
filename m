Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0I3Do1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 23:44:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab0I3Do0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 23:44:26 -0400
Message-ID: <4CA40784.20205@infradead.org>
Date: Thu, 30 Sep 2010 00:44:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20100929112904.3fd117e0.sfr@canb.auug.org.au>
In-Reply-To: <20100929112904.3fd117e0.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-09-2010 22:29, Stephen Rothwell escreveu:
> Hi Mauro,
> 
> After merging the v4l-dvb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/media/video/bt8xx/bttv-input.c: In function 'init_bttv_i2c_ir':
> drivers/media/video/bt8xx/bttv-input.c:306: error: too few arguments to function 'i2c_new_probed_device'
> 
> Caused by commit 3c81f945a74224d6e3017596297ee9903929b1a7 ("V4L/DVB:
> bttv: Move PV951 IR to the right driver") interacting with commit
> 9a94241afcc9a481691a9c29b7460217925b59b8 ("i2c: Add support for custom
> probe function") that entered Linus' tree in v2.6.36-rc1.  I guess that
> the v4l-dvb commit moved that code to a driver that is now being built.
> 
> I have used the v4l-dvb tree from next-20100928 for today.

Ok, that's easy. a new parameter were added to this function, probably via Jean's tree.
The fix is as simple as:

-		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list);
+		i2c_new_probed_device(&btv->c.i2c_adap, &info, addr_list, NULL);

The extra parameter is for an extra customized probe function, that it is not
needed in this case.

I got a small merge problem on this function:

drivers/media/video/wm8739.c

I just merged the conflict resolution at the merge object, and added a new
patch for the extra parameter in order to solve I2C conflict.

I did a compilation test after merging it with next-20100929 and those issues
were solved on my local build.

Cheers,
Mauro.
