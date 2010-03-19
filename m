Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470Ab0CSWKI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:10:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:7800 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab0CSWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:10:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=R810BxDBzRQT8FLBl4h4YjbyuAD395st6yFq45lkjlt7nnc+WumxSFQ9uUmwPrcySp
         q0sGpyIo9xpY4jFppsEU07RW0uWA1KukjJbBb9QjU30IFUzCDUCjcDVUrjPvRCEzbsTj
         z6/OYaHpxUYSYKdUMpgCdVi424szEIj83HBH8=
Date: Sat, 20 Mar 2010 00:10:00 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [RFC patch 2/3] tree/tiny rcu: Add debug RCU head objects (v3)
Message-ID: <20100319221000.GA5276@x200>
References: <20100319204739.574593298@efficios.com>
 <20100319205233.474028085@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100319205233.474028085@efficios.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 04:47:41PM -0400, Mathieu Desnoyers wrote:
> Helps finding racy users of call_rcu(), which results in hangs because list
> entries are overwritten and/or skipped.
> 
> This new patch version is based on the debugobjects with the newly introduced
> "active state" tracker.
> 
> Non-initialized entries are all considered as "statically initialized". An
> activation fixup (triggered by call_rcu()) takes care of performing the debug
> object initialization without issuing any warning. Since we cannot increase the
> size of struct rcu_head, I don't see much room to put an identifier for
> statically initialized rcu_head structures. So for now, we have to live without
> "activation without explicit init" detection. But the main purpose of this debug
> option is to detect double-activations (double call_rcu() use of a rcu_head
> before the callback is executed), which is correctly addressed here.
> 
> This also detects potential internal RCU callback corruption, which would cause
> the callbacks to be executed twice.

Is this useful?

Basic usage is so there no double call_rcu():

	if (atomic_dec_and_test())
		call_rcu()
