Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab1HIHlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 03:41:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:2511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1HIHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 03:41:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,342,1309762800"; 
   d="scan'208";a="36675986"
Date: Tue, 9 Aug 2011 10:41:41 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Seemanta Dutta <seemanta@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kdump: Trouble reading /dev/oldmem from capture kernel
Message-ID: <20110809074141.GF16790@intel.com>
References: <3f4665f1a191945db7c1711ecd154509.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f4665f1a191945db7c1711ecd154509.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 02:01:03PM -0700, Seemanta Dutta wrote:
> 
> 2. Dump capture kernel provides two interfaces to access 'old' kernel
> memory (as per kdump dpcumentation): /dev/oldmem and /proc/vmcore. The
> latter works perfectly. But I am more interested in the raw memory, rather
> than the core file.

Is there some specific reason to use /dev/oldmem instead? At least I've
never needed that interface. crash utility works pretty well with
/dev/vmcore.

> My expectation in this scenario was that I would be able to access entire
> physical RAM using the /dev/oldmem device. But turns out, I can't.
> 
> I would be grateful if anyone pointed out if I was doing something wrong
> or missing something.
> 
> This is happening over ARM. Could that have to do something with this ?
> Not sure if the ARM integration of KDUMP/KEXEC has something to do with
> it.

I haven't tried lately but it looks like ARM is missing setting of
'saved_max_pfn' which could explain why it works that way.
