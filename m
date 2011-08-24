Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab1HXTbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 15:31:35 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26269 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1HXTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 15:31:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=hmu34CjL3/DU4+ZmjRUUlrGQVKyKD8She2Dal36uYej0LJXp2geUMphVLo+mmzXXD
	/6J98Gf5XNe8bjMml4egQ==
Date: Wed, 24 Aug 2011 12:31:26 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] oom: skip frozen tasks
In-Reply-To: <20110824101927.GB3505@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com>
References: <20110823073101.6426.77745.stgit@zurg> <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com> <20110824101927.GB3505@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Michal Hocko wrote:

> When we are in the global OOM condition then you are right, we have a
> higher chance to panic. I still find the patch an improvement because
> encountering a frozen task and looping over it without any progress
> (even though there are other tasks that could be killed) is more
> probable than having no killable task at all.
> On non-NUMA machines there is even not a big chance that somebody would
> be able to thaw a task as the system is already on knees.
> 

That's obviously false since we call oom_killer_disable() in 
freeze_processes() to disable the oom killer from ever being called in the 
first place, so this is something you need to resolve with Rafael before 
you cause more machines to panic.
