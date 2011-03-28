Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1C1Cxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:53:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57831 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab1C1Cxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:53:48 -0400
Message-ID: <4D8FF8AD.5080607@cn.fujitsu.com>
Date: Mon, 28 Mar 2011 10:55:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC PATCH 0/5] Add kernel-offset file and make rcu_read_[un]lock()
 included
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:52:09,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:52:11,
	Serialize complete at 2011-03-28 10:52:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



__rcu_read_[un]lock() are so simple functions and called so
frequent, it is not good that a function call overhead is
required when use them. It would be better if we declare
them inline and let the compiler do the choice.

We add kernel-offset.c for TASK_RCU_OFFSET, which enable we declare
rcu_read_[un]lock() as inline function.

Adding kernel-offset.c does not have any effect for the result
compiled kernel, it just adds a small and fast step in the kbuid stage.

Lai Jiangshan (5):
  task_rcu_struct
  kbuild_dedumplicated
  add_kernel_offset
  access task's task_rcu_struct without include sched.h
  rcu inline

 Kbuild                    |   99 ++++++++++++++++---------------
 include/linux/init_task.h |   25 +--------
 include/linux/rcupdate.h  |  144 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/sched.h     |   39 +------------
 kernel/kernel-offsets.c   |   17 +++++
 kernel/rcutiny_plugin.h   |   58 ++++--------------
 kernel/rcutree_plugin.h   |   69 ++++++----------------
 7 files changed, 243 insertions(+), 208 deletions(-)
 create mode 100644 kernel/kernel-offsets.c

-- 
1.7.4
