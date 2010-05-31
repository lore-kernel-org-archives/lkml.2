Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab0EaPOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:14:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59563
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756483Ab0EaPOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:14:05 -0400
Date: Mon, 31 May 2010 08:14:12 -0700 (PDT)
Message-Id: <20100531.081412.27799681.davem@davemloft.net>
To: joe@perches.com
Cc: geert@linux-m68k.org, fthain@telegraphics.com.au, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] mac8390: change an error return code and some cleanup,
 take 4
From: David Miller <davem@davemloft.net>
In-Reply-To: <1275318493.6503.206.camel@Joe-Laptop.home>
References: <alpine.LNX.2.00.1005311905520.469@nippy.intranet>
	<AANLkTilkooBglbk33yDHmk8c_ZdlamOW8FVvuvjQaNsF@mail.gmail.com>
	<1275318493.6503.206.camel@Joe-Laptop.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon, 31 May 2010 08:08:13 -0700

> There are many uses of KERN_DEBUG that are reasonable to have
> always enabled.

Doubtful.

pr_debug() makes a ton of sense as currently implemented.
It's for messages that we want both compile time and
run-time control over.

The case we have here in mac8390 seems like it should stay
as pr_info().  Because 1) it's already controlled by a
run-time knob so controlling it even further is confusing
and 2) the message is "informative", it lets the user know
a feature cannot be enabled, thus pr_info().
