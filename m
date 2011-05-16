Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab1EPUqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:46:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24861 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab1EPUqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:46:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ObyAIv5Jt5v245PbCkhy8p7pOcXbPAd6rlxZzXgkYVSuUYerSwclmBn7CW2nOaKpQ+
         bDk4B5SdgJqYw9f9x+5w==
Date: Mon, 16 May 2011 13:46:06 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: CAI Qian <caiqian@redhat.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, avagin@gmail.com,
        Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: OOM Killer don't works at all if the system have >gigabytes
 memory (was Re: [PATCH] mm: check zone->all_unreclaimable in
 all_unreclaimable())
In-Reply-To: <958295827.17529.1305269596598.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Message-ID: <alpine.DEB.2.00.1105161343120.4353@chino.kir.corp.google.com>
References: <958295827.17529.1305269596598.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011, CAI Qian wrote:

> I have had a chance to test this patch after applied this patch manually
> (dd not apply cleanly) on the top of mainline kernel. The test is still
> running because it is trying to kill tons of python processes instread
> of the parent. Isn't there a way for oom to be smart enough to do
> "killall python"?

Not without userspace doing that explicitly, the oom killer attempts to 
only kill the most memory-hogging task to free memory.  If you're test is 
constantly forking new processes which allocate memory then the oom killer 
will just keep killing those children anytime it is out of memory.
