Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1CVUPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:15:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50874
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab1CVUPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:15:14 -0400
Date: Tue, 22 Mar 2011 13:15:52 -0700 (PDT)
Message-Id: <20110322.131552.104076400.davem@davemloft.net>
To: James.Bottomley@HansenPartnership.com
Cc: florian@mickler.org, awalls@md.metrocast.net, mchehab@infradead.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        js@linuxtv.org, tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be,
        oliver@neukum.org, greg@kroah.com, rjw@sisk.pl, joerg.roedel@amd.com
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300800904.3290.7.camel@mulgrave.site>
References: <a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com>
	<20110321220315.7545a61a@schatten.dmk.lab>
	<1300800904.3290.7.camel@mulgrave.site>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Tue, 22 Mar 2011 08:35:04 -0500

> The API will round up so that the correct region covers the API.
> However, if you have other structures packed into the space (as very
> often happens on stack), you get cache line interference in the CPU if
> they get accessed:  The act of accessing an adjacent object pulls in
> cache above your object and destroys DMA coherence.  This is the
> principle reason why DMA to stack is a bad idea.

Another major real reason we can't DMA on-stack stuff is because the
stack is mapped virtually on some platforms.

And that is the original reason the restriction was put in place.
