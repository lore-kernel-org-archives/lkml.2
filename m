Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0JKT5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:57:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573Ab0JKT5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:57:49 -0400
Date: Mon, 11 Oct 2010 12:57:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holzheu@linux.vnet.ibm.com
Cc: Luck Tony <tony.luck@intel.com>, benh@kernel.crashing.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] taskstats: Use real microsecond granularity for CPU
 times
Message-Id: <20101011125715.62001452.akpm@linux-foundation.org>
In-Reply-To: <1286782004.1942.24.camel@holzheu-laptop>
References: <1286782004.1942.24.camel@holzheu-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010 09:26:44 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> The taskstats interface uses microsecond granularity for the user and
> system time values. The conversion from cputime to the taskstats values
> uses the cputime_to_msecs primitive which effectively limits the 
> granularity to milliseconds. Add the cputime_to_usecs primitive for
> architectures that have better, more precise CPU time values. Remove
> cputime_to_msecs primitive because there is no more user left.

Fair enough.

msecs_to_cputime() never had any callers, and it replacement
usecs_to_cputime() doesn't have any callers either.  Maybe we should
just zap it.


