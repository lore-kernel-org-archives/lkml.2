Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2JGSQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 14:16:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:55366 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751760Ab2JGSQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 14:16:22 -0400
Message-ID: <1349633780.15802.8.camel@joe-AO722>
Subject: Re: [PATCH 13/13] drivers/media/tuners/e4000.c: use macros for
 i2c_msg initialization
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: walter harms <wharms@bfs.de>, Antti Palosaari <crope@iki.fi>,
        kernel-janitors@vger.kernel.org, rmallon@gmail.com,
        shubhrajyoti@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 07 Oct 2012 11:16:20 -0700
In-Reply-To: <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>
References: <1349624323-15584-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1349624323-15584-3-git-send-email-Julia.Lawall@lip6.fr>
	 <5071AEF3.6080108@bfs.de>
	 <alpine.DEB.2.02.1210071839040.2745@localhost6.localdomain6>
	 <5071B834.1010200@bfs.de>
	 <alpine.DEB.2.02.1210071917040.2745@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-07 at 19:18 +0200, Julia Lawall wrote:
> On Sun, 7 Oct 2012, walter harms wrote:
> > Am 07.10.2012 18:44, schrieb Julia Lawall:
> >> On Sun, 7 Oct 2012, walter harms wrote:
> >>> Am 07.10.2012 17:38, schrieb Julia Lawall:
> >>>> Introduce use of I2c_MSG_READ/WRITE/OP, for readability.
> >>>> struct i2c_msg x =
> >>>> - {.addr = a, .buf = b, .len = c, .flags = I2C_M_RD}
> >>>> + I2C_MSG_READ(a,b,c)
[]
> >>>> struct i2c_msg x =
> >>>> - {.addr = a, .buf = b, .len = c, .flags = 0}
> >>>> + I2C_MSG_WRITE(a,b,c)
[]
> > do you really thing that a macro is appropriate here ? I feel uneasy about it
> > but i can not offer an other solution.

I think the macros are fine.

> Some people thought that it would be nice to have the macros rather than 
> the inlined field initializations, especially since there is no flag for 
> write.  A separate question is whether an array of one element is useful, 
> or whether one should systematically use & on a simple variable of the 
> structure type.  I'm open to suggestions about either point.

I think the macro naming is not great.

Maybe add DEFINE_/DECLARE_/_INIT or something other than an action
name type to the macro names.

I think the consistency is better if all the references are done
as arrays, even for single entry arrays.

It's all quibbling in any case.

