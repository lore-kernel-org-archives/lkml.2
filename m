Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1EFRuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 13:50:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51178 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024Ab1EFRux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 13:50:53 -0400
Date: Fri, 6 May 2011 19:50:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] time: xtime_lock is held too long
Message-ID: <20110506175051.GL11636@one.firstfloor.org>
References: <1304574244.32152.666.camel@edumazet-laptop> <1304576495.2943.40.camel@work-vm> <1304604284.3032.78.camel@edumazet-laptop> <alpine.LFD.2.02.1105051630390.3005@ionos> <1304608095.3032.95.camel@edumazet-laptop> <alpine.LFD.2.02.1105051750540.3005@ionos> <20110505210118.GI2925@one.firstfloor.org> <alpine.LFD.2.02.1105061117220.3005@ionos> <20110506165913.GF11636@one.firstfloor.org> <1304703767.3066.211.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1304703767.3066.211.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 07:42:47PM +0200, Eric Dumazet wrote:
> Le vendredi 06 mai 2011 à 18:59 +0200, Andi Kleen a écrit :
> 
> > If you have a better way to make it faster please share it.
> 
> Ideally we could use RCU :)

Hmm, I didn't think my case had a lot of loops in the seqlock -- just
expensive cache misses -- but I should double check.

For the lots of loop case we probably need to understand first why you
iterate that often.

-Andi
