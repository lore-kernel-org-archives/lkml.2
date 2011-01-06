Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab1AFVIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 16:08:50 -0500
Received: from mail.openrapids.net ([64.15.138.104]:55011 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752831Ab1AFVIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 16:08:48 -0500
Date: Thu, 6 Jan 2011 16:08:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
	this_cpu_cmpxchg_double
Message-ID: <20110106210846.GA3528@Krystal>
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106204525.222395863@linux.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:54:34 up 44 days,  1:57,  5 users,  load average: 0.09, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
[...]
> + * cmpxchg_double replaces two adjacent scalars at once. The first two
> + * parameters are per cpu variables which have to be of the same size.
> + * A truth value is returned to indicate success or
> + * failure (since a double register result is difficult to handle).
> + * There is very limited hardware support for these operations. So only certain
> + * sizes may work.

What's the issue with returning the value read by cmpxchg_double in addition to
the boolean ? "returning" it per se might be an issue, but you could add 2 more
parameters to the macros that take the addresses of these outputs. Returning the
values read by cmpxchg instead of just the boolean result helps removing the
extra reads from cmpxchg loops, which is why I think it's a shame to just return
the boolean result.

Thoughts ?

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
