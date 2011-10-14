Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1JNCMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 22:12:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:9586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab1JNCMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 22:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="63103002"
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: glommer@parallels.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        paul@paulmenage.org, gthelen@google.com, netdev@vger.kernel.org,
        linux-mm@kvack.org, kirill@shutemov.name, avagin@parallels.com,
        devel@openvz.org
Subject: Re: [PATCH v7 0/8] Request for inclusion: tcp memory buffers
References: <1318511382-31051-1-git-send-email-glommer@parallels.com>
	<20111013.160031.605700447623532119.davem@davemloft.net>
Date: Thu, 13 Oct 2011 19:12:29 -0700
In-Reply-To: <20111013.160031.605700447623532119.davem@davemloft.net> (David
	Miller's message of "Thu, 13 Oct 2011 16:00:31 -0400 (EDT)")
Message-ID: <m2d3e01fua.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
> Make this evaluate into exactly the same exact code stream we have
> now when the memory cgroup feature is not in use, which will be the
> majority of users.

One possible way may be to guard it with static_branch() for 
no limit per cgroup set. That should be as near as practically
possible to the original code.

BTW the thing that usually worries me more is the cache line behaviour
when the feature is in use. In the past some of the namespace patches
have created some extremly hot global cache lines, that hurt on larger
systems (for example the Unix socket regression from uid namespaces that
is still not completly fixed). It would be good to double check that all
important state is distributed properly.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
