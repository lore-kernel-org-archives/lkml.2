Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab1BCLm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:42:28 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:36866 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab1BCLm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:42:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KGZXlQ0bh4rva7r7b/rYoJ+y7x3FCv34H/WIMP+6rsyW4hI5Df631U2hpAuRBO8aFl
         pJbIZWhkkiUeYY3JI6fV+U7Zm6cK+WlkEOAojVOKhGx6Hp0mIfvWuMubY5YkdtHETFql
         hurvpVkSB2TYx29vkPazF9SdSy20bFHE2wqYQ=
Date: Thu, 3 Feb 2011 19:42:19 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Regression: WARNINGS and lockdep spews in 2.6.38-rc3+
 (bisected).
Message-ID: <20110203114218.GA1809@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <20110203031943.GA8910@elliptictech.com>
 <20110203091227.GA1603@zhy>
 <1296725440.26581.354.camel@laptop>
 <20110203101739.GA1551@zhy>
 <1296729184.26581.361.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1296729184.26581.361.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 11:33:04AM +0100, Peter Zijlstra wrote:
> 
> How about we revert your patch and go back to not allowing
> del_timer_sync() from any interrupt context, 

The fact is there is someone want to use del_timer_sync()
in softirq context.
My patch is inspired by this http://lkml.org/lkml/2010/8/16/291
though in the end that issue is resolved by not using
del_timer_sync() in softirq.

> we can fix __dst_free by
> removing the need for cancel_delayed_work().
> 
> Are there any other del_timer_sync() callers from softirq?

I'm not sure about this.

IMHO, we don't need to make more restriction if we don't
have to.

Thanks,
Yong
