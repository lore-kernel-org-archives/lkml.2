Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab0DVBNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 21:13:30 -0400
Received: from www.telegraphics.com.au ([204.15.192.19]:37403 "EHLO
	mail.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab0DVBN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 21:13:27 -0400
Date: Thu, 22 Apr 2010 11:13:21 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: David Miller <davem@davemloft.net>
cc: joe@perches.com, p_gortmaker@yahoo.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] mac8390: change an error return code and some cleanup,
 take 3
In-Reply-To: <20100421.163041.158540277.davem@davemloft.net>
Message-ID: <alpine.OSX.2.00.1004221108270.289@localhost>
References: <alpine.OSX.2.00.1004161403160.271@localhost> <alpine.OSX.2.00.1004162347390.271@localhost> <alpine.OSX.2.00.1004171258330.358@localhost> <20100421.163041.158540277.davem@davemloft.net>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 21 Apr 2010, David Miller wrote:

> From: Finn Thain <fthain@telegraphics.com.au>
> Date: Sat, 17 Apr 2010 13:16:04 +1000 (EST)
> 
> > 
> > Change an error return code from -EAGAIN to -EBUSY since the former is 
> > misleading.
> > 
> > Nubus slots are geographically addressed and their irqs are equally 
> > inflexible. -EAGAIN is misleading because retrying will not help fix 
> > whatever bug it was that made the irq unavailable.
> 
> request_irq() itself returns an appropriate error code, so the
> correct change is to do:
> 
> 	err = request_irq( ... );
> 	if (err) {
> 	...
> 
> and return 'err'.

OK. I'll send a new patch once 2.6.34 is out and I have time to test this 
and some other patches.

Finn
