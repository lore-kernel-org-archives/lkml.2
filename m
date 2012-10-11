Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2JKGpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:45:49 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:2557 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751584Ab2JKGpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:45:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,570,1344204000"; 
   d="scan'208";a="176739786"
Date: Thu, 11 Oct 2012 08:45:43 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, Ryan Mallon <rmallon@gmail.com>,
        Joe Perches <joe@perches.com>, walter harms <wharms@bfs.de>,
        ben-linux@fluff.org, w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        khali@linux-fr.org, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, shubhrajyoti@ti.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
In-Reply-To: <20121009203238.63d2275f@infradead.org>
Message-ID: <alpine.DEB.2.02.1210110836030.2010@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr> <5071AEF3.6080108@bfs.de> <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6> <5071B834.1010200@bfs.de>
 <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6> <1349633780.15802.8.camel@joe-AO722> <alpine.DEB.2.02.1210072053550.2745@localhost6.localdomain6> <1349645970.15802.12.camel@joe-AO722> <alpine.DEB.2.02.1210072342460.2745@localhost6.localdomain6>
 <1349646718.15802.16.camel@joe-AO722> <20121007225639.364a41b4@infradead.org> <50723661.6040107@gmail.com> <alpine.DEB.2.02.1210081028340.1989@hadrien> <20121009203238.63d2275f@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found 6 cases where there are more than 2 messages in the array.  I
didn't check how many cases where there are two messages but there is
something other than one read and one write.

Perhaps a reasonable option would be to use

I2C_MSG_READ
I2C_MSG_WRITE
I2C_MSG_READ_OP
I2C_MSG_WRITE_OP

The last two are for the few cases where more flags are specified.  As
compared to the original proposal of I2C_MSG_OP, these keep the READ or
WRITE idea in the macro name.  The additional argument to the OP macros
would be or'd with the read or write (nothing to do in this case) flags as
appropriate.

Mauro proposed INIT_I2C_READ_SUBADDR for the very common case where a
message array has one read and one write.  I think that putting one
I2C_MSG_READ and one I2C_MSG_WRITE in this case is readable enough, and
avoids the need to do something special for the cases that don't match the
expectations of INIT_I2C_READ_SUBADDR.

I propose not to do anything for the moment either for sizes or for
message or buffer arrays that contain only one element.

julia
