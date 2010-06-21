Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab0FUUKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:10:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23634 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0FUUKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:10:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=qNh9u+bP8hP0u+cPoUvV2MZD781LBBZ7YR8VwqJjXH5hWYs997gGIA5zEf/BSiKxf
	KQ9/nEBBBWnnbk4AdhrZg==
Date: Mon, 21 Jun 2010 13:09:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/9] oom: cleanup has_intersects_mems_allowed()
In-Reply-To: <20100617134601.FBA7.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006211305590.8367@chino.kir.corp.google.com>
References: <20100617104719.FB8C.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1006162119540.14101@chino.kir.corp.google.com> <20100617134601.FBA7.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, KOSAKI Motohiro wrote:

> > I disagree that the renaming of the variables is necessary, please simply 
> > change the while (tsk != start) to use while_each_thread(tsk, start);
> 
> This is common naming rule of while_each_thread(). please grep.
> 

I disagree, there's no sense in substituting variable names like "tsk" for 
`p' and removing a very clear and obvious "start" task: it doesn't improve 
code readability.

I'm in favor of changing the while (tsk != start) to 
while_each_thread(tsk, start) which is very trivial to understand and much 
more readable than while_each_thread(p, tsk).  With the latter, it's not 
clear whether `p' or "tsk" is the iterator and which is the constant.
