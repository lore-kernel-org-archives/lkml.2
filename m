Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab0FUUPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:15:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab0FUUPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:15:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BUrNaAf8N9fPBmngRDq9c4YTFZVe2Er3biZ44Gz85pDV0E4KDiiAavHf5wOgR0gqR
	rNVIiGj41PnnQbexu2s9Q==
Date: Mon, 21 Jun 2010 13:15:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/9] oom: make oom_unkillable_task() helper function
In-Reply-To: <20100617104637.FB86.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006211314370.8367@chino.kir.corp.google.com>
References: <20100617104311.FB7A.A69D9226@jp.fujitsu.com> <20100617104637.FB86.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:

> 
> Now, we have the same task check in two places. Unify it.
> 

We should exclude tasks from select_bad_process() and oom_kill_process() 
by having badness() return a score of 0, just like it's done for 
OOM_DISABLE.
