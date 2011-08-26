Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1HZJKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 05:10:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59890 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab1HZJKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 05:10:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=VopDhsE1ACgrLq3snQVGR5uaXfhbJdmgvmur+kdwaqxVGiU9mWk9isy24CkoVY9wB
	ez4EfH/iHFeoNMsPZcyjw==
Date: Fri, 26 Aug 2011 02:09:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: Michal Hocko <mhocko@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] oom: skip frozen tasks
In-Reply-To: <4E574CA5.4010701@openvz.org>
Message-ID: <alpine.DEB.2.00.1108260209050.14732@chino.kir.corp.google.com>
References: <20110823073101.6426.77745.stgit@zurg> <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz> <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz>
 <20110825151818.GA4003@redhat.com> <20110825164758.GB22564@tiehlicka.suse.cz> <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com> <4E574CA5.4010701@openvz.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Konstantin Khlebnikov wrote:

> > A much better solution would be to lower the badness score that the oom
> > killer uses for PF_FROZEN threads so that they aren't considered a
> > priority for kill unless there's nothing else left to kill.
> 
> Anyway, oom killer shouldn't loop endlessly if it see TIF_MEMDIE on frozen
> task,
> it must go on and try to kill somebody else. We cannot wait for thawing this
> task.
> 

Did you read my suggestion?  I quoted it above again for you.  The badness 
heuristic would only select those tasks to kill as a last resort in the 
hopes they will eventually be thawed and may exit.  Panicking the entire 
machine for what could be isolated by a cgroup is insanity.
