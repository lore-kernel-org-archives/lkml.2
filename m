Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0FAUgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:36:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25001 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab0FAUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:36:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FrbLa0ceErZpPgCyuw2/BprDoOCnLjb+A5w/FeUUuDTPSmAv3ZUcubYGR//0DOrgj
	XfQfaDYtriWIYJbLwXMAQ==
Date: Tue, 1 Jun 2010 13:36:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/5] oom: select_bad_process: check PF_KTHREAD instead
 of !mm to skip kthreads
In-Reply-To: <20100531182526.1843.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006011333470.13136@chino.kir.corp.google.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010, KOSAKI Motohiro wrote:

> From: Oleg Nesterov <oleg@redhat.com>
> Subject: oom: select_bad_process: check PF_KTHREAD instead of !mm to skip kthreads
> 
> select_bad_process() thinks a kernel thread can't have ->mm != NULL, this
> is not true due to use_mm().
> 
> Change the code to check PF_KTHREAD.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

This is already pushed in my oom killer rewrite as patch 14/18 "check 
PF_KTHREAD instead of !mm to skip kthreads".

This does not need to be merged immediately since it's not vital: use_mm() 
is only temporary state and these kthreads will once again be excluded 
when they call unuse_mm().  The worst case scenario here is that the oom 
killer will erroneously select one of these kthreads which cannot die and 
will need to reselect another task on its next call.
