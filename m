Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab1HYPVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:21:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab1HYPVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:21:35 -0400
Date: Thu, 25 Aug 2011 17:18:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] oom: skip frozen tasks
Message-ID: <20110825151818.GA4003@redhat.com>
References: <20110823073101.6426.77745.stgit@zurg> <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz> <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825091920.GA22564@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25, Michal Hocko wrote:
>
> On Wed 24-08-11 12:31:26, David Rientjes wrote:
> >
> > That's obviously false since we call oom_killer_disable() in 
> > freeze_processes() to disable the oom killer from ever being called in the 
> > first place, so this is something you need to resolve with Rafael before 
> > you cause more machines to panic.
>
> I didn't mean suspend/resume path (that is protected by oom_killer_disabled)
> so the patch doesn't make any change.

Confused... freeze_processes() does try_to_freeze_tasks() before
oom_killer_disable() ?

Oleg.

