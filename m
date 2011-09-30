Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1I3Bvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:51:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44655 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1I3Bvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:51:53 -0400
Date: Thu, 29 Sep 2011 18:51:48 -0700
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] oom: thaw threads if oom killed thread is frozen before
 deferring
Message-ID: <20110930015148.GD10425@mtj.dyndns.org>
References: <cover.1317110948.git.mhocko@suse.cz>
 <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
 <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com>
 <20110928104445.GB15062@tiehlicka.suse.cz>
 <20110929115105.GE21113@tiehlicka.suse.cz>
 <20110929120517.GA10587@redhat.com>
 <20110929130204.GG21113@tiehlicka.suse.cz>
 <20110929163724.GA23773@redhat.com>
 <20110929180021.GA27999@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929180021.GA27999@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 29, 2011 at 08:00:21PM +0200, Michal Hocko wrote:
> > I meant, oom_kill can do this before thaw thaw_process(), afaics
> > this should fix the particular race you described (but not others).
> 
> This is what the follow up fix from David is doing. Check frozen in
> select_bad_process if the task is TIF_MEMDIE and thaw the process.
> 
> And it seems that the David's follow up fix is sufficient so let's leave
> refrigerator alone.
> Or am I still missing something?

With pending freezer changes, allowing TIF_MEMDIE tasks to exit
freezer by modifying freezing() shouldn't be difficult, which should
be race-free and much simpler than diddling with thaw_task().  How
urgent is this?  Can we wait for the next merge window?

Thanks.

-- 
tejun
