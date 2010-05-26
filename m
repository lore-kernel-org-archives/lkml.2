Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab0EZKIw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:08:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59813 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0EZKIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:08:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BUFeck67HO7sHpWJ8eIgwYQMuHl5Pa80ZEASQjnY75MYwqv+RoQXov+kKiQQvjJEuW
         uI8Z/VrBjgA7IvKn9IkF+hgFgKQP6YE0EMsxRlYyAFOYXQ5OsFa5ex9PfmLDNDI9tgz8
         tOBcM1zzc7ikAn7sHBUAMhOOs9Hly687k5Js4=
Date: Wed, 26 May 2010 12:08:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] convert perf to local64_t
Message-ID: <20100526100844.GB5311@nowhere>
References: <20100521134205.781916350@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521134205.781916350@chello.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 03:42:05PM +0200, Peter Zijlstra wrote:
> These patches introduce local64_t.
> 
> Since perf_event:count is only modified cross-cpu when child-counters
> feed back their changes on exit, and we can use a secondary variable
> for that, we can convert perf to use local64_t instead of atomic64_t
> and use instructions without buslock semantics.
> 
> The local64_t implementation uses local_t for 64 bits, since local_t is
> of type long, for 32 bit it falls back to atomic64_t. Architectures can
> provide their own implementation as usual.


It seems nobody disagrees with it. Can we give it a try?

Thanks.

