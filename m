Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2JIMuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:50:06 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:14289 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752963Ab2JIMuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:50:03 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344204000"; 
   d="scan'208";a="176459672"
Date: Tue, 9 Oct 2012 14:50:00 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Jean Delvare <khali@linux-fr.org>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michael Krufky <mkrufky@linuxtv.org>,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/13] drivers/media/tuners/mxl5007t.c: use macros for
 i2c_msg initialization
In-Reply-To: <20121009143035.557951bb@endymion.delvare>
Message-ID: <alpine.DEB.2.02.1210091447130.1971@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-4-git-send-email-Julia.Lawall@lip6.fr> <20121009143035.557951bb@endymion.delvare>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Jean Delvare wrote:

> Hi Julia,
>
> On Sun,  7 Oct 2012 17:38:33 +0200, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
>
> Next time you send this patch set, please Cc me on every post so that I
> don't have to hunt for them on lkml.org.

OK.

> > In each case, a length expressed as an explicit constant is also
> > re-expressed as the size of the buffer, when this is possible.
>
> This is conceptually wrong, please don't do that. It is perfectly valid
> to use a buffer which is larger than the message being written or read.
> When exchanging multiple messages, it is actually quite common to
> declare only 2 buffers and reuse them:
>
> 	char reg;
> 	char val[2];
>
> 	struct i2c_msg msg[2] = {
> 		{ .addr = addr, .flags = 0, .buf = &reg, .len = 1 },
> 		{ .addr = addr, .flags = I2C_M_RD, .buf = val, .len = 1 },
> 	};
>
> 	reg = 0x04;
> 	i2c_transfer(i2c_adap, msg, 2);
> 	/* Do stuff with val */
>
> 	reg = 0x06;
> 	msg[1].len = 2;
> 	i2c_transfer(i2c_adap, msg, 2);
> 	/* Do stuff with val */
>
> Your conversion would read 2 bytes from register 0x04 instead of 1 in
> the example above.
>
> I am not opposed to the idea of i2c_msg initialization helper macros,
> but please don't mix that with actual code changes which could have bad
> side effects.

I at least tried to check in every case that the result of sizeof is the
same as the value that is present.  But I can leave the constants as is,
if that seems better.

Thanks for the feedback.

julia
