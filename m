Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1HYU5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:57:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30553 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab1HYU5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:57:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=w/3xJ4dw9VGwtoUcdubyZxQbHx19HlyvkIk9Bsy5ygfFWEcFjHxHWPFKhLtP/ott1
	BL367FFzYcZ0HHQJOOEQg==
Date: Thu, 25 Aug 2011 13:57:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Cong Wang <amwang@redhat.com>
cc: Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [Patch] numa: introduce CONFIG_NUMA_SYSFS for
 drivers/base/node.c
In-Reply-To: <4E562248.2090102@redhat.com>
Message-ID: <alpine.DEB.2.00.1108251356220.18747@chino.kir.corp.google.com>
References: <20110804145834.3b1d92a9eeb8357deb84bf83@canb.auug.org.au> <20110804152211.ea10e3e7.rdunlap@xenotime.net> <20110823143912.0691d442.akpm@linux-foundation.org> <4E547155.8090709@redhat.com> <20110824191430.8a908e70.rdunlap@xenotime.net>
 <4E55C221.8080100@redhat.com> <20110824205044.7ff45b6c.rdunlap@xenotime.net> <alpine.DEB.2.00.1108242202050.576@chino.kir.corp.google.com> <4E562248.2090102@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011, Cong Wang wrote:

> > No, it doesn't work, CONFIG_HUGETLBFS can be enabled with CONFIG_NUMA=y
> > and CONFIG_SYSFS=n and that uses data structures from drivers/base/node.c
> > which doesn't get compiled with this patch.
> 
> So, you mean with CONFIG_NUMA=y && CONFIG_SYSFS=n && CONFIG_HUGETLBFS=y
> we still get compile error?
> 
> Which data structures are used by hugetlbfs?
> 

node_states[], which is revealed at link time if you tried to compile your 
patch.  It's obvious that we don't want to add per-node hugetlbfs 
attributes to sysfs directories if sysfs is disabled, so you need to 
modify the hugetlbfs code as well.
