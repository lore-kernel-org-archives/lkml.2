Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2IQSGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 14:06:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38400 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2IQSGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 14:06:15 -0400
Date: Mon, 17 Sep 2012 14:06:05 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu
To: Henrik Rydberg <rydberg@euromail.se>
cc: Parag Warudkar <parag.lkml@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
In-Reply-To: <20120917162705.GA2854@polaris.bitmath.org>
Message-ID: <alpine.DEB.2.02.1209171356340.3412@ubuntu>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu> <20120915225841.GA3816@roeck-us.net> <alpine.DEB.2.02.1209151918210.2271@ubuntu> <alpine.DEB.2.02.1209152323490.2088@ubuntu> <20120916043116.GA4477@roeck-us.net> <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu> <20120916223003.GA2160@polaris.bitmath.org> <alpine.DEB.2.02.1209161957490.2808@ubuntu> <20120917162705.GA2854@polaris.bitmath.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Sep 2012, Henrik Rydberg wrote:

> The current patch does exactly the same sleeps, the only difference is
> that the test is also done before the first sleep. Thus, the increased
> delay, if any, comes from the sleep range.
My understanding is that the original patch resulted in trying a 
max udelay(16). The new one does usleep_range(16, 32). That's a minimum 16 
max 32 - so the fact that it stops read failures means the added delay is 
present and does help.

> 
> 
> The MBP10,1 experiences a lot of write errors with this patch.

Well the send_byte changes are not necessary for fixing my problem - I 
only converted it because of usleep_range() primarily. What happens if you 
drop the send_byte() part of the patch and test with only the wait_read() 
changes? I would be very surprised if that caused write or read failures. 


Parag
