Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab0EMEps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 00:45:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49325 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0EMEpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 00:45:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
In-Reply-To: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
Message-Id: <20100513134124.2164.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 13 May 2010 13:45:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> void *kvmalloc(size_t size)
> {
> 	void *ptr;
> 
> 	if (size < PAGE_SIZE)
> 		return kmalloc(PAGE_SIZE, GFP_KERNEL);
> 	ptr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);

low order GFP_KERNEL allocation never fail. then, this doesn't works
as you expected.

> 	if (ptr != NULL)
> 		return ptr;
> 
> 	return vmalloc(size);

On x86, vmalloc area is only 128MB address space. it is very rare 
resource than physical ram. vmalloc fallback is not good idea.


