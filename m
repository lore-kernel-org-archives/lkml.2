Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab0KSXPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:15:04 -0500
Received: from mail.deathmatch.net ([72.66.92.28]:2512 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab0KSXPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:15:03 -0500
X-Greylist: delayed 1853 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Nov 2010 18:15:03 EST
Date: Fri, 19 Nov 2010 17:28:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
        linville@tuxdriver.com, randy.dunlap@oracle.com, peterz@infradead.org,
        blp@cs.stanford.edu, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars_Ericsson@telia.com,
        stefanr@s5r6.in-berlin.de, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com
Subject: Re: [PATCH v7 3/3] nl80211/mac80211: Report signal average
Message-ID: <20101119222846.GA26592@hash.localnet>
References: <20101112024901.28522.21895.stgit@localhost6.localdomain6> <1290010595.3777.0.camel@jlt3.sipsolutions.net> <AANLkTimoogSLAipNy=njGtHypqBQSk=usDmXut=KN9TM@mail.gmail.com> <201011191807.06013.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011191807.06013.br1@einfach.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 06:07:05PM +0900, Bruno Randolf wrote:
> Hmm, maybe I suck in mathemathics, but I don't see a way to do that given the 
> formula:
> 
> (((internal * (weight - 1)) + (val * factor)) / weight

I was thinking something along the lines of:

round = (1 << n) - 1;
(((internal * (weight - 1) + round) >> n) + val) * ((1 << n) / weight)

where (1 << n) is the factor and ((1 << n) / weight) can be precomputed.
If you think about it, this is just reciprocal multiplication in fixed-
point math with n bits of decimal resolution. 

The problem is the shift of the older terms introduces roundoff error, but
there are some tricks you can do to maintain bounded error, e.g. shifting
by some smaller factor of n and scaling other terms -- in the limit you
reinvent floating point and then it's slower than division :)

-- 
Bob Copeland %% www.bobcopeland.com

