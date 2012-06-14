Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2FNUph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:45:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:13302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab2FNUpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:45:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165799701"
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        robert.richter@amd.com, andreas.herrmann3@amd.com
Date: Thu, 14 Jun 2012 13:45:34 -0700
In-Reply-To: <20120614143727.GF7922@escobedo.osrc.amd.com>
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
	 <20120614143727.GF7922@escobedo.osrc.amd.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339706734.3475.34.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 16:37 +0200, Hans Rosenfeld wrote:
> Thank you for working on this.
> 
> I didn't see anything obviously wrong in a quick review of this code,
> but this stuff is too complex for this to mean anything :)
> 
> I ran a quick test of your code. I found a signal frame corruption when
> running a 32bit test program on a 64bit kernel. I didn't try to find out
> why it failed, but I'll send you the test program in a private mail so
> you can look at it yourself.
> 

Ok. The problem was that I was using is_ia32_task() (which uses
TS_COMPAT) to check if the task is a compat task or not. And that flag
is not set during the signal delivery paths for the compat task.

I guess I should be using TIF_IA32 check instead. Using TIF_IA32 check
makes your test case run fine.

Will update it accordingly.

thanks,
suresh

