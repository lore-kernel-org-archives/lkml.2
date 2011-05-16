Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1EPVeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:34:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57541 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab1EPVeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=jQbATS6cJy4FDTzIMZr+Z45BEw3j/3A7x+8QmHxI2jqYVvLsREQ0IFa5d07osQmnp9
         mhxWcK2ni/y4DDTG6I3Q==
Date: Mon, 16 May 2011 14:34:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Nazarewicz <mina86@mina86.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        "Ted Ts'o" <tytso@mit.edu>, Jiri Slaby <jirislaby@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] checkpatch.pl: Add check for task comm references
In-Reply-To: <op.vvlfaobx3l0zgt@mnazarewicz-glaptop>
Message-ID: <alpine.DEB.2.00.1105161431550.4353@chino.kir.corp.google.com>
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org> <1305580757-13175-4-git-send-email-john.stultz@linaro.org> <op.vvlfaobx3l0zgt@mnazarewicz-glaptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Michal Nazarewicz wrote:

> > Now that accessing current->comm needs to be protected,
> > @@ -2868,6 +2868,10 @@ sub process {
> > 			WARN("usage of NR_CPUS is often wrong - consider using
> > cpu_possible(), num_possible_cpus(), for_each_possible_cpu(), etc\n" .
> > $herecurr);
> > 		}
> > +# check for current->comm usage
> > +		if ($line =~ /\b(?:current|task|tsk|t)\s*->\s*comm\b/) {
> 
> Not a checkpatch.pl expert but as far as I'm concerned, that looks reasonable.
> 
> I was sort of worried that t->comm could produce quite a few false positives
> but all its appearances in the kernel (seem to) refer to task.
> 

It's guaranteed to generate false positives since perf events uses a field 
of the same name to store a thread's comm, so I think the most important 
thing is for the checkpatch output to specify that this _may_ be a 
dereference of a thread's comm that needs get_task_comm() or %ptc.
