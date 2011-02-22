Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab1BVWwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:52:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:57069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab1BVWwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:52:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,208,1297065600"; 
   d="scan'208";a="890231388"
Message-ID: <4D643E1B.7050507@linux.intel.com>
Date: Tue, 22 Feb 2011 14:52:11 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        lwoodman@redhat.com
Subject: Re: [PATCH 6/8] Add __GFP_OTHER_NODE flag
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-7-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1102221333100.5929@chino.kir.corp.google.com> <4D642F03.5040800@linux.intel.com> <alpine.DEB.2.00.1102221402150.5929@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1102221402150.5929@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You could make the same argument for anything using kmalloc_node() since
> preferred_zone may very well not be on the allocating cpu's node.

You're right. It is not always, that is why I defined a new flag. In the 
cases where the flag
is passed it is.



>   So you
> either define NUMA_LOCAL to account for when a cpu allocates memory local
> to itself (as it's name implies) or you define it to account for when
> memory comes from the preferred_zone's node as determined by the zonelist.

That's already numa_hit as you say.

I just don't think "local to some random kernel daemon that means 
nothing to the user"
is a useful definition for local_hit.

When I defined the counter I intended it to be local to the user 
process. It always was like
that too, just THP changed the rules.

-Andi


