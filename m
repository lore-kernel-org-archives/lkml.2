Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab1CaPMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:12:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab1CaPMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:12:15 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=XYJHFtupD_QA:10 a=4ay608aMGH4A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2l9YU309s393vAnYnUkA:9 a=d9yLHfgF22P9hf3o8P8A:7 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 31 Mar 2011 11:12:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: limp <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Minimum time slice for relaible Linux execution
Message-ID: <20110331151214.GB14441@home.goodmis.org>
References: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 01:13:55PM +0100, limp wrote:
> Dear all,
> 
> I have developed a framework similar to a hypervisor that switches between
> Linux and a RT domain.
> As RT priority is of highest importance, I want to give more time to the RT
> domain *but* I also want to give Linux adequate time for being able to
> operate.
> 
> Could anyone advise me on how to determine the minimum possible time slice
> that I can give to Linux so that it doesn't crash?
> 
> That is, if I periodically execute my RT domain every ms and then I switch
> to Linux, what's the minimum time that should be given to Linux, until the
> next RT domain execution? 
> 

I'm not sure there is any requirement. The only problem I guess that can
happen is if you give such little time that the timer interrupt can't
finish, or that every time you schedule Linux back in, the timer
interrupt goes off and nothing else gets done.

Probably want to take a look at how virtualization works, as it has the
same issue. Linux guests get scheduled in periodically, and there's no
guarantee that they will run for a long time either, as real-time tasks
on the host may starve them.

Outside the live lock that I explained above, I doubt anything will
actually cause Linux to crash due to this.

-- Steve

