Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1JTI4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:56:03 -0400
Received: from mx2.parallels.com ([64.131.90.16]:36029 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1JTI4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:56:00 -0400
Message-ID: <4E9FE1FC.8080103@parallels.com>
Date: Thu, 20 Oct 2011 12:55:24 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
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
References: <20111020013305.GD21703@tiehlicka.suse.cz>
In-Reply-To: <20111020013305.GD21703@tiehlicka.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2011 05:33 AM, Michal Hocko wrote:
> Hi all,
> this is a request for discussion (I hope we can touch this during memcg
> meeting during the upcoming KS). I have brought this up earlier this
> year before LSF (http://thread.gmane.org/gmane.linux.kernel.mm/60464).
> The patch got much smaller since then due to excellent Johannes' memcg
> naturalization work (http://thread.gmane.org/gmane.linux.kernel.mm/68724)
> which this is based on.
> I realize that this will be controversial but I would like to hear
> whether this is strictly no-go or whether we can go that direction (the
> implementation might differ of course).
>
> The patch is still half baked but I guess it should be sufficient to
> show what I am trying to achieve.
> The basic idea is that memcgs would get a new attribute (isolated) which
> would control whether that group should be considered during global
> reclaim.

I'd like to hear a bit more of your use cases, but at first, I don't 
like it. I think we should always, regardless of any knobs or 
definitions, be able to globally select a task or set of tasks, and kill 
them.

We have a slightly similar need here (we'd have to find out how 
similar...). We're working on it as well, but no patches yet (very 
basic) Let me describe it so we can see if it fits.

The main concern is with OOM behaviour of tasks within a cgroup. We'd 
like to be able to, in a per-cgroup basis:

* select how "important" a group is. OOM should try to kill less 
important memory hogs first (but note: it's less important *memory 
hogs*, not ordinary processes, and all of them are actually considered)
* select if a fat task within a group should be OOMed, or if the whole 
group should go.
* assuming an hierarchical grouping, select if we should kill children 
first
* assuming an hierarchical grouping, select if we should kill children 
at all.

This is a broader work, but I am under the impression that you should 
also be able to contemplate your needs (at least the OOM part) with such 
mechanism, by setting arbitrarily high limits on certain cgroups.

Of course it might be the case that I am not yet fully understanding 
your scenario. In this case, I'm all ears!

Thank you.
