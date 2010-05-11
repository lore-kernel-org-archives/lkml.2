Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab0EKE5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 00:57:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:59077 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0EKE5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 00:57:06 -0400
Subject: Re: [PATCH 21/25] lmb: Add "start" argument to lmb_find_base()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
In-Reply-To: <AANLkTimhvJUX2S2eIY8rpw4TnUrDUFicMxEZkLK3hu1N@mail.gmail.com>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-14-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-15-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-16-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-17-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-18-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-19-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-20-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-21-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-22-git-send-email-benh@kernel.crashing.org>
	 <AANLkTimhvJUX2S2eIY8rpw4TnUrDUFicMxEZkLK3hu1N@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 14:56:26 +1000
Message-ID: <1273553786.21352.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 16:37 -0700, Yinghai Lu wrote:

> >                if (lmbsize < size)
> >                        continue;
> > -               base = min(lmbbase + lmbsize, max_addr);
> > -               res_base = lmb_find_region(lmbbase, base, size, align);
> > -               if (res_base != LMB_ERROR)
> > -                       return res_base;
> > +               if ((lmbbase + lmbsize) <= start)
> > +                       break;
> > +               bottom = max(lmbbase, start);
> > +               top = min(lmbbase + lmbsize, end);
> > +               if (bottom >= top)
> > +                       continue;
> > +               found = lmb_find_region(lmbbase, top, size, align);
>                                                                ^^^^^^^^^
> should use bottom  here

Correct, I missed that when converting.

Cheers,
Ben.


