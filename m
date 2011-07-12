Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758167Ab1GLASm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 20:18:42 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57335 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1GLASl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 20:18:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jul 2011 09:11:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 5/7] cgroups: Ability to stop res charge propagation on
 bounded ancestor
Message-Id: <20110712091131.e74d18f4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1310393706-321-6-git-send-email-fweisbec@gmail.com>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
	<1310393706-321-6-git-send-email-fweisbec@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jul 2011 16:15:04 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Moving a task from a cgroup to another may require to substract
> its resource charge from the old cgroup and add it to the new one.
> 
> For this to happen, the uncharge/charge propagation can just stop
> when we reach the common ancestor for the two cgroups. Further
> the performance reasons, we also want to avoid to temporarily
> overload the common ancestors with a non-accurate resource
> counter usage if we charge first the new cgroup and uncharge the
> old one thereafter. This is going to be a requirement for the coming
> max number of task subsystem.
> 
> To solve this, provide a pair of new API that can charge/uncharge
> a resource counter until we reach a given ancestor.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul Menage <menage@google.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Aditya Kali <adityakali@google.com>


Hmm, do you have the number to show the benefit of this new function ?
And....tasks is moving among cgroups so frequently as to show the benefit
of this function in your environment ??

Thanks,
-Kame

