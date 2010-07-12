Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0GLVsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:48:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29396 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab0GLVsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:48:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Nv34b4p3+fYFxcrbhmXbJWdnQgAQCm/X+i5PvP3vqyxXc8Ja+do8mZZW5gk1mbI6X
	QvElqmR2y6/K1QYKMGy3g==
Date: Mon, 12 Jul 2010 14:47:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Divyesh Shah <dpshah@google.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: FYI: mmap_sem OOM patch
In-Reply-To: <20100708200324.CD4B.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1007121446500.8468@chino.kir.corp.google.com>
References: <20100708195421.CD48.A69D9226@jp.fujitsu.com> <1278586921.1900.67.camel@laptop> <20100708200324.CD4B.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010, KOSAKI Motohiro wrote:

> I disagree. __GFP_NOFAIL mean this allocation failure can makes really
> dangerous result. Instead, OOM-Killer should try to kill next process.
> I think.
> 

That's not what happens, __alloc_pages_high_priority() will loop forever 
for __GFP_NOFAIL, the oom killer is never recalled.
