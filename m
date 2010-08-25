Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab0HYQaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 12:30:21 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:19410
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752204Ab0HYQaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 12:30:19 -0400
X-SpamScore: -26
X-BigFish: VPS-26(zzbb2dKbb2cK1432N98dN9371Pzz1202hzzz2fh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
Message-ID: <4C7544FA.5030304@am.sony.com>
Date: Wed, 25 Aug 2010 09:29:46 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Possible kmemleak issue, but I'm confused
References: <4C744DC5.3040106@am.sony.com> <1282727985.3650.19.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1282727985.3650.19.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 02:19 AM, Catalin Marinas wrote:
>> What is the status of this patch relative to linux-next or Linus'
>> tree?
> 
> This patch was merged in 2.6.31-rc1 but parts of it were later dropped
> in 2.6.34-rc1 (commit 23fb064b) when Tejun removed the legacy percpu
> allocator. The new percpu allocator in mm/percpu.c uses standard
> allocation methods like alloc_bootmem or kzalloc and kmemleak handles
> these already, so no need for extra code in kernel/module.c.

OK.  This is just the information I needed.  Thanks.

>> Our solution was just to make these specific calls to kmemleak_alloc
>> and kmemleak_free (in module.c) compile-time configurable.
>> I suspect that there is a better way to do this -- possibly by
>> detecting or noting that this situation exists for certain
>> platforms, and avoiding it without specific user interaction.
> 
> For the 2.6.29 kernel (not mainline), you could have it compile-time
> configurable. Another option would be to hack create_object() in
> mm/kmemleak.c to not call kmemleak_stop("Cannot insert ..."), though
> this method could potentially hide other problems with kmemleak
> callbacks.

We'll stick with our compile-time option, then, and it sounds
like when we upgrade our kernel version we won't need to worry
about this issue.

Thanks very much!  kmemleak is cool. :-)
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Network Entertainment
=============================

