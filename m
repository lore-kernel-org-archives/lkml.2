Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab1AMQaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:30:10 -0500
Received: from lo.gmane.org ([80.91.229.12]:48867 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756934Ab1AMQaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:30:08 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
Date: Thu, 13 Jan 2011 08:29:50 -0800
Message-ID: <20110113082950.6747ebb8@queued.net>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
	<1294928559.3570.130.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: c-71-231-141-121.hsd1.wa.comcast.net
In-Reply-To: <1294928559.3570.130.camel@edumazet-laptop>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jan 2011 15:22:39 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 13 janvier 2011 à 19:49 +0800, Po-Yu Chuang a écrit :
> > From: Po-Yu Chuang <ratbert@faraday-tech.com>
> > 
> > FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
> > MII.  This driver has been working on some ARM/NDS32 SoC including
> > Faraday A320 and Andes AG101.
> > 
> > Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> > ---
> >  drivers/net/Kconfig    |    9 +
> >  drivers/net/Makefile   |    1 +
> >  drivers/net/ftmac100.c | 1341
> > ++++++++++++++++++++++++++++++++++++++++++++++++
> > drivers/net/ftmac100.h |  180 +++++++ 4 files changed, 1531
> > insertions(+), 0 deletions(-) create mode 100644
> > drivers/net/ftmac100.c create mode 100644 drivers/net/ftmac100.h
> 
> Hi
> 
[...]
> 
> 9) Instead of dev_info(&netdev->dev ...) , please consider
> netdev_info()
> 
> 

No one else mentioned it, so I'll add:

Don't explicitly inline functions unless they're in a header, or you
have a really good reason (and that reason should probably be described
in a comment).  Otherwise, just leave off the 'inline' keyword; the
compiler is smart enough to decide whether a function should be inlined
or not.


