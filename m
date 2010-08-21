Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab0HUJ6N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:58:13 -0400
Received: from smtp.nokia.com ([192.100.122.230]:50553 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0HUJ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:58:11 -0400
Subject: Re: [PATCH 0/6] improve list_sort test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
In-Reply-To: <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	 <1281261789.2384.11.camel@localhost>
	 <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
	 <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 12:56:13 +0300
Message-ID: <1282384573.2358.36.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Aug 2010 09:57:51.0584 (UTC) FILETIME=[51655600:01CB4117]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-08 at 13:07 -0700, Don Mullis wrote:
> On Sun, Aug 8, 2010 at 12:31 PM, Don Mullis <don.mullis@gmail.com> wrote:
> > Artem Bityutskiy <dedekind1@gmail.com> writes:
> >> Actually, your 'list_sort()' version does have a problem. I found out
> >> that it calls 'cmp(priv, a, b)' with 'a = b' sometimes, and in these
> >> cases 'a' and 'b' can point to something which is not a valid element of
> >> the original list. Probably a senitel or something like that.
> 
> Looks like if the original list is a POT in length, the first callback
> from line 73 will pass a==b both pointing to the original list_head.
> Would you be able to test this fix?
> 
> --- linux-2.6.orig/lib/list_sort.c
> +++ linux-2.6/lib/list_sort.c
> @@ -70,7 +70,7 @@ static void merge_and_restore_back_links
>                  * element comparison is needed, so the client's cmp()
>                  * routine can invoke cond_resched() periodically.
>                  */
> -               (*cmp)(priv, tail, tail);
> +               (*cmp)(priv, tail->next, tail->next);

Ack, this fix works, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

