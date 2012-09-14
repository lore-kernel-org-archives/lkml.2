Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2INFnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 01:43:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38417 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2INFnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 01:43:50 -0400
Date: Fri, 14 Sep 2012 07:43:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org, Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 3/3 v2] perf tool: give user better message if precise is
 not supported
Message-ID: <20120914054344.GB9043@gmail.com>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
 <1347569955-54626-4-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347569955-54626-4-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Platforms (e.g., VM's) without support for precise mode get a confusing
> error message. e.g.,
> $ perf record -e cycles:p -a -- sleep 1
> 
>   Error: sys_perf_event_open() syscall returned with 95 (Operation not
>   supported).  /bin/dmesg may provide additional information.
> 
>   No hardware sampling interrupt available. No APIC? If so then you can
>   boot the kernel with the "lapic" boot parameter to force-enable it.
>   sleep: Terminated
> 
> which is not clear that precise mode might be the root problem. With this
> patch:
> 
> $ perf record -e cycles:p -fo /tmp/perf.data -- sleep 1
>   Error:
>   'precise' request may not be supported. Try removing 'p' modifier
>   sleep: Terminated
> 
> v2: softened message to 'may not be' supported per Robert's suggestion

Well, either it's supported on this machine or it's not - why 
does the text have to be so unsure about it?

We use computers to increase determinism, not to insert extra 
uncertainty! ;-)

Thanks,

	Ingo
