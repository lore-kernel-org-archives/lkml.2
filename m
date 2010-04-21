Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0DUXai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 19:30:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57397
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835Ab0DUXag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 19:30:36 -0400
Date: Wed, 21 Apr 2010 16:30:41 -0700 (PDT)
Message-Id: <20100421.163041.158540277.davem@davemloft.net>
To: fthain@telegraphics.com.au
Cc: joe@perches.com, p_gortmaker@yahoo.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] mac8390: change an error return code and some cleanup,
 take 3
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.OSX.2.00.1004171258330.358@localhost>
References: <alpine.OSX.2.00.1004161403160.271@localhost>
	<alpine.OSX.2.00.1004162347390.271@localhost>
	<alpine.OSX.2.00.1004171258330.358@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Sat, 17 Apr 2010 13:16:04 +1000 (EST)

> 
> Change an error return code from -EAGAIN to -EBUSY since the former is 
> misleading.
> 
> Nubus slots are geographically addressed and their irqs are equally 
> inflexible. -EAGAIN is misleading because retrying will not help fix 
> whatever bug it was that made the irq unavailable.

request_irq() itself returns an appropriate error code, so the
correct change is to do:

	err = request_irq( ... );
	if (err) {
	...

and return 'err'.
