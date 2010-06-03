Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab0FCGfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:35:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33812 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab0FCGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:34:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JkgvGdxYtQR3lWdKjzzW7JxXH3z7BiO+42LpI6/j+oPgyThAwXmyhLA8hUzHa92yY
	z0fXgnPzwPkSoWVMmH64A==
Date: Wed, 2 Jun 2010 23:34:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 09/12] oom: remove PF_EXITING check completely
In-Reply-To: <20100603152436.7262.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006022332320.22441@chino.kir.corp.google.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com> <20100603152436.7262.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jun 2010, KOSAKI Motohiro wrote:

> Currently, PF_EXITING check is completely broken. because 1) It only
> care main-thread and ignore sub-threads

Then check the subthreads.

> 2) If user enable core-dump
> feature, it can makes deadlock because the task during coredump ignore
> SIGKILL.
> 

It may ignore SIGKILL, but does not ignore fatal_signal_pending() being 
true which gives it access to memory reserves with my patchset so that it 
may quickly finish.

> The deadlock is certenaly worst result, then, minor PF_EXITING
> optimization worth is relatively ignorable.
> 
> This patch removes it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>

Nacked-by: David Rientjes <rientjes@google.com>

You have no real world experience in using the oom killer for memory 
containment and don't understand how critical it is to protect other 
vital system tasks that are needlessly killed as the result of this patch.
