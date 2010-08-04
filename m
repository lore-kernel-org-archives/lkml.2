Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab0HDQKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:10:53 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:56876 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab0HDQKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:10:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dcaV+Yb7G8cyxJpOY59+zT9r/ygTYG7rr7J6cgHB6ZEuHx3UKbc6RY2kLRVGwQvpDp
         GaTik2/xgsK2/idYZkg+As+ywKs3lLAJ1GgD/VBpWCppgJ5EsaiK/TLFfPXuYaIQTBc2
         nwCPp//VasOQl53mBgZ7nLoys3IHWF7IL1LXY=
Date: Wed, 4 Aug 2010 20:10:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804161046.GC5130@lenovo>
References: <1280913670.20797.179.camel@minggr.sh.intel.com> <20100804100116.GH26154@erda.amd.com> <20100804140021.GN3353@redhat.com> <1280931093.1923.1194.camel@laptop> <20100804145203.GP3353@redhat.com> <1280934161.1923.1294.camel@laptop> <20100804151858.GB5130@lenovo> <20100804155002.GS3353@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804155002.GS3353@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 11:50:02AM -0400, Don Zickus wrote:
...
> > 
> > Well, first I guess having Yinghai CC'ed is a bonus ;)
> > The second thing is that I don't get why perf handler can't be _last_
> > call in default_do_nmi, if there were any nmi with reason (serr or parity)
> > I think they should be calling first which of course don't eliminate
> > the former issue but somewhat make it weaken.
> 
> Because the reason registers are never set.  If they were, then the code
> wouldn't have to walk the notify_chain. :-)
> 

maybe we're talking about different things. i meant that if there is nmi
with a reason (from 0x61) the handling of such nmi should be done before
notify_die I think (if only I not miss something behind).

> Unknown nmis are unknown nmis, nobody is claiming them.  Even worse, there
> are customers that want to register their nmi handler below the perf
> handler to claim all the unknown nmis, so they can be logged on the system
> before being rebooted.

well, perhaps we might need some kind of perf_chain in notifier code and
call for it after die_nmi chain, so the customers you mention may add own
chain for being called last.

> 
> Cheers,
> Don
> 
	-- Cyrill
