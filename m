Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0GJNYo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 09:24:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab0GJNYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 09:24:42 -0400
Date: Sat, 10 Jul 2010 09:24:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Nauman Rafique <nauman@google.com>
Cc: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, linux-kernel@vger.kernel.org,
       Ryo Tsuruta <ryov@valinux.co.jp>, taka@valinux.co.jp,
       kamezawa.hiroyu@jp.fujitsu.com, Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 00/11] blkiocg async support
Message-ID: <20100710132417.GA2752@redhat.com>
References: <4C369009.80503@ds.jp.nec.com>
 <20100709134546.GC3672@redhat.com>
 <4C37BC1A.20102@ds.jp.nec.com>
 <AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikECHfrksrk3QnD3X07pmgXdpo5-fv7hDLm2Zxw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 05:55:23PM -0700, Nauman Rafique wrote:

[..]
> > Well, right.  I agree.
> > But I think we can work parallel.  I will try to struggle on both.
> 
> IMHO, we have a classic chicken and egg problem here. We should try to
> merge pieces as they become available. If we get to agree on patches
> that do async IO tracking for IO controller, we should go ahead with
> them instead of trying to wait for per cgroup dirty ratios.
> 
> In terms of getting numbers, we have been using patches that add per
> cpuset dirty ratios on top of NUMA_EMU, and we get good
> differentiation between buffered writes as well as buffered writes vs.
> reads.
> 
> It is really obvious that as long as flusher threads ,etc are not
> cgroup aware, differentiation for buffered writes would not be perfect
> in all cases, but this is a step in the right direction and we should
> go for it.

Working parallel on two separate pieces is fine. But pushing second piece
in first does not make much sense to me because second piece does not work
if first piece is not in. There is no way to test it. What's the point of
pushing a code in kernel which only compiles but does not achieve intented
purposes because some other pieces are missing.

Per cgroup dirty ratio is a little hard problem and few attempts have
already been made at it. IMHO, we need to first work on that piece and
get it inside the kernel and then work on IO tracking patches. Lets
fix the hard problem first that is necessary to make second set of patches
work.

Thanks
Vivek
