Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab2IJPiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 11:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab2IJPh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 11:37:58 -0400
Date: Mon, 10 Sep 2012 12:37:47 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, ibs: Check syscall attribute flags
Message-ID: <20120910153746.GA20931@infradead.org>
References: <1342826756-64663-9-git-send-email-dsahern@gmail.com>
 <20120906190238.GA29278@erda.amd.com>
 <5048F6BF.70106@gmail.com>
 <20120906195645.GD8285@erda.amd.com>
 <20120907164114.GJ8285@erda.amd.com>
 <504A25DB.2030100@gmail.com>
 <20120907170700.GK8285@erda.amd.com>
 <504A2ADC.4050703@gmail.com>
 <504A2CD3.9060204@gmail.com>
 <20120910130700.GS8285@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910130700.GS8285@erda.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 10, 2012 at 03:07:00PM +0200, Robert Richter escreveu:
> On 07.09.12 11:20:19, David Ahern wrote:
> > I see now... intel returns ENOTSUP if exclude_guest is not set, amd 
> > returns EINVAL if it is set.

> > For the AMD case the fallback_missing_features code kicks in for 
> > perf-top and perf-record; I just need to fix up the pr_debug for that case.

> It is EOPNOTSUP. I preferred returning EOPNOTSUP too. But then I saw
> that fallback code is implemented to work mostly with EINVAL. It seems
> to be the default answer to a syscall. ;)

> There are several pieces of code in perf that implement fallback code,
> it's hard to find it all and this already caused some bugs in the
> past. I was looking at this to unify it, but it was too much effort.

Indeed these all need to be moved to perf_ev{sel,list}__open, its
something I meant to do long ago, will try again to consolidate that.

- Arnaldo
