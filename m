Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab2BANgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:36:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:38872 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab2BANgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:36:38 -0500
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <4F289486.2050107@linux.vnet.ibm.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
	 <1327674868-10486-6-git-send-email-jolsa@redhat.com>
	 <4F231256.8080905@linux.vnet.ibm.com>
	 <20120130095223.GB1552@m.brq.redhat.com>
	 <4F289486.2050107@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 14:36:24 +0100
Message-ID: <1328103384.2760.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-31 at 17:25 -0800, Corey Ashford wrote:
> 
> One other comment that occurs to me is that it would be nice for perf to
> know when a supplied value is out of range, or will have undefined
> results.  For example, a field may be 8 bits wide, but not all 8-bit
> values are legal.  For example, there may be 208 events, and the codes
> may be somehwhat or even very sparsely encoded.  So, ideally, a config
> field in sysfs might look like this:
> 
> config1:0-7:0x0-0xd8,0xdb-0xe2,0xe4-0xe6
> 
> This way perf could check for valid values before stuffing them into
> registers, and give a good error message to the user.  If there is no
> restriction field, it would be assumed all of the possible values are valid.
> 
> I think the kernel code needs to check for bad values as well, because
> people can bypass the restrictions exposed by sysfs and use the
> perf_events API directly. 

Define bad? The only case where perf cares (from a kernel pov) is when
it can make the hardware melt and similar things. Programming the PMU in
a non-nonsensical but non-destructive way is fine, you get what you ask
for.



