Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab0FPQxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 12:53:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:22625 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab0FPQxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 12:53:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Do9lmHIddm91n1E96GeDiR+CbE3Kn2QL5T8qfVbkFPF2ep9Kvf0wmFX3/2ujQ1f68U
         +iptgGFY3NBTKgUX39Jg2AG/X6DtXnHh8t1lpCz//VX5e/q+QaJX3pbvtithz2I//e8Y
         mXbtK6UNUnskjFCEXPJl5FL1AjltG62EkQS8M=
Date: Wed, 16 Jun 2010 20:52:44 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/8] perf: Reduce perf_disable() usage
Message-ID: <20100616165244.GB6751@lenovo>
References: <20100616160027.590430763@chello.nl> <20100616160238.431137125@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100616160238.431137125@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 06:00:32PM +0200, Peter Zijlstra wrote:
> Since the current perf_disable() usage is only an optimization, remove
> it for now. This eases the removal of the weak hw_perf_enable
> interface.
> 
> [ Some comments talk about NMI races, but I cannot find any such
>   things. ]
> 

The race was there and was fixed by commit 

| commit 34adc8062227f41b04ade0ff3fbd1dbe3002669e
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Wed May 20 20:13:28 2009 +0200

then you fixed it further in commit

| commit 3fb2b8ddcc6a7aa62af6bd2cb939edfd4c460506
| Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
| Date:   Mon Mar 8 13:51:01 2010 +0100

which I understand as we don't need perf_disable here for sure.
Just for the record :)

	-- Cyrill
