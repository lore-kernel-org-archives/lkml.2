Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab1BDEMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 23:12:21 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:38082 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1BDEMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 23:12:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=PLX0xYjATYpF6Ix9at1LlgwzhKj0uLxXYqxewbgpLmojt5ye4SafDmviKuaqy0ju2P
         gCS0sWJLPLbOavYAYAzcjQjFBVLYJ1SablApKOx6+4YRrwcjsJtsgXYOdXbx9En9wjY/
         9G/mzZihFsSE9l+6eoqsCWV+BnJcbGAocEWJc=
MIME-Version: 1.0
In-Reply-To: <20110203125611.GC2286@cmpxchg.org>
References: <1296482635-13421-1-git-send-email-hannes@cmpxchg.org>
	<1296482635-13421-3-git-send-email-hannes@cmpxchg.org>
	<20110131144131.6733aa3a.akpm@linux-foundation.org>
	<20110201000455.GB19534@cmpxchg.org>
	<20110131162448.e791f0ae.akpm@linux-foundation.org>
	<20110203125357.GA2286@cmpxchg.org>
	<20110203125611.GC2286@cmpxchg.org>
Date: Fri, 4 Feb 2011 09:42:19 +0530
X-Google-Sender-Auth: 56z-wdzBmAUKi16nxmqX7M0twUE
Message-ID: <AANLkTinNoCO7x4yTU_dxe-gB918i-2S6iz2Wrr5zzN2h@mail.gmail.com>
Subject: Re: [patch 2/2] memcg: simplify the way memory limits are checked
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyu@jp.fujitsu.com,
        nishimura@mxp.nes.nec.co.jp, minchan.kim@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 6:26 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> Since transparent huge pages, checking whether memory cgroups are
> below their limits is no longer enough, but the actual amount of
> chargeable space is important.
>
> To not have more than one limit-checking interface, replace
> memory_cgroup_check_under_limit() and memory_cgroup_check_margin()
> with a single memory_cgroup_margin() that returns the chargeable space
> and leaves the comparison to the callsite.
>
> Soft limits are now checked the other way round, by using the already
> existing function that returns the amount by which soft limits are
> exceeded: res_counter_soft_limit_excess().
>
> Also remove all the corresponding functions on the res_counter side
> that are now no longer used.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
