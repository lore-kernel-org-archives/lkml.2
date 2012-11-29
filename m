Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2K2O34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:29:56 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:37112 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724Ab2K2O3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:29:54 -0500
Date: Thu, 29 Nov 2012 09:29:35 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
        David Laight <David.Laight@ACULAB.COM>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nathan@traverse.com.au
Subject: Re: [PATCH v2 3/3] pppoatm: protect against freeing of vcc
Message-ID: <20121129092935.71efec7c@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <20121129105715.GA10226@shrek.podlesie.net>
References: <1350926091-12642-1-git-send-email-krzysiek@podlesie.net>
	<1350926091-12642-3-git-send-email-krzysiek@podlesie.net>
	<1354036592.2534.6.camel@shinybook.infradead.org>
	<20121127173906.GA11390@shrek.podlesie.net>
	<1354039349.2534.11.camel@shinybook.infradead.org>
	<20121127135434.0728cd4f@thirdoffive.cmf.nrl.navy.mil>
	<AE90C24D6B3A694183C094C60CF0A2F6026B70C9@saturn3.aculab.com>
	<1354141115.21562.101.camel@shinybook.infradead.org>
	<20121129105715.GA10226@shrek.podlesie.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 11:57:15 +0100
Krzysztof Mazur <krzysiek@podlesie.net> wrote:

> or if we really want to call vcc->pop() for such skbs:

you need to call ->pop() to cleaning up the wmem_alloc accounting.
otherwise you will get complaints from the atm stack later about
freeing a vcc that had outstanding data.
