Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0CWNHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:07:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab0CWNHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:07:45 -0400
Message-ID: <4BA8BD1B.7050100@redhat.com>
Date: Tue, 23 Mar 2010 15:07:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>
Subject: Re: KSM & hugepages
References: <4BA8A6DA.1000408@msgid.tls.msk.ru>
In-Reply-To: <4BA8A6DA.1000408@msgid.tls.msk.ru>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2010 01:32 PM, Michael Tokarev wrote:
> Hello.
>
> I noticed an interesting thing here, with qemu-kvm, KSM and
> hugepages.
>
> When I initially enabled KSM, for my two windows guests I've
> seen ~100 000 pages in /sys/kernel/mm/ksm/pages_shared .
> That's quite good, and overall memory usage improved.
>
> Now, I also enabled hugepages in kvm, which speed things
> up quite significantly (the speedup is noticeable).
>
> But now, when both KSM and hugepages are activated, I don't
> see KSM in action anymore.  /sys/../mm/pages_shared shows
> 56 pages, which is nothing.
>
> So I wonder what's up:
>   o that's 56 _huge_ pages (which means the actual saving
>     is 56*2M = 112Mb, which isn't really bad).  If that's
>     the case, /sys/../mm/ interface lacks proper units
>     reporting;
>   o due to large pages there's much less chance to find
>     two pages with identical contents, so very little can
>     be shared;
>   o KSM does not scan hugepages at all
>   o something else.
>
> What is the issue here?
>
>    

Those pages aren't scanned since ksm only scans anonymous memory; 
hugetlbfs is file backed memory.   Even if it were anonymous memory, ksm 
doesn't support merging large pages (and the probability of finding a 
match is practically nil).  No idea where the 56 comes from - perhaps a 
leak from the previous runs?

-- 
error compiling committee.c: too many arguments to function

