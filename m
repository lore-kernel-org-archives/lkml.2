Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab1FJAUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:20:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34042 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab1FJAUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:20:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 10 Jun 2011 09:13:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ying Han <yinghan@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: 3.0rc2 oops in mem_cgroup_from_task
Message-Id: <20110610091355.2ce38798.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <BANLkTikF7=qfXAmrNzyMSmWm7Neh6yMAB8EbBp7oLcfQmrbDjA@mail.gmail.com>
References: <20110609212956.GA2319@redhat.com>
	<BANLkTikCfWhoLNK__ringzy7KjKY5ZEtNb3QTuX1jJ53wNNysA@mail.gmail.com>
	<BANLkTikF7=qfXAmrNzyMSmWm7Neh6yMAB8EbBp7oLcfQmrbDjA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 16:42:09 -0700
Ying Han <yinghan@google.com> wrote:

> ++cc Hugh who might have seen similar crashes on his machine.
> 

Thank you for forwarding. Hmm. It seems the panic happens at khugepaged's 
page collapse_huge_page().

==
        count_vm_event(THP_COLLAPSE_ALLOC);
        if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
==
It passes target mm to memcg and memcg gets a cgroup by
==
 mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
==
Panic here means....mm->owner's task_subsys_state contains bad pointer ?

I'll dig. Thanks.
-Kame

