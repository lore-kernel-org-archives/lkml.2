Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0HTAI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:08:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53256 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0HTAIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:08:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Howells <dhowells@redhat.com>
Subject: Re: oom: __task_cred() need rcu_read_lock()
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <7682.1282230394@redhat.com>
References: <20100819220338.5FD5.A69D9226@jp.fujitsu.com> <7682.1282230394@redhat.com>
Message-Id: <20100820084820.5FDB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 20 Aug 2010 09:08:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > dump_tasks() can call __task_cred() safely because we are holding
> > tasklist_lock. but rcu lock validator don't have enough knowledge and
> > it makes following annoying warning.
> 
> No, it can't.  The tasklist_lock is not protection against the creds changing
> on another CPU.

Thank you for correction.

I suppose you mean I missed CONFIG_TREE_PREEMPT_RCU, right?
As far as my grepping, other rcu implementation and spinlock use 
preempt_disable(). In other word, Can I assume usual distro user 
don't hit this issue?

Thanks.



