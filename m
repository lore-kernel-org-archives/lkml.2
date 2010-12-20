Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab0LTKjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab0LTKjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:39:53 -0500
Message-ID: <4D0F3266.90908@redhat.com>
Date: Mon, 20 Dec 2010 12:39:34 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com>	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>	 <1292615509.7381.81.camel@marge.simson.net>  <4D0CE937.8090601@redhat.com>	 <1292699204.1181.51.camel@marge.simson.net>  <4D0DA45A.9070600@redhat.com>	 <1292753156.16367.104.camel@marge.simson.net> <4D0DCE10.7000200@redhat.com>	 <1292834372.8948.27.camel@marge.simson.net> <4D0F1794.3010803@redhat.com>	 <1292835302.8948.35.camel@marge.simson.net> <4D0F1BD8.20601@redhat.com>	 <1292837440.8948.60.camel@marge.simson.net>  <4D0F25E8.80305@redhat.com> <1292841193.11946.36.camel@marge.simson.net>
In-Reply-To: <1292841193.11946.36.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 12:33 PM, Mike Galbraith wrote:
> >
> >  Correct.  I don't want the other task to run before me, I just don't
> >  want to run before it.
>
> OK, so what I gather is that if you can preempt another of your own
> threads to get the target to cpu, that would be a good thing whether
> he's on the same cpu as yield_to() caller or not.  If the target is
> sharing a cpu with you, that's even better.  Correct?

Correct.  I'm not interested in scheduling wrt other tasks, just my tasks.

However, if I'm all alone on my cpu, and the other task is runnable but 
not running, behind some unrelated task, then I do need that task to be 
preempted (or to move tasks around).

> Would a kick/hint option be useful?

Depends on what it does...

-- 
error compiling committee.c: too many arguments to function

