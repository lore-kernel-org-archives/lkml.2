Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2KBTpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 15:45:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45963 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab2KBTpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 15:45:12 -0400
Message-ID: <509422C3.1000803@suse.cz>
Date: Fri, 02 Nov 2012 20:45:07 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Zdenek Kabelac <zkabelac@redhat.com>, Valdis.Kletnieks@vt.edu,
        Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kswapd0: excessive CPU usage
References: <507688CC.9000104@suse.cz> <106695.1349963080@turing-police.cc.vt.edu> <5076E700.2030909@suse.cz> <118079.1349978211@turing-police.cc.vt.edu> <50770905.5070904@suse.cz> <119175.1349979570@turing-police.cc.vt.edu> <5077434D.7080008@suse.cz> <50780F26.7070007@suse.cz> <20121012135726.GY29125@suse.de> <507BDD45.1070705@suse.cz> <20121015110937.GE29125@suse.de> <5093A3F4.8090108@redhat.com> <5093A631.5020209@suse.cz>
In-Reply-To: <5093A631.5020209@suse.cz>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2012 11:53 AM, Jiri Slaby wrote:
> On 11/02/2012 11:44 AM, Zdenek Kabelac wrote:
>>>> Yes, applying this instead of the revert fixes the issue as well.
>>
>> I've applied this patch on 3.7.0-rc3 kernel - and I still see excessive
>> CPU usage - mainly  after  suspend/resume
>>
>> Here is just simple  kswapd backtrace from running kernel:
> 
> Yup, this is what we were seeing with the former patch only too. Try to
> apply the other one too:
> https://patchwork.kernel.org/patch/1673231/
> 
> For me I would say, it is fixed by the two patches now. I won't be able
> to report later, since I'm leaving to a conference tomorrow.

Damn it. It recurred right now, with both patches applied. After I
started a java program which consumed some more memory. Though there are
still 2 gigs free, kswap is spinning:
[<ffffffff810b00da>] __cond_resched+0x2a/0x40
[<ffffffff811318a0>] shrink_slab+0x1c0/0x2d0
[<ffffffff8113478d>] kswapd+0x66d/0xb60
[<ffffffff810a25d0>] kthread+0xc0/0xd0
[<ffffffff816aa29c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

-- 
js
suse labs
