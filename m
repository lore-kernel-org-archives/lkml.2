Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab0FAV1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:27:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45642 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab0FAV1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:27:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=W+RH3kGq59Vx7YncqGoO7u2L6sCXwK7+tocTXqlV8f93ecDRPQeVN0pgHX5CM9QLz
	ayqYL+NVB6P5c8v1+Hgvw==
Date: Tue, 1 Jun 2010 14:26:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Oleg Nesterov <oleg@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/5] oom: select_bad_process: check PF_KTHREAD instead
 of !mm to skip kthreads
In-Reply-To: <20100601212023.GA24917@redhat.com>
Message-ID: <alpine.DEB.2.00.1006011424200.16725@chino.kir.corp.google.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006011333470.13136@chino.kir.corp.google.com> <20100601212023.GA24917@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Oleg Nesterov wrote:

> But yes, I agree, the problem is minor. But nevertheless it is bug,
> the longstanding bug with the simple fix. Why should we "hide" this fix
> inside the long series of non-trivial patches which rewrite oom-killer?
> And it is completely orthogonal to other changes.
> 

Again, the question is whether or not the fix is rc material or not, 
otherwise there's no difference in the route that it gets upstream: the 
patch is duplicated in both series.  If you feel that this minor issue 
(which has never been reported in at least the last three years and 
doesn't have any side effects other than a couple of millisecond delay 
until unuse_mm() when the oom killer will kill something else) should be 
addressed in 2.6.35-rc2, then that's a conversation to be had with Andrew.
