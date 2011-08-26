Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1HZSV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:21:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1HZSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:21:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=N+vM6spN044qCSwVA+IL3x0lSy2uU1cU2lD5NMKpackePK853hr33ttZuZ5VJTooH
	s8pKLQXetHiZnpUKxxGrw==
Date: Fri, 26 Aug 2011 11:21:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: VM: add would_have_oomkilled sysctl
In-Reply-To: <20110826161422.GB30573@redhat.com>
Message-ID: <alpine.DEB.2.00.1108261117550.13943@chino.kir.corp.google.com>
References: <20110826161422.GB30573@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011, Dave Jones wrote:

> At various times in the past, we've had reports where users have been
> convinced that the oomkiller was too heavy handed. I added this sysctl
> mostly as a knob for them to see that the kernel really doesn't do much better
> without killing something.
> 

The page allocator expects that the oom killer will kill something to free 
memory so it takes a temporary timeout and then retries the allocation 
indefinitely.  We never oom kill unless we are going to retry 
indefinitely, otherwise it wouldn't be worthwhile.

That said, the only time the oom killer doesn't actually do something is 
when it detects an exiting thread that will hopefully free memory soon or 
when it detects an eligible thread that has already been oom killed and 
we're waiting for it to exit.  So this patch will result in an endless 
series of unratelimited printk's.

Not sure that's very helpful.
