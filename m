Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab0EKUDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:03:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946Ab0EKUDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:03:23 -0400
Message-ID: <4BE9B8DD.9080004@redhat.com>
Date: Tue, 11 May 2010 16:06:53 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip 1/5] [CLEANUP] kprobes: Remove redundant	text_mutex
 lock in optimize
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6> <20100510175320.27396.49896.stgit@localhost6.localdomain6> <20100511123550.GB25418@Krystal>
In-Reply-To: <20100511123550.GB25418@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Remove text_mutex locking in optimize_all_kprobes, because
>> that function doesn't modify text but just order optimization
>> to worker.
> 
> Hi Masami,
> 
> A few comments:
> 
> 1) optimize_all_kprobes/unoptimize_all_kprobes should have comments saying that
> they are always called with kprobe_mutex held.
> 
> 2) The sentence above in the changelog could be changed into:
> 
>  ..."because this function doesn't modify text. It simply queues optimizations
> for the kprobe_optimizer worker thread."
> 
> 3)
> 
> static DEFINE_MUTEX(kprobe_mutex);      /* Protects kprobe_table */
> 
> .. should also state that it protects optimizing_list.
> 

Thanks! all comments are good to me!

Thank you again,




-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com

