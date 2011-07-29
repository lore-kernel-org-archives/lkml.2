Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1G2K0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:26:54 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16805 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1G2K0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:26:53 -0400
Date: Fri, 29 Jul 2011 12:26:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Andy Walls <awalls@md.metrocast.net>
cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Jarod Wilson <jarod@redhat.com>,
        Jerome Brock <jbrock@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Gerd Knorr <kraxel@goldbach.in-berlin.de>,
        Jarod Wilson <jarod@wilsonet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Thomas Reitmayr <treitmayr@yahoo.com>,
        Michal Kochanowicz <mkochano@pld.org.pl>,
        Christoph Bartelmus <lirc@bartelmus.de>, Mark Weaver <mark@npsl.co.uk>,
        Ulrich Mueller <ulrich.mueller42@web.de>,
        Stefan Jahn <stefan@lkcc.org>
Subject: Re: [PATCH] staging; lirc, zilog: put_ir_rx may free 'rx' which can
 lead to double free
In-Reply-To: <f6f0d669-39e8-4435-839d-9c5525cbd8e9@email.android.com>
Message-ID: <alpine.LNX.2.00.1107291225560.22532@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107282345540.20477@swampdragon.chaosbits.net> <20110729060822.GF3752@shale.localdomain> <f6f0d669-39e8-4435-839d-9c5525cbd8e9@email.android.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jul 2011, Andy Walls wrote:

> Dan Carpenter <error27@gmail.com> wrote:
> 
> >On Thu, Jul 28, 2011 at 11:49:51PM +0200, Jesper Juhl wrote:
> >> If calling put_ir_rx(rx, true); in
> >> drivers/staging/lirc/lirc_zilog.c::ir_probe() returns true (1) then
> >it
> >> means that it has freed it's first argument. Subsequently jumping to
> >> 'out_put_xx' will cause us to call put_ir_rx() once more since 'rx'
> >is
> >> not zero - leading to a double free.
> >
> >It would be better to just remove the first call to put_ir_rx().
> >
> >regards,
> >dan carpenter
> 
> Jesper,
> 
> Could you forward your original patch email to me?  I never got it.
> 
> I was the one who added all the new ref counting to lirc_zilog and it was not fun to get right (well at least what I thought was right...).
> 

Sure. I've just forwarded both the original patch mail and the mail with 
the updated version to  Andy Walls <awalls@md.metrocast.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

