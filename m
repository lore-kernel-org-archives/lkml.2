Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1BSC3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 21:29:19 -0500
Received: from smtp-out.google.com ([216.239.44.51]:42159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab1BSC3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 21:29:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qKmL9Jc9GervmZsiFr9m9FVJQqDpG2cSfBxPvix+GYcHr2reie6ZsoNd9CA5vwZP9H
         +5K3guPkeDc9CmAqENfg==
MIME-Version: 1.0
In-Reply-To: <4D5DDDD7.509@cn.fujitsu.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7ED1.2070601@cn.fujitsu.com>
 <20110217144643.0d60bef4.akpm@linux-foundation.org> <AANLkTin6TqQMHSpQjNXNrgGAHG8DL6CvzhTm3KHoxv0y@mail.gmail.com>
 <4D5DDDD7.509@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Fri, 18 Feb 2011 18:28:50 -0800
Message-ID: <AANLkTinDwDbOqfnYQ8b_69iQhPzn7R26wQXPht0NgjAM@mail.gmail.com>
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 6:47 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> I think a defect of this is people might call it twice in one function
> but don't know it returns the same variable?

Hopefully they'd read the comments...

But it's not a big issue either way - having the WARN_ON() statements
in front of each use works OK too, given that there are only a few of
them.

Paul
