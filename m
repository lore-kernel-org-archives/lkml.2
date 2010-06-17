Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab0FQEU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 00:20:59 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab0FQEUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 00:20:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mtH/2rUMA5V2MovFEttxi6lhs1N0UfB/oJ7PKc+v05GTwWCbs1/gga5sojnQLFsQs
	Tz6P+nqlxFkAQZNr4NboA==
Date: Wed, 16 Jun 2010 21:20:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/9] oom: cleanup has_intersects_mems_allowed()
In-Reply-To: <20100617104719.FB8C.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006162119540.14101@chino.kir.corp.google.com>
References: <20100617104311.FB7A.A69D9226@jp.fujitsu.com> <20100617104719.FB8C.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, KOSAKI Motohiro wrote:

> 
> Now has_intersects_mems_allowed() has own thread iterate logic, but
> it should use while_each_thread().
> 
> It slightly improve the code readability.
> 
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

I disagree that the renaming of the variables is necessary, please simply 
change the while (tsk != start) to use while_each_thread(tsk, start);
