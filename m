Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947108Ab2LFTp0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:45:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947077Ab2LFTpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:45:24 -0500
Message-ID: <50C0F55F.6030405@redhat.com>
Date: Thu, 06 Dec 2012 14:43:27 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bruno Wolff III <bruno@wolff.to>, Johannes Weiner <hannes@cmpxchg.org>,
        Thorsten Leemhuis <fedora@leemhuis.info>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        Tomas Racek <tracek@redhat.com>, Jan Kara <jack@suse.cz>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Josh Boyer <jwboyer@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Jiri Slaby <jslaby@suse.cz>, Zdenek Kabelac <zkabelac@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Ellson <john.ellson@comcast.net>
Subject: Re: kswapd craziness in 3.7
References: <20121128145215.d23aeb1b.akpm@linux-foundation.org> <20121128235412.GW8218@suse.de> <50B77F84.1030907@leemhuis.info> <20121129170512.GI2301@cmpxchg.org> <50B8A8E7.4030108@leemhuis.info> <20121201004520.GK2301@cmpxchg.org> <50BC6314.7060106@leemhuis.info> <20121203194208.GZ24381@cmpxchg.org> <20121204214210.GB20253@cmpxchg.org> <20121205030133.GA17438@wolff.to> <20121206173742.GA27297@wolff.to> <CA+55aFzZsCUk6snrsopWQJQTXLO__G7=SjrGNyK3ePCEtZo7Sw@mail.gmail.com>
In-Reply-To: <CA+55aFzZsCUk6snrsopWQJQTXLO__G7=SjrGNyK3ePCEtZo7Sw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2012 02:31 PM, Linus Torvalds wrote:
> Ok, people seem to be reporting success.
>
> I've applied Johannes' last patch with the new tested-by tags.
>
> Johannes (or anybody else, for that matter), please holler LOUDLY if
> you disagreed.. (or if I used the wrong version of the patch, there's
> been several, afaik).

Johannes's patch is a fairly big hammer, with kswapd not looping
back to the start when zones are still unbalanced.

However, the next allocation will wake up kswapd again, and
having kswapd stop early beats having it in an infinite loop.

I believe Johannes's patch will be fine for 3.7.

-- 
All rights reversed
