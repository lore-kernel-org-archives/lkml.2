Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab1JMLAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:00:35 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:32881 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1JMLAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:00:34 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
Date: Thu, 13 Oct 2011 22:00:28 +1100
From: "Bojan Smojver" <bojan@rexursive.com>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
X-Mailer: LCG ProfiMail 3.48
Message-ID: <2409186928.1003010428@rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com> <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl> <201110062045.48689.rjw@sisk.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- Original message -------
> From: Rafael J. Wysocki

>> I get a kernel panic on a test box using a x86_64 kernel with this patch
>> applied.
>
> The panic happens during late resume, when trying to switch to the 
> hibernated
> kernel.

In an effort to test this whole thing a bit more, I took today's kernel 
from Linus' repo and applied v11 of my patch. I compiled this on a single 
cpu machine this time, with 768 MB of memory (in today's terms, this laptop 
would not pass as a smartphone :-), running F-16 beta.. The system has 
radeon graphics (my other system, where I initially developed the patch, 
has intel). Also, this was a 32-bit box, as opposed to my other system, 
which is 64-bit.

I was getting kernel trouble on repeated hibernate/thaw cycles on both 
systems when KMS was enabled. With nomodeset passed into the kernel, both 
systems would go through 50+ cycles (this was my test loop) with no 
trouble. Whether my patch was applied or not didn't matter - I was getting 
trouble with Fedora supplied kernels as well, after a few cycles.

So, I don't know for sure, but it seems to me something is amiss in KMS 
when it comes to hibernation.

--
Bojan 
