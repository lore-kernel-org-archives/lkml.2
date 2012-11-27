Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2K0SzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:55:00 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:34517 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2K0Sy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:54:59 -0500
Date: Tue, 27 Nov 2012 13:54:34 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1354039349.2534.11.camel@shinybook.infradead.org>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
	<1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
	<1354036592.2534.6.camel@shinybook.infradead.org>
	<20121127173906.GA11390@shrek.podlesie.net>
	<1354039349.2534.11.camel@shinybook.infradead.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012 18:02:29 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> In solos-pci at least, the ops->close() function doesn't flush all
> pending skbs for this vcc before returning. So can be a tasklet
> somewhere which has loaded the address of the vcc->pop function from one
> of them, and is going to call it in some unspecified amount of time.
> 
> Should we make the device's ->close function wait for all TX and RX skbs
> for this vcc to complete? 

the driver's close routine should wait for any of the pending tx and rx
to complete.  take a look at the he.c in driver/atm
