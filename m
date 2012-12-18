Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab2LRLrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 06:47:31 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:24222 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab2LRLr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 06:47:29 -0500
Date: Tue, 18 Dec 2012 12:46:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Ryan Mallon <rmallon@gmail.com>, Joe Perches <joe@perches.com>,
        walter harms <wharms@bfs.de>, ben-linux@fluff.org,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>, kernel-janitors@vger.kernel.org,
        shubhrajyoti@ti.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for 
 i2c_msg initialization
Message-ID: <20121218124640.5b1e7176@endymion.delvare>
In-Reply-To: <alpine.DEB.2.02.1210110836030.2010@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	<1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
	<5071AEF3.6080108@bfs.de>
	<alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>
	<5071B834.1010200@bfs.de>
	<alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>
	<1349633780.15802.8.camel@joe-AO722>
	<alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6>
	<1349645970.15802.12.camel@joe-AO722>
	<alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
	<1349646718.15802.16.camel@joe-AO722>
	<20121007225639.364a41b4@infradead.org>
	<50723661.6040107@gmail.com>
	<alpine.DEB.2.02.1210081028340.1989@hadrien>
	<20121009203238.63d2275f@infradead.org>
	<alpine.DEB.2.02.1210110836030.2010@hadrien>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Julia,

On Thu, 11 Oct 2012 08:45:43 +0200 (CEST), Julia Lawall wrote:
> I found 6 cases where there are more than 2 messages in the array.  I
> didn't check how many cases where there are two messages but there is
> something other than one read and one write.
> 
> Perhaps a reasonable option would be to use
> 
> I2C_MSG_READ
> I2C_MSG_WRITE
> I2C_MSG_READ_OP
> I2C_MSG_WRITE_OP
> 
> The last two are for the few cases where more flags are specified.  As
> compared to the original proposal of I2C_MSG_OP, these keep the READ or
> WRITE idea in the macro name.  The additional argument to the OP macros
> would be or'd with the read or write (nothing to do in this case) flags as
> appropriate.
> 
> Mauro proposed INIT_I2C_READ_SUBADDR for the very common case where a
> message array has one read and one write.  I think that putting one
> I2C_MSG_READ and one I2C_MSG_WRITE in this case is readable enough, and
> avoids the need to do something special for the cases that don't match the
> expectations of INIT_I2C_READ_SUBADDR.
> 
> I propose not to do anything for the moment either for sizes or for
> message or buffer arrays that contain only one element.

Please note that I resigned from my position of i2c subsystem
maintainer, so I will not handle this. If you think this is important,
you'll have to resubmit and Wolfram will decide what he wants to do
about it.

-- 
Jean Delvare
