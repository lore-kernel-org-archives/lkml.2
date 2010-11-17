Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab0KQAXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:23:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:4092 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498Ab0KQAXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:23:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,208,1288594800"; 
   d="scan'208";a="678212730"
Subject: Re: [performance bug] volanomark regression on 37-rc1
From: "Alex,Shi" <alex.shi@intel.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: "ncrao@google.com" <ncrao@google.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
In-Reply-To: <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
References: <1289900042.27424.253.camel@debian>
	 <AANLkTi=OK+B537S5D8H4=yV5zC8+RksnfYgoKsqEyk5+@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 08:23:57 +0800
Message-ID: <1289953437.27424.271.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 22:38 +0800, Rakib Mullick wrote:
> On 11/16/10, Alex,Shi <alex.shi@intel.com> wrote:
> > When do performance testing on 37-rc1 kernel on Core2 machines, we find
> > the volanomark loopback performance drop about 30%, that due to
> > commit:fab476228ba37907ad7
> >
> Was that test was made before and after applying above commit? Would
> love to know, how did you find that commit (I mean was it a git
> bisection)?
Yes, git bisect found this commit. 

> >
> > It seems some of load_balance() is not necessary that caused by avg_idle
> > setting. But do not know more details of the volano running. Anyone like
> > to give a comments for this issue?
> >
> Does VolanoMark is used for scheduler benchmarking? If I'm not wrong,
> I don't think it directly relates to scheduler benchmarking.
Yes, but lots of benchmarks often find other part kernel issues. like
hackbench/netperf often find VM performance issues. And an our cache
testing tool often find scheduler problem. 
> 
> > Ncrao, I have no idea of your benchmarks, but just guess removing the
> > avg_idle setting won't bring much wakeup delay for tasks. Could you like
> > to show some data of this?
> >
> > The vmstat output for .36 and .37-rc1 kernel as below:
> 
> You are showing the output of .36 and .37-rc1. If Ncrao's commit is
> guilty for this performance regression, then what are the results of
> before and after applied Ncrao's commit. Then, what are the result
> after applying your patch. You are showing vmstat output of .36 and
> .37-rc1, which really doesn't prove the point of your patch. It needs
> to be more clearer.
The vmstat for .36 represents original kernel, .37-rc1 represent with
the Ncrao's patch.
> 
> 
> thanks,
> rakib
> 
> 
> > Regards
> > Alex
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >


