Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1BCVWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:22:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:18349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1BCVWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:22:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=MqXR8f0KR5cYP9Ymk1Vj664NbI5YSW6jN9/fLP55hkarXCmCIij8YV09AQRmN8i94A
         EhM9th9aBFsEiHX/7Ahw==
Date: Thu, 3 Feb 2011 13:22:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC][PATCH 1/6] count transparent hugepage splits
In-Reply-To: <20110201003358.98826457@kernel>
Message-ID: <alpine.DEB.2.00.1102031235100.453@chino.kir.corp.google.com>
References: <20110201003357.D6F0BE0D@kernel> <20110201003358.98826457@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011, Dave Hansen wrote:

> 
> The khugepaged process collapses transparent hugepages for us.  Whenever
> it collapses a page into a transparent hugepage, we increment a nice
> global counter exported in sysfs:
> 
> 	/sys/kernel/mm/transparent_hugepage/khugepaged/pages_collapsed
> 
> But, transparent hugepages also get broken down in quite a few
> places in the kernel.  We do not have a good idea how how many of
> those collpased pages are "new" versus how many are just fixing up
> spots that got split a moment before.
> 
> Note: "splits" and "collapses" are opposites in this context.
> 
> This patch adds a new sysfs file:
> 
> 	/sys/kernel/mm/transparent_hugepage/pages_split
> 
> It is global, like "pages_collapsed", and is incremented whenever any
> transparent hugepage on the system has been broken down in to normal
> PAGE_SIZE base pages.  This way, we can get an idea how well khugepaged
> is keeping up collapsing pages that have been split.
> 
> I put it under /sys/kernel/mm/transparent_hugepage/ instead of the
> khugepaged/ directory since it is not strictly related to
> khugepaged; it can get incremented on pages other than those
> collapsed by khugepaged.
> 
> The variable storing this is a plain integer.  I needs the same
> amount of locking that 'khugepaged_pages_collapsed' has, for
> instance.

i.e. no global locking, but we've accepted the occassional off-by-one 
error (even though splitting of hugepages isn't by any means lightning 
fast and the overhead of atomic ops would be negligible).

> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
