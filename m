Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab0LNRaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:30:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:57358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab0LNRaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:30:01 -0500
Message-ID: <4D07A95C.7030703@kernel.org>
Date: Tue, 14 Dec 2010 18:29:00 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg V2 5/5] cpuops: Use cmpxchg for xchg to avoid
 lock semantics
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home> <4D07A7CB.7010205@zytor.com>
In-Reply-To: <4D07A7CB.7010205@zytor.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 14 Dec 2010 17:29:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/14/2010 06:22 PM, H. Peter Anvin wrote:
> On 12/14/2010 09:19 AM, Christoph Lameter wrote:
>>>
>>> Is it genuinely faster to do the pre-load mov, or can we drop that too?
>>>  My guess would be that yes it is, but if it happens not to be it would
>>> be nice to reduce the code size.
>>
>> Dropping the load increases the cycle count from 11 to 16.
> 
> Great, that answers that!  I'll pick up the patch hopefully today (I'm
> finally ramping back up on arch/x86 again after having been diverted to
> an internal project for a while...)

How do you want to route these?  All patches before this series is
already in the percpu tree.  I can pull the generic bits and leave out
the x86 bits so that x86 tree can pull in percpu bits and then put x86
stuff on top of it.  If you wanna go that way, I would drop all x86
related patches from the previous patchsets too.

Thanks.

-- 
tejun
