Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722Ab0KANNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:13:48 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:47351 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756124Ab0KANNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:13:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAKJTzkxGGOIS/2dsb2JhbAChVnK7UYVFBI9d
Date: Mon, 1 Nov 2010 09:08:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using
	vzalloc rather than vmalloc and memset
Message-ID: <20101101130842.GA24605@Krystal>
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal> <4CCEB723.2010005@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4CCEB723.2010005@kernel.dk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:07:26 up 207 days, 22:57,  3 users,  load average: 0.12, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (axboe@kernel.dk) wrote:
> On 2010-10-30 17:47, Mathieu Desnoyers wrote:
> > BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
> > transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
> > relay dependency to the Generic Ring Buffer Library might be a good
> > option to consider.
> 
> The blktrace user bits is still (by far) the most wide spread way that
> blktrace is used in the field, and those still rely on relayfs. So no,
> we can't kill it now.

What I am proposing is that the Generic Ring Buffer Library could
replace relayfs without changing any of the interfaces blktrace exposes
to user-space. Indeed, I would not remove relayfs unless there was a
replacement.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
