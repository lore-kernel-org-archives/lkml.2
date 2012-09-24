Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab2IXK7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 06:59:31 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:61319 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab2IXK73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 06:59:29 -0400
Message-ID: <50603D02.50302@synopsys.com>
Date: Mon, 24 Sep 2012 16:29:14 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Greg Ungerer <gregungerer@westnet.com.au>,
        Mark Salter <msalter@redhat.com>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>
Subject: Re: [RFC] status of execve() work - per-architecture patches solicited
References: <20120917032651.GU13973@ZenIV.linux.org.uk> <1348244799-16013-1-git-send-email-msalter@redhat.com> <20120921183934.GK13973@ZenIV.linux.org.uk> <505D9DFB.8080002@westnet.com.au> <20120923004636.GL13973@ZenIV.linux.org.uk>
In-Reply-To: <20120923004636.GL13973@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 September 2012 06:16 AM, Al Viro wrote:
> On Sat, Sep 22, 2012 at 09:16:11PM +1000, Greg Ungerer wrote:
>> I sent the patch to the m68k-linux list. Its been acked by Geert.
>>
>>  http://marc.info/?l=linux-m68k&m=134742688015639&w=2
>>
>> I was going to push it through the m68knommu git tree, but I don't mind
>> if you would rather take it with your changes.
> 
> Applied.  Other changes since the last update:
> 	* ppc breakage debugged and fixed
> 	* kernel_thread() unified on all converted architectures.

commit cc615abcde (mn10300: convert to generic kernel_thread) in the
experimental-kernel_thread has a minor syntactical error:

diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 26120a9..8ee09d8 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -225,7 +225,7 @@ int copy_thread(unsigned long clone_flags,
        p->thread.usp   = c_usp;

        if (unlikely(!kregs)) {
-               memset(c_regs, 0, sizeof(struct pt_regs);
+               memset(c_regs, 0, sizeof(struct pt_regs));


Thx,
-Vineet
