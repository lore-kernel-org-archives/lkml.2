Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1ESIpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:45:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45161 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756785Ab1ESIph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:45:37 -0400
Subject: Re: [PATCH 1/2] cpuset: fix cpuset_cpus_allowed_fallback() don't
 update tsk->rt.nr_cpus_allowed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
In-Reply-To: <20110516133748.GB2058@zhy>
References: <20110428161149.GA15658@redhat.com>
	 <20110502194416.2D61.A69D9226@jp.fujitsu.com>
	 <20110502195657.2D68.A69D9226@jp.fujitsu.com>
	 <1305129929.2914.247.camel@laptop> <4DCCC61F.80408@jp.fujitsu.com>
	 <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>
	 <1305306135.2466.173.camel@twins>  <20110516133748.GB2058@zhy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 10:45:08 +0200
Message-ID: <1305794708.2466.7194.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 21:37 +0800, Yong Zhang wrote:
> 
> But I'm afraid this patch still doesn't help. 
> If I understand your patch correctly, you just put the wake up to CPU_STARTING,
> but it's still before CPU_ONLINE.\

Well, that's the whole point really, CPU_ONLINE is terribly late. But
did you perhaps mean to say its before we mark the cpu online?

> Please check my mail to Paul's in this thread group.

Not sure that made things any clearer.
