Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab2DTREQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:04:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab2DTREP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:04:15 -0400
Date: Fri, 20 Apr 2012 13:03:56 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, laijs@cn.fujitsu.com,
        fweisbec@gmail.com, srostedt@redhat.com, mingo@elte.hu
Subject: Re: remove unnecessary ftrace WARN_ONCE's.
Message-ID: <20120420170356.GC2168@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, laijs@cn.fujitsu.com,
	fweisbec@gmail.com, srostedt@redhat.com, mingo@elte.hu
References: <20120412023132.GA7035@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412023132.GA7035@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 10:31:32PM -0400, Dave Jones wrote:
 > These warnings are trivially triggerable by any user, and serve no useful purpose afaics
 > Just -EINVAL and be done.
 > 
 > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
 > index ed7b5d1..a745317 100644
 > --- a/kernel/trace/trace.c
 > +++ b/kernel/trace/trace.c
 > @@ -4136,13 +4136,11 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
 >  		return -ENOMEM;
 >  
 >  	if (*ppos & (PAGE_SIZE - 1)) {
 > -		WARN_ONCE(1, "Ftrace: previous read must page-align\n");
 >  		ret = -EINVAL;
 >  		goto out;
 >  	}
 >  
 >  	if (len & (PAGE_SIZE - 1)) {
 > -		WARN_ONCE(1, "Ftrace: splice_read should page-align\n");
 >  		if (len < PAGE_SIZE) {
 >  			ret = -EINVAL;
 >  			goto out;
 > --

Anyone want to pick this up, or shall I just send it to Linus myself ?

	Dave
