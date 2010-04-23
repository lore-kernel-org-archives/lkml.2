Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab0DWU5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:57:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:34659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab0DWU5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:57:16 -0400
Subject: Re: [PATCH -mmotm 1/5] memcg: disable irq at page cgroup lock
From: Peter Zijlstra <peterz@infradead.org>
To: Greg Thelen <gthelen@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Vivek Goyal <vgoyal@redhat.com>, balbir@linux.vnet.ibm.com,
       Andrea Righi <arighi@develer.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Suleiman Souhlal <suleiman@google.com>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <xr93k4rxx6sd.fsf@ninji.mtv.corp.google.com>
References: <1268609202-15581-2-git-send-email-arighi@develer.com>
	 <20100318133527.420b2f25.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100318162855.GG18054@balbir.in.ibm.com>
	 <20100319102332.f1d81c8d.kamezawa.hiroyu@jp.fujitsu.com>
	 <20100319024039.GH18054@balbir.in.ibm.com>
	 <20100319120049.3dbf8440.kamezawa.hiroyu@jp.fujitsu.com>
	 <xr931veiplpr.fsf@ninji.mtv.corp.google.com>
	 <20100414140523.GC13535@redhat.com>
	 <xr9339yxyepc.fsf@ninji.mtv.corp.google.com>
	 <20100415114022.ef01b704.nishimura@mxp.nes.nec.co.jp>
	 <g2u49b004811004142148i3db9fefaje1f20760426e0c7e@mail.gmail.com>
	 <20100415152104.62593f37.nishimura@mxp.nes.nec.co.jp>
	 <20100415155432.cf1861d9.kamezawa.hiroyu@jp.fujitsu.com>
	 <xr93k4rxx6sd.fsf@ninji.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 22:57:06 +0200
Message-ID: <1272056226.1821.41.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 13:17 -0700, Greg Thelen wrote:
> +static void mem_cgroup_begin_page_cgroup_reassignment(void)
> +{
> +       VM_BUG_ON(mem_cgroup_account_move_ongoing);
> +       mem_cgroup_account_move_ongoing = true;
> +       synchronize_rcu();
> +} 

btw, you know synchronize_rcu() is _really_ slow?

