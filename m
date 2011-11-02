Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294Ab1KBQAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932383Ab1KBQAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:00:17 -0400
Date: Wed, 2 Nov 2011 16:55:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <htejun@gmail.com>
Cc: trisha yad <trisha1march@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Issue with core dump
Message-ID: <20111102155505.GA30500@redhat.com>
References: <CAGr+u+zkPiZpGefstcbJv_cj929icWKXbqFy1uR22Hns1hzFeQ@mail.gmail.com> <20111101152320.GA30466@redhat.com> <CAGr+u+wgAYVWgdcG6o+6F0mDzuyNzoOxvsFwq0dMsR3JNnZ-cA@mail.gmail.com> <20111102153146.GC12543@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102153146.GC12543@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02, Tejun Heo wrote:
>
> Also, the time between do_user_fault() and actual core dumping isn't
> the important factor here.  do_user_fault() directly triggers delivery
> of SIGSEGV (or BUS) and signal delivery will immediately deliver
> SIGKILL to all other threads in the process,

Not really, note the "if (!sig_kernel_coredump(sig))" check. And this
is what we can improve. But this is not simple, and personally I think
doesn't worth the trouble.

Oleg.

