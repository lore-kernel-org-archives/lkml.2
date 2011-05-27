Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1E0TNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:13:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab1E0TNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ytvSYw6muvGoannUb+xiGhZi6O5CKFhiZJIc8ct66Hq/KpZadu9sPWJqArUZuF0Uej
         hXxZGz50BBfE93b7/5fQ==
Date: Fri, 27 May 2011 12:12:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: CAI Qian <caiqian@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
        kamezawa hiroyu <kamezawa.hiroyu@jp.fujitsu.com>,
        minchan kim <minchan.kim@gmail.com>, oleg@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
In-Reply-To: <241133039.238335.1306393713338.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Message-ID: <alpine.DEB.2.00.1105271211050.2533@chino.kir.corp.google.com>
References: <241133039.238335.1306393713338.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011, CAI Qian wrote:

> Here is the results for the testing. Running the reproducer as non-root
> user, the results look good as OOM killer just killed each python process
> in-turn that the reproducer forked. However, when running it as root
> user, sshd and other random processes had been killed.
> 

Thanks for testing!  The patch that I proposed for you was a little more 
conservative in terms of providing a bonus to root processes that aren't 
using a certain threshold of memory.  My latest proposal was to give root 
processes only a 1% bonus for every 10% of memory they consume, so it 
would be impossible for them to have an oom score of 1 as reported in your 
logs.

I believe that KOSAKI-san is refreshing his series of patches, so let's 
look at how your workload behaves on the next iteration.  Thanks CAI!
