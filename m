Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0CZR1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 13:27:12 -0400
Received: from carlson.workingcode.com ([75.150.68.97]:43292 "EHLO
	carlson.workingcode.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0CZR1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 13:27:10 -0400
X-Greylist: delayed 1349 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Mar 2010 13:27:10 EDT
Message-ID: <4BACE918.7020508@workingcode.com>
Date: Fri, 26 Mar 2010 13:04:24 -0400
From: James Carlson <carlsonj@workingcode.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Richard Hartmann <richih.mailinglist@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-ppp@vger.kernel.org
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 	multi-link
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>	 <20100326160226.0159ac3b@lxorguk.ukuu.org.uk> <v2v2d460de71003260939w4877df7em9e3084a315b0962f@mail.gmail.com>
In-Reply-To: <v2v2d460de71003260939w4877df7em9e3084a315b0962f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-DCC-dmv.com-Metrics: carlson; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Hartmann wrote:
> Also, I am not sure if it would not be better to default to no
> fragmentation and enable it optionally. I am aware that changing default
> behaviour is always a bit of a problem but to the best of my knowledge
> enabling fragmentation is a bug in any and all real-world applications.

It worked well and was enabled by default on all the Bay Networks
equipment I used ~15 years ago.  And I know for certain that we tested
with other gear (Ascend and Clam, probably) that did it right.

If it works with the equipment you're using, it's a useful feature in
that it can balance out the latencies among the links, resulting in much
lower overall latency observed by higher layers -- especially so on
lower-speed links where MP is more likely to be used.  Without it,
you're left either waiting for the one slow link choking on a big packet
to catch up, or (worse) disabling the sequence headers altogether,
resulting in reordering unless you're really "clever."

It's a darned shame that lame implementations would force a change in
the default ...

-- 
James Carlson         42.703N 71.076W         <carlsonj@workingcode.com>
