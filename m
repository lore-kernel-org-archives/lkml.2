Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab1JRU2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 16:28:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1JRU2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 16:28:09 -0400
X-Authority-Analysis: v=1.1 cv=cRnbtTsVO6wWDdOYuq0VmyuiiLG/FStMSb4CWlTvuS0= c=1 sm=0 a=ZdnEEG40R08A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=r4GQeLiLMVhSe86UmaQA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [RFC PATCH] Tracepoint: add exec tracepoint
From: Steven Rostedt <rostedt@goodmis.org>
To: David Smith <dsmith@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4E9DD418.7030005@redhat.com>
References: <4E9DC85F.3080507@redhat.com>
	 <20111018185803.GA32498@infradead.org>  <4E9DD418.7030005@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 16:26:48 -0400
Message-ID: <1318969608.3712.7.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 14:31 -0500, David Smith wrote:
> On 10/18/2011 01:58 PM, Christoph Hellwig wrote:
> 
> > On Tue, Oct 18, 2011 at 01:41:35PM -0500, David Smith wrote:
> >> Added general purpose exec tracepoint.  The 'bprm' argument gives details of the exec.
> > 
> > Given that you only need the filename from the bprm please just pass
> > it directly.
> 
> 
> Thanks for looking at the patch.
> 
> I'm not totally opposed to this change, but passing bprm allows custom
> tracepoint handlers to look at other fields in bprm besides filename,
> which could be useful (depending on your needs).

I like flexible tracepoints too.

> 
> But, I don't have a real strong opinion here.
> 

I rather pass the pointer. If we pass the string, gcc may not optimize
when tracing is disabled and still do the work to dereference the
pointer unnecessarily.

-- Steve



