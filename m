Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1JTEpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 00:45:51 -0400
Received: from mail.kaapeli.fi ([84.20.139.148]:32851 "EHLO mail.kaapeli.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1JTEpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 00:45:50 -0400
Message-ID: <4E9FA779.5040406@iki.fi>
Date: Thu, 20 Oct 2011 07:45:45 +0300
From: Jyrki Kuoppala <jkp@iki.fi>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Fix to qt1010 tuner frequency selection (media/dvb)
References: <4E528FAE.5060801@iki.fi> <5010154.A6jI82beuA@valkyrie> <4E7F58BB.5080803@iki.fi> <2165330.TqTdf0zloM@valkyrie>
In-Reply-To: <2165330.TqTdf0zloM@valkyrie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think my problem frequency has also been at the later spot. It is possible there is something more complicated going on at 474 MHz - so based on your testing, it's best to apply just the latter change, at least for now.

Jyrki



+    else if (freq<   546000000) rd[15].val = 0xd6; /* 546 MHz */

+    else if (freq<   546000000) rd[15].val = 0xd6; /* 546 MHz */


20.10.2011 00:06, Carlos Corbacho kirjoitti:
> Jyrki,
>
> So after a bit more testing...
>
> [...]
>
>>>>         /* 22 */
>>>>         if      (freq<   450000000) rd[15].val = 0xd0; /* 450 MHz
>>>>         */
>>>>
>>>> -    else if (freq<   482000000) rd[15].val = 0xd1; /* 482 MHz */
>>>> +    else if (freq<   482000000) rd[15].val = 0xd2; /* 482 MHz */
> This change isn't so good.
>
> With this change, I can no longer tune to channel 21 (474 MHz). If I revert it
> back to 0xd1, it's fine.
>
> [...]
>
>>>>         else if (freq<   514000000) rd[15].val = 0xd4; /* 514 MHz
>>>>         */
>>>>
>>>> -    else if (freq<   546000000) rd[15].val = 0xd7; /* 546 MHz */
>>>> +    else if (freq<   546000000) rd[15].val = 0xd6; /* 546 MHz */
>>>> +    else if (freq<   578000000) rd[15].val = 0xd8; /* 578 MHz */
> (This change is still good though, as this does allow me to now tune to the
> BBC channels in this range).
>
> -Carlos

