Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1JVJ0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 05:26:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab1JVJ03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 05:26:29 -0400
Date: Sat, 22 Oct 2011 11:26:16 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>,
        Kir Kolyshkin <kir@parallels.com>,
        Pavel Emelianov <xemul@parallels.com>, GregThelen <gthelen@google.com>,
        "pjt@google.com" <pjt@google.com>, Tim Hockin <thockin@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [RFD] Isolated memory cgroups again
Message-ID: <20111022092524.GA5497@tiehlicka.suse.cz>
References: <20111020013305.GD21703@tiehlicka.suse.cz>
 <20111020105950.fd04f58f.kamezawa.hiroyu@jp.fujitsu.com>
 <CAKTCnz=iZp37sBfY++HUU0oscskFF_UWYeFYtAujtQh4_B=vHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTCnz=iZp37sBfY++HUU0oscskFF_UWYeFYtAujtQh4_B=vHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 21-10-11 21:34:06, Balbir Singh wrote:
> On Thu, Oct 20, 2011 at 7:29 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Wed, 19 Oct 2011 18:33:09 -0700
> > Michal Hocko <mhocko@suse.cz> wrote:
> >
> >> Hi all,
> >> this is a request for discussion (I hope we can touch this during memcg
> >> meeting during the upcoming KS). I have brought this up earlier this
> >> year before LSF (http://thread.gmane.org/gmane.linux.kernel.mm/60464).
> >> The patch got much smaller since then due to excellent Johannes' memcg
> >> naturalization work (http://thread.gmane.org/gmane.linux.kernel.mm/68724)
> >> which this is based on.
> >
> 
> Hi, Michal

Hi Balbir,

> 
> I'd like to understand, what the isolation is for?
> 
> 1. Is it an alternative to memory guarantees?

Not really, it is more about resident working set guarantee and workload
isolations wrt. memory.

> 2. How is this different from doing cpusets (fake NUMA) and isolating them?

Yes this would work. I have not many experiences in this area but I
guess the primary stopper for fake NUMA is that it is x86_64 only,
configuration is static and little bit awkward to use (nodes of the same
size e.g.).
I understood that google is moving out of fake NUMA towards memcg for those
reasons.

> 
> Just trying to catch up,
> Balbir

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
