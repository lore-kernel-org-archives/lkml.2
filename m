Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2DTSLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:11:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab2DTSLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:11:37 -0400
Subject: Re: remove unnecessary ftrace WARN_ONCE's.
From: Steven Rostedt <srostedt@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, laijs@cn.fujitsu.com,
        fweisbec@gmail.com, mingo@elte.hu
In-Reply-To: <20120420170356.GC2168@redhat.com>
References: <20120412023132.GA7035@redhat.com>
	 <20120420170356.GC2168@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 20 Apr 2012 14:11:23 -0400
Message-ID: <1334945483.5763.2.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 13:03 -0400, Dave Jones wrote:
> On Wed, Apr 11, 2012 at 10:31:32PM -0400, Dave Jones wrote:
>  > These warnings are trivially triggerable by any user, and serve no useful purpose afaics
>  > Just -EINVAL and be done.
>  > 
>  > Signed-off-by: Dave Jones <davej@redhat.com>
>  > 
>  > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
>  > index ed7b5d1..a745317 100644
>  > --- a/kernel/trace/trace.c
>  > +++ b/kernel/trace/trace.c
>  > @@ -4136,13 +4136,11 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  >  		return -ENOMEM;
>  >  
>  >  	if (*ppos & (PAGE_SIZE - 1)) {
>  > -		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
>  >  		ret = -EINVAL;
>  >  		goto out;
>  >  	}
>  >  
>  >  	if (len & (PAGE_SIZE - 1)) {
>  > -		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
>  >  		if (len < PAGE_SIZE) {
>  >  			ret = -EINVAL;
>  >  			goto out;
>  > --
> 
> Anyone want to pick this up, or shall I just send it to Linus myself ?

I can pick this up, if you don't mind them going in on 3.5. As they are
only WARN_ONCE errors, I don't think they are that big of a deal.

-- Steve


