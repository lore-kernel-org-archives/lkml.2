Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab1DUVh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:37:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1DUVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:37:25 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XYJHFtupD_QA:10 a=l7sNeIXL_1gA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Rggy0SDKtDp1w5kOAkIA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 21 Apr 2011 17:37:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
Message-ID: <20110421213724.GD24898@home.goodmis.org>
References: <4D9F59AC.6080707@gmail.com>
 <4D9F790B.2000300@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9F790B.2000300@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 08, 2011 at 11:07:23PM +0200, Jan Kiszka wrote:
> On 2011-04-08 20:53, David Ahern wrote:
> > 2.6.38.2 kernel with trace-cmd git pulled this morning:
> > 
> > trace-cmd record -e kvm
> > 
> > trace-cmd report 2>&1 | less
> > 
> > trace-cmd: No such file or directory
> 
> Does this error come from trace-cmd failing to find its kvm plugin?
> Check what strace -e open says.
> 

I need to spend some time and fix it. That "No such file or directory"
is from the way trace-cmd does error handling. It checks if errno is set
and if so, it prints out perror(). What usually happens is I do a stat()
on a file which sets errno, and forget about it. Then if trace-cmd finds
some internal error, it calls the warning() message, which then prints
out the stale errno.

-- Steve


