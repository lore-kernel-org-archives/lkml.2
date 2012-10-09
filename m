Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab2JIMG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:06:57 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:23435 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2JIMGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:06:55 -0400
Date: Tue, 9 Oct 2012 14:06:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: walter harms <wharms@bfs.de>, Michael Buesch <m@bues.ch>,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/13] drivers/media/tuners/fc0011.c: use macros for
 i2c_msg initialization
Message-ID: <20121009140617.6b2a159a@endymion.delvare>
In-Reply-To: <alpine.DEB.2.02.1210071845030.2745@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	<1349624323-15584-11-git-send-email-Julia.Lawall@lip6.fr>
	<5071B147.3010708@bfs.de>
	<alpine.DEB.2.02.1210071845030.2745@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2012 18:50:31 +0200 (CEST), Julia Lawall wrote:
> On Sun, 7 Oct 2012, walter harms wrote:
> > Am 07.10.2012 17:38, schrieb Julia Lawall:
> >> @@ -97,10 +96,8 @@ static int fc0011_readreg(struct fc0011_priv *priv, u8 reg, u8 *val)
> >>  {
> >>  	u8 dummy;
> >>  	struct i2c_msg msg[2] = {
> >> -		{ .addr = priv->addr,
> >> -		  .flags = 0, .buf = &reg, .len = 1 },
> >> -		{ .addr = priv->addr,
> >> -		  .flags = I2C_M_RD, .buf = val ? : &dummy, .len = 1 },
> >> +		I2C_MSG_WRITE(priv->addr, &reg, sizeof(reg)),
> >> +		I2C_MSG_READ(priv->addr, val ? : &dummy, sizeof(dummy)),
> >>  	};
> >>
> >
> > This dummy looks strange, can it be that this is used uninitialised ?
> 
> I'm not sure to understand the question.  The read, when it happens in 
> i2c_transfer will initialize dummy.  On the other hand, I don't know what 
> i2c_transfer does when the buffer is NULL and the size is 1.  It does not 
> look very elegant at least.

i2c_transfer() itself won't care, it just passes the request down to the
underlying i2c bus driver. Most driver implementations will assume
proper buffer addresses as soon as size > 0, so passing NULL instead
would crash them. In short, don't do that.

-- 
Jean Delvare
