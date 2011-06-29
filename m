Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab1F2M2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:28:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab1F2M2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:28:03 -0400
Message-ID: <4E0B1A4E.2030301@redhat.com>
Date: Wed, 29 Jun 2011 15:27:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 19/22] KVM: MMU: lockless walking shadow page table
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FDB4.60306@cn.fujitsu.com> <4E0AED86.2060908@redhat.com> <4E0B0997.4090206@cn.fujitsu.com> <4E0B09EA.1040304@redhat.com> <4E0B1191.6040100@cn.fujitsu.com> <4E0B182C.1090402@redhat.com> <4E0B1A75.4070705@cn.fujitsu.com>
In-Reply-To: <4E0B1A75.4070705@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 03:28 PM, Xiao Guangrong wrote:
> On 06/29/2011 08:18 PM, Avi Kivity wrote:
> >  On 06/29/2011 02:50 PM, Xiao Guangrong wrote:
> >>  >>   >
> >>  >>   >    I think we should do this unconditionally.  The cost of ping-ponging the shared cache line containing reader_counter will increase with large smp counts.  On the other hand, zap_page is very rare, so it can be a little slower.  Also, less code paths = easier to understand.
> >>  >>   >
> >>  >>
> >>  >>   On soft mmu, zap_page is very frequently, it can cause performance regression in my test.
> >>  >
> >>  >   Any idea what the cause of the regression is?  It seems to me that simply deferring freeing shouldn't have a large impact.
> >>  >
> >>
> >>  I guess it is because the page is freed too frequently, i have done the test, it shows
> >>  about 3219 pages is freed per second
> >>
> >>  Kernbench performance comparing:
> >>
> >>  the origin way: 3m27.723
> >>  free all shadow page in rcu context: 3m30.519
> >
> >  I don't recall seeing such a high free rate.  Who is doing all this zapping?
> >
> >  You may be able to find out with the function tracer + call graph.
> >
>
> I looked into it before, it is caused by "write flood" detected, i also noticed
> some pages are zapped and allocation again and again, maybe we need to improve
> the algorithm of detecting "write flood".

Ok.  Let's drop the two paths, and put this improvement on the TODO instead.

-- 
error compiling committee.c: too many arguments to function

