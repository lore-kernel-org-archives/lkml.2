Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0LQPJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 10:09:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab0LQPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 10:09:52 -0500
Message-ID: <4D0B7D24.5060207@redhat.com>
Date: Fri, 17 Dec 2010 17:09:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net>  <4D0A6D34.6070806@redhat.com> <1292569018.7772.75.camel@marge.simson.net>
In-Reply-To: <1292569018.7772.75.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2010 08:56 AM, Mike Galbraith wrote:
> >  Surely that makes it a reasonable idea to call yield, and
> >  get one of the other tasks on the current CPU running for
> >  a bit?
>
> There's nothing wrong with trying to give up the cpu.  It's the concept
> of a cross cpu yield_to() that I find mighty strange.

What's so strange about it?  From a high level there are N runnable 
tasks contending for M cpus.  If task X really needs task Y to run, what 
does it matter if task Y last ran on the same cpu as task X or not?

Do I correctly read between the lines that CFS maintains complete 
fairness only on a cpu, but not globally?  I hope I'm wrong, but

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
  8648 avi       20   0  106m 1092  148 R 80.4  0.0   0:26.03 1 bash
  8656 avi       20   0  106m 1080  136 R 47.3  0.0   0:14.73 0 bash
  8652 avi       20   0  106m 1080  136 R 47.0  0.0   0:15.36 0 bash

doesn't look too good (three infinite loops in bash started at the 
roughly same time)

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

