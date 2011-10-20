Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1JTQmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:42:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125Ab1JTQmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:42:12 -0400
Date: Thu, 20 Oct 2011 09:42:06 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>, GregThelen <gthelen@google.com>,
        "pjt@google.com" <pjt@google.com>, Tim Hockin <thockin@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFD] Isolated memory cgroups again
Message-ID: <20111020164205.GC25505@tiehlicka.suse.cz>
References: <20111020013305.GD21703@tiehlicka.suse.cz>
 <4E9FE1FC.8080103@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9FE1FC.8080103@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-10-11 12:55:24, Glauber Costa wrote:
> On 10/20/2011 05:33 AM, Michal Hocko wrote:
> >Hi all,
> >this is a request for discussion (I hope we can touch this during memcg
> >meeting during the upcoming KS). I have brought this up earlier this
> >year before LSF (http://thread.gmane.org/gmane.linux.kernel.mm/60464).
> >The patch got much smaller since then due to excellent Johannes' memcg
> >naturalization work (http://thread.gmane.org/gmane.linux.kernel.mm/68724)
> >which this is based on.
> >I realize that this will be controversial but I would like to hear
> >whether this is strictly no-go or whether we can go that direction (the
> >implementation might differ of course).
> >
> >The patch is still half baked but I guess it should be sufficient to
> >show what I am trying to achieve.
> >The basic idea is that memcgs would get a new attribute (isolated) which
> >would control whether that group should be considered during global
> >reclaim.
> 
> I'd like to hear a bit more of your use cases,

The primary goal is to isolate the primary workload (e.g. database) from
the rest of the system which provide a support for the primary workload
(backups, administration tools etc). While we can do that even now just
by wrapping everything into different groups and set up proper limits it
gets really tricky if you want to overcommit the box because then the
global reclaim is inevitable so we will start reclaiming from all
groups.

> but at first, I don't like it. I think we should always, regardless of
> any knobs or definitions, be able to globally select a task or set of
> tasks, and kill them.

The patchset is not about OOM but rather about the reclaim. If there is
a global OOM situation we do not care about isolated memcgs.

[...]
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
