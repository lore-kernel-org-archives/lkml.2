Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1GHHfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:35:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41316 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab1GHHfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:35:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=PrCjv1Kk+Io95ljNT3qohSdwmX4ymGu0cs7xKPKsPD5ofvNAvoSqL2dSzdl4Y4AlC
	7d3q0GDT95wqbfojhho9A==
MIME-Version: 1.0
In-Reply-To: <1310047614.3282.572.camel@twins>
References: <20110707053036.173186930@google.com> <1310047614.3282.572.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Fri, 8 Jul 2011 00:35:18 -0700
Message-ID: <CAPM31RLfac8x0b+R8vNjMHH36DWmGKe4b-Cx5WP4GZ=nqqBUOg@mail.gmail.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 7:06 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> The very first .config I build gets me:
>
>  CC      kernel/sched.o
> /usr/src/linux-2.6/kernel/sched.c:503: warning: ‘struct cfs_bandwidth’ declared inside parameter list
> /usr/src/linux-2.6/kernel/sched.c:503: warning: its scope is only this definition or declaration, which is probably not what you want
> /usr/src/linux-2.6/kernel/sched.c:504: warning: ‘struct cfs_bandwidth’ declared inside parameter list
> In file included from /usr/src/linux-2.6/kernel/sched.c:2175:
> /usr/src/linux-2.6/kernel/sched_fair.c: In function ‘move_one_task’:
> /usr/src/linux-2.6/kernel/sched_fair.c:2770: error: ‘struct cfs_rq’ has no member named ‘tg’
>

Fixed -- I missed !CGROUP in my testing.

I'll roll these nits with the !SMP support and some performance
shavings from this thread.
>
>
>
