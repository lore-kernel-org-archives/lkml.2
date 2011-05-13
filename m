Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab1EMInO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 04:43:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37978 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab1EMInL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 04:43:11 -0400
Date: Fri, 13 May 2011 10:42:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] rcu commits for 2.6.40
Message-ID: <20110513084253.GE13647@elte.hu>
References: <20110511201852.GC2258@linux.vnet.ibm.com>
 <4DCAF894.7030707@kernel.org>
 <4DCAFFD8.2080605@kernel.org>
 <4DCB157F.20202@kernel.org>
 <20110512060344.GB3191@elte.hu>
 <4DCB8BCD.1080607@kernel.org>
 <4DCB8F7A.90603@kernel.org>
 <20110512092013.GJ2258@linux.vnet.ibm.com>
 <4DCC52FB.6030500@kernel.org>
 <4DCC894D.3070204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCC894D.3070204@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> more info:
> if only reverting: e59fb3120becfb36b22ddb8bd27d065d3cdca499
> 
> when compiled with gcc from opensuse 11.3
> [   32.579585] cpu_dev_init done
> [   81.203193] memory_dev_init done
> 
> but when compile that with gcc from fedora 14, then will less delay.
> [   32.404140] cpu_dev_init done
> [   37.602986] memory_dev_init done
> 
> gcc version on opensuse 11.3
> gcc (SUSE Linux) 4.5.0 20100604 [gcc-4_5-branch revision 160292]
> 
> gcc version on fedora 14:
> gcc (GCC) 4.5.1 20100924 (Red Hat 4.5.1-4)

Would it be possible to narrow down it a bit which commit causes the boot 
slowdown?

 known bad : 11c476f31a0f: net,rcu: convert call_rcu(prl_entry_destroy_rcu) to kfree
 known good: 0ee5623f9a6e: Linux 2.6.39-rc6

There's 76 commits inbetween so an about 6-step bisection ought to be able to 
narrow the source of regression down quite a bit ...

The complication with that bisection will be the need to revert the other 
broken commit you found:

 e59fb3120bec: rcu: Decrease memory-barrier usage based on semi-formal proof

Which is unfortunately very early in the series, so you'd have to revert this 
at almost every step of the bisection ...

Thanks,

	Ingo
