Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab0HDVWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:22:37 -0400
Received: from tuxonice.net ([74.207.252.127]:58040 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084Ab0HDVWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:22:31 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C59DA16.4020500@tuxonice.net>
Date: Thu, 05 Aug 2010 07:22:30 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 used!
References: <4C58C528.4000606@tuxonice.net> <4C5960B0.7020003@teksavvy.com>
In-Reply-To: <4C5960B0.7020003@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 04/08/10 22:44, Mark Lord wrote:
> Looks to me like more and more things are using the block discard
> functionality, and as predicted it is slowing things down enormously.
>
> The problem is that we still only discard tiny bits (a single range
> still??)
> per TRIM command, rather than batching larger ranges and larger numbers
> of ranges into single TRIM commands.
>
> That's a very poor implementation, especially when things start enabling
> it by default. Eg. the swap code, mke2fs, etc..
>
> Ugh.

I was hoping for a nice quick and simple answer. Since I haven't got 
one, I'll try to find time to do a git bisect. I think I'll also look at 
the swap code more carefully and see if it's doing the sensible thing. I 
can't (at the moment) see the logic behind calling discard when 
allocating swap. At freeing time makes much more sense to me.

Regards,

Nigel
