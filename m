Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab1HYFEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 01:04:33 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35069 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1HYFEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 01:04:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=T4OjfXVw4+XG/lqziPq075MeSzTSE6P6eTnrZC09crJJEBpZfBhp/QYLYNPon7vI/
	XfrE1+milCeE1C3/s7aPg==
Date: Wed, 24 Aug 2011 22:04:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Cong Wang <amwang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [Patch] numa: introduce CONFIG_NUMA_SYSFS for
 drivers/base/node.c
In-Reply-To: <20110824205044.7ff45b6c.rdunlap@xenotime.net>
Message-ID: <alpine.DEB.2.00.1108242202050.576@chino.kir.corp.google.com>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au> <20110804152211.ea10e3e7.rdunlap@xenotime.net> <20110823143912.0691d442.akpm@linux-foundation.org> <4E547155.8090709@redhat.com> <20110824191430.8a908e70.rdunlap@xenotime.net>
 <4E55C221.8080100@redhat.com> <20110824205044.7ff45b6c.rdunlap@xenotime.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Randy Dunlap wrote:

> > Below is the updated version.
> > 
> > Thanks for testing!
> 
> Yes, that works after changing #ifdef defined(...)
> to #if defined(...)
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 

No, it doesn't work, CONFIG_HUGETLBFS can be enabled with CONFIG_NUMA=y 
and CONFIG_SYSFS=n and that uses data structures from drivers/base/node.c 
which doesn't get compiled with this patch.
