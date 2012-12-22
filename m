Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2LVAhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 19:37:01 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:53392 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2LVAg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 19:36:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121221231024.GG13367@suse.de>
References: <1353624594-1118-1-git-send-email-mingo@kernel.org>
 <1353624594-1118-19-git-send-email-mingo@kernel.org> <alpine.DEB.2.00.1212031644440.32354@chino.kir.corp.google.com>
 <CA+55aFyrSVzGZ438DGnTFuyFb1BOXaMmvxtkW0Xhnx+BxAg2PA@mail.gmail.com>
 <alpine.DEB.2.00.1212201440250.7807@chino.kir.corp.google.com>
 <20121221134740.GC13367@suse.de> <CA+55aFxrdPpMWLD8LF0NNqgJqmB-L-HW3Xyxht6e5AwnoaueTw@mail.gmail.com>
 <20121221195817.GE13367@suse.de> <CA+55aFwDXj3LqCRepsaeZMjOg0YsWV=7GFLHqHe2CxoF4JchCQ@mail.gmail.com>
 <20121221231024.GG13367@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 21 Dec 2012 16:36:36 -0800
X-Google-Sender-Auth: fRBRa2e7LdNEwW8fle9EH2HkhaA
Message-ID: <CA+55aFza356-L4F2RC1UP3ujDLoTU2352s3o171mQOQHJRaktw@mail.gmail.com>
Subject: Re: [patch] mm, mempolicy: Introduce spinlock to read shared policy tree
To: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, this looks fine to me, but I'd like to get a sign-off from Kosaki
too, and I guess it's really not all that urgent, so I can do the -rc1
release tonight without worrying about it, knowing that a fix is at
least pending, and that nobody is likely to actually ever hit the
problem in practice anyway.

             Linus

On Fri, Dec 21, 2012 at 3:10 PM, Mel Gorman <mgorman@suse.de> wrote:
>
> mm: mempolicy: Convert shared_policy mutex to spinlock
