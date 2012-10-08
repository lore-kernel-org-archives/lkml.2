Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab2JHIbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:31:37 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:6014 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712Ab2JHIbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:31:36 -0400
X-IronPort-AV: E=Sophos;i="4.80,551,1344204000"; 
   d="scan'208";a="158222143"
Date: Mon, 8 Oct 2012 10:31:33 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Ryan Mallon <rmallon@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Joe Perches <joe@perches.com>, Julia Lawall <julia.lawall@lip6.fr>,
        walter harms <wharms@bfs.de>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
In-Reply-To: <50723661.6040107@gmail.com>
Message-ID: <alpine.DEB.2.02.1210081028340.1989@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr> <5071AEF3.6080108@bfs.de> <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6> <5071B834.1010200@bfs.de>
 <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6> <1349633780.15802.8.camel@joe-AO722> <alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6> <1349645970.15802.12.camel@joe-AO722> <alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
 <1349646718.15802.16.camel@joe-AO722> <20121007225639.364a41b4@infradead.org> <50723661.6040107@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found only 15 uses of I2C_MSG_OP, out of 653 uses of one of the three
macros.  Since I2C_MSG_OP has the complete set of flags, I think it should
be OK?

One of the uses, in drivers/media/i2c/adv7604.c, is as follows:

       struct i2c_msg msg[2] = { { client->addr, 0, 1, msgbuf0 },
                                 { client->addr, 0 | I2C_M_RD, len, msgbuf1 }

I'm not sure what was intended, but I guess the second structure is
supposed to only do a read?

julia
