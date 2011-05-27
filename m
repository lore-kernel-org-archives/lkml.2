Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab1E0Wvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 18:51:47 -0400
Received: from outmail013.snc4.facebook.com ([66.220.144.145]:61789 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757313Ab1E0Wvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 18:51:45 -0400
Date: Fri, 27 May 2011 15:51:45 -0700
From: Arun Sharma <asharma@fb.com>
To: David Ahern <dsahern@gmail.com>
Cc: "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf, H/W counters - ESX hosted VM
Message-ID: <20110527225145.GB847@dev1756.snc6.facebook.com>
References: <4DDFFCA2.8030100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DDFFCA2.8030100@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:33:54PM -0600, David Ahern wrote:
> 
> Has anyone successfully used perf within an ESX VM? dmesg shows a PMU is
> discovered:

Don't know about ESX. But in general, getting this right requires 
virtualizing PMU hardware (eg: save/restore PMU state on exit/entry
from the guest just the way the scheduler does for processes).

Also, the MSR read/writes to event-{select,count} registers must
be properly virtualized. Interrupt delivery (NMIs) is important
as well.

I suspect that MSR writes from the guest to the PMU related registers
are simply ignored in most virtual environments today.

 -Arun
