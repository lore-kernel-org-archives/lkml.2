Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab0HUJe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:34:59 -0400
Received: from smtp.nokia.com ([192.100.122.233]:34176 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0HUJe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:34:56 -0400
Subject: Re: [PATCH 0/6] improve list_sort test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
In-Reply-To: <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	 <1281261789.2384.11.camel@localhost>
	 <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 12:32:49 +0300
Message-ID: <1282383169.2358.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Aug 2010 09:34:28.0789 (UTC) FILETIME=[0D43CE50:01CB4114]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 12:31 -0700, Don Mullis wrote:
> Yes, invalid 'a' or 'b' pointers would be a bug.  If providing a test
> case is hard, can you say what segment is pointed to?  Into the stack?
> Into address ranges normal for elements, but not now on the list?  Is
> there a pattern to the values returned?  Is it perhaps always the
> first or last callback from a particular call to list_sort()?

You've correctly identified in the the other mail that 'a' and 'b'
sometimes point to the list head. I've just checked this.

> That sometimes a==b is, on the other hand, by design:
> 
> 	/*
> 	 * In worst cases this loop may run many iterations.
> 	 * Continue callbacks to the client even though no
> 	 * element comparison is needed, so the client's cmp()
> 	 * routine can invoke cond_resched() periodically.
> 	 */
> 	(*cmp)(priv, tail, tail);
> 
> Adding a sentence to the function header comment reminding callers
> that they need to be able to handle a==b seems like a good idea.

OK, I'll add it.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

