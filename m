Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab1EDXGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 19:06:05 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38155 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab1EDXGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 19:06:03 -0400
Subject: Re: [PATCH] time: Add locking to xtime access in get_seconds()
From: john stultz <johnstul@us.ibm.com>
To: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1304527860.21305.5.camel@w-amax.beaverton.ibm.com>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <1304527860.21305.5.camel@w-amax.beaverton.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 16:05:58 -0700
Message-ID: <1304550358.2943.10.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-04 at 09:51 -0700, Max Asbock wrote:
> On Tue, 2011-05-03 at 20:11 -0700, John Stultz wrote:
> > From: John Stultz <johnstul@us.ibm.com>
> > 
> > So get_seconds() has always been lock free, with the assumption
> > that accessing a long will be atomic.
> > 
> 
> get_seconds() is used in the x86 machine check handler and there is a
> comment saying:
> /* We hope get_seconds stays lockless */
> 
> This needs to be carefully looked at if locking is introduced to
> get_seconds().

Ah. Thanks for pointing this out Max.

I'll go ahead and use Andi's suggestion of the rmb();

Patch soon to follow.

thanks
-john


