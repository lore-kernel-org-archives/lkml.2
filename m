Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071Ab1IWK0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:26:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab1IWK0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:26:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tIfxm7q+yalGNgebs1sR+MwsdXnfqneFoxVPCtH3LUgLQayEZVzGMjUqMKEeZ64QS
	MyDchcrE/gh9ve4x3HXHw==
MIME-Version: 1.0
In-Reply-To: <20110922161539.d947e014.akpm@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<1316230753-8693-8-git-send-email-walken@google.com>
	<20110922161539.d947e014.akpm@google.com>
Date: Fri, 23 Sep 2011 03:26:30 -0700
Message-ID: <CANN689E7GyTB7RLng9M4aF9vQNOFd8gjLr5fKoWpmOYsM3UJNA@mail.gmail.com>
Subject: Re: [PATCH 7/8] kstaled: add histogram sampling functionality
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 4:15 PM, Andrew Morton <akpm@google.com> wrote:
> On Fri, 16 Sep 2011 20:39:12 -0700
> Michel Lespinasse <walken@google.com> wrote:
>
>> add statistics for pages that have been idle for 1,2,5,15,30,60,120 or
>> 240 scan intervals into /dev/cgroup/*/memory.idle_page_stats
>
> Why?  What's the use case for this feature?

In the fakenuma implementation of kstaled, we were able to configure a
different scan rate for each container (which was represented in the
kernel as a set of fakenuma nodes, rather than a memory cgroup). This
was used to reclaim memory more agressively from some containers than
others, by varying the interval after which pages would be considered
idle.

In the memcg implementation, scanning is done globally so we can't
configure a per-cgroup rate. Instead, we track the number of scan
cycles that each page has been observed to be idle for. At that point,
we could have a per-cgroup configurable threshold and report pages
that have been idle for longer than that number of scans; however it
seemed nicer to provide a full histogram since the information is
actually available.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
