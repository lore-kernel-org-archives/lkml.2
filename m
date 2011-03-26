Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab1CZCfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 22:35:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22683 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab1CZCfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 22:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jiPMlmagVTSsk7Ifz2bQFb8Frqoi0UjMmzSzjMWqvG1lhPIdzWymODiWfL8CNorVKr
         7MxRMcS1G2VwDaRm529A==
Date: Fri, 25 Mar 2011 19:34:52 -0700
From: Michel Lespinasse <walken@google.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 0/4] forkbomb killer
Message-ID: <20110326023452.GA8140@google.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
 <20110324105222.GA2625@barrios-desktop>
 <20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
 <BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
 <20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
 <BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 01:05:50PM +0900, Minchan Kim wrote:
> Okay. Each approach has a pros and cons and at least, now anyone
> doesn't provide any method and comments but I agree it is needed(ex,
> careless and lazy admin could need it strongly). Let us wait a little
> bit more. Maybe google guys or redhat/suse guys would have a opinion.

I haven't heard of fork bombs being an issue for us (and it's not been
for me on my desktop, either).

Also, I want to point out that there is a classical userspace solution
for this, as implemented by killall5 for example. One can do
kill(-1, SIGSTOP) to stop all processes that they can send
signals to (except for init and itself). Target processes
can never catch or ignore the SIGSTOP. This stops the fork bomb
from causing further damage. Then, one can look at the process
tree and do whatever is appropriate - including killing by uid,
by cgroup or whatever policies one wants to implement in userspace.
Finally, the remaining processes can be restarted using SIGCONT.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
