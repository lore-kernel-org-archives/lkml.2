Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449Ab2JQJOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 05:14:47 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48156 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab2JQJOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 05:14:44 -0400
Message-ID: <507EE77D.6010906@parallels.com>
Date: Wed, 17 Oct 2012 21:14:37 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <peterz@infradead.org>, <mtosatti@redhat.com>, <mingo@redhat.com>,
        <avi@redhat.com>, <anthony@codemonkey.ws>
Subject: Re: [PATCH RFC V2 0/5] Separate consigned (expected steal) from steal
 time.
References: <20121017022249.16949.2775.stgit@lambeau>
In-Reply-To: <20121017022249.16949.2775.stgit@lambeau>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 06:23 AM, Michael Wolf wrote:
> In the case of where you have a system that is running in a
> capped or overcommitted environment the user may see steal time
> being reported in accounting tools such as top or vmstat.  This can
> cause confusion for the end user.  To ease the confusion this patch set
> adds the idea of consigned (expected steal) time.  The host will separate
> the consigned time from the steal time.  The consignment limit passed to the
> host will be the amount of steal time expected within a fixed period of
> time.  Any other steal time accruing during that period will show as the
> traditional steal time.
> 
> TODO:
> * Change native_clock to take params and not return a value
> * Change update_rq_clock_task
> 
> Changes from V1:
> * Removed the steal time allowed percentage from the guest
> * Moved the separation of consigned (expected steal) and steal time to the
>   host.
> * No longer include a sysctl interface.
> 

You are showing this in the guest somewhere, but tools like top will
still not show it. So for quite a while, it achieves nothing.

Of course this is a barrier that any new statistic has to go through. So
while annoying, this is per-se ultimately not a blocker.

What I still fail to see, is how this is useful information to be shown
in the guest. Honestly, if I'm in a guest VM or container, any time
during which I am not running is time I lost. It doesn't matter if this
was expected or not. This still seems to me as a host-side problem, to
be solved entirely by tooling.

