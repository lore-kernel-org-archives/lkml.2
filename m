Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab0HaCbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 22:31:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab0HaCbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 22:31:09 -0400
Message-ID: <4C7C6959.3030801@redhat.com>
Date: Mon, 30 Aug 2010 22:30:49 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] vmscan: prevent background aging of anon page in no swap
 system
References: <AANLkTi==mQh31PzuNa1efH2WM1s-VPKyZX0f5iwb54PD@mail.gmail.com>	<AANLkTinqm0o=AfmgFy+SpZ1mrdekRnjeXvs_7=OcLii8@mail.gmail.com>	<20100831095140.87C7.A69D9226@jp.fujitsu.com> <AANLkTin4-NomOoNFYCKgi7oE+MCUiC0o0ftAkOwLKez_@mail.gmail.com>
In-Reply-To: <AANLkTin4-NomOoNFYCKgi7oE+MCUiC0o0ftAkOwLKez_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 09:23 PM, Minchan Kim wrote:

> Ying's one and mine both has a same effect.
> Only difference happens swap is full. My version maintains old
> behavior but Ying's one changes the behavior. I admit swap full is
> rare event but I hoped not changed old behavior if we doesn't find any
> problem.
> If kswapd does aging when swap full happens, is it a problem?

It may be a good thing, since swap will often be freed again
(when something is swapped in, or exits).

Having some more anonymous pages sit on the inactive list
gives them a chance to get used again, potentially giving
us a better chance of preserving the working set when swap
is full or near full a lot of the time.

-- 
All rights reversed
