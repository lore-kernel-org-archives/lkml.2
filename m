Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab0DFJjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 05:39:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:44241 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0DFJi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 05:38:58 -0400
Message-ID: <4BBB0118.307@kernel.org>
Date: Tue, 06 Apr 2010 18:38:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [GIT PULL] break implicit percpu.h -> slab.h dependency
References: <4BB95DEE.3050607@kernel.org> <20100406092523.GA30270@elte.hu>
In-Reply-To: <20100406092523.GA30270@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 09:38:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 04/06/2010 06:25 PM, Ingo Molnar wrote:
> FYI, -tip testing found a build breakage with your changes:
> 
>  drivers/base/node.c:373: error: implicit declaration of function 'kmalloc'
>  drivers/base/node.c:377: error: implicit declaration of function 'kfree'

These are NODEMASK_ALLOC() and NODEMASK_FREE() macros which become
kmalloc/kfree() iff NODES_SHIFT > 8.  I'll grep for these macros and
commit a proper fix.

> The fix is below. Since my first test today triggered a build failure i'd 
> expect there to be more - i'll send all subsequent fixes to this thread.

Thanks.  Much appreciated.

-- 
tejun
