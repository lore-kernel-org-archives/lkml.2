Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2JIMvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:51:36 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:16616 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363Ab2JIMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:51:35 -0400
X-IronPort-AV: E=Sophos;i="4.80,560,1344204000"; 
   d="scan'208";a="176460022"
Date: Tue, 9 Oct 2012 14:51:33 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Jean Delvare <khali@linux-fr.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, Ryan Mallon <rmallon@gmail.com>,
        Antti Palosaari <crope@iki.fi>, kernel-janitors@vger.kernel.org,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/13] drivers/media/tuners/qt1010.c: use macros for
 i2c_msg initialization
In-Reply-To: <20121009141220.412c15c8@endymion.delvare>
Message-ID: <alpine.DEB.2.02.1210091450270.1971@hadrien>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr> <1349624323-15584-5-git-send-email-Julia.Lawall@lip6.fr> <5071FA5D.30003@gmail.com> <alpine.DEB.2.02.1210080704440.1972@localhost6.localdomain6> <50726110.5020901@gmail.com>
 <alpine.DEB.2.02.1210080722470.1972@localhost6.localdomain6> <20121009141220.412c15c8@endymion.delvare>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2012, Jean Delvare wrote:

> Hi Julia,
>
> On Mon, 8 Oct 2012 07:24:11 +0200 (CEST), Julia Lawall wrote:
> > > Sorry, I mean either:
> > >
> > > 	I2C_MSG_WRITE(priv->cfg->i2c_address, &reg, sizeof(reg)),
> > > 	I2C_MSG_READ(priv->cfg->i2c_address, val, sizeof(*val)),
> >
> > Of course.  Sorry for not having seen that.  I can do that.
>
> Eek, no, you can't, not in the general case at least. sizeof(*val) will
> return the size of the _first_ element of the destination buffer, which
> has nothing to do with the length of that buffer (which in turn might
> be rightfully longer than the read length for this specific message.)

I was actually only going to do it when the size was 1 and the type was
u8 *.  But your other email suggests that converting to sizeof is just not
a good idea at all.  So I will drop that part of the rule.

julia
