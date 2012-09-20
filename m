Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2ITS05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:26:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36831 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab2ITS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:26:56 -0400
Date: Thu, 20 Sep 2012 11:26:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.org>, Michal Hocko <mhocko@suse.cz>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Turner <pjt@google.com>, Ingo Molnar <mingo@elte.hu>,
        serge.hallyn@canonical.com
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120920182651.GH28934@google.com>
References: <20120913205827.GO7677@google.com>
 <505A725B.2080901@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505A725B.2080901@amacapital.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 19, 2012 at 06:33:15PM -0700, Andy Lutomirski wrote:
> [grr.  why does gmane scramble addresses?]

You can append /raw to the message url and see the raw mssage.

  http://article.gmane.org/gmane.linux.kernel.containers/23802/raw

> >   I think this level of flexibility should be enough for most use
> >   cases.  If someone disagrees, please voice your objections now.
> 
> OK, I'll bite.
> 
> I have a server that has a whole bunch of cores.  A small fraction of
> those cores are general purpose and run whatever they like.  The rest
> are tightly controlled.
> 
> For simplicity, we have two cpusets that we use.  The root allows all
> cpus.  The other one only allows the general purpose cpus.  We shove
> everything into the general-purpose-only cpuset, and then we move
> special stuff back to root.  (We also shove some kernel threads into a
> non-root cpuset using the 'cset' tool.)

Using root for special stuff probably isn't a good idea and moving
bound kthreads into !root cgroups is already disallowed.

> Enter systemd, which wants a hierarchy corresponding to services.  If we
> were to use it, we might end up violating its hierarchy.
> 
> Alternatively, if we started using memcg, then we might have some tasks
> to have more restrictive memory usage but less restrictive cpu usage.
> 
> As long as we can still pull this off, I'm happy.

IIUC, you basically want just two groups w/ cpuset and use it for
loose cpu ioslation for high priority jobs.  Structure-wise, I don't
think it's gonna be a problem although using root for special stuff
would need to change.

Thanks.

-- 
tejun
