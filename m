Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0G1QBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:01:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34525 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab0G1QBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:01:06 -0400
Message-ID: <4C5053DA.2050909@zytor.com>
Date: Wed, 28 Jul 2010 08:59:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, glommer@redhat.com,
        alan@lxorguk.ukuu.org.uk, zamsden@redhat.com, stable@kernel.org,
        mtosatti@redhat.com, gregkh@suse.de, peter@palfrader.org,
        tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add memory modify constraints to xchg()
 and 	cmpxchg()
References: <4C4F7277.8050306@zytor.com> <tip-113fc5a6e8c2288619ff7e8187a6f556b7e0d372@git.kernel.org> <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
In-Reply-To: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 08:45 AM, Linus Torvalds wrote:
> On Tue, Jul 27, 2010 at 10:33 PM, tip-bot for H. Peter Anvin
> <hpa@zytor.com> wrote:
>>
>> x86: Add memory modify constraints to xchg() and cmpxchg()
> 
> Ack. I assume this doesn't really change the code generated? At least
> not with a gcc that honors the whole memory clobber thing properly?

I didn't do a binary A:B comparison, on the assumption it would preturb
the code too much to be equal, but I guess it would be a good idea to at
least try.

> I also suspect that we can/should get rid of the __xg() thing - it was
> there just to make sure gcc didn't see the memory read as a single
> word and tried to optimize it. With the "+m" it probably doesn't
> matter any more (don't know if it ever did)

"+m" would still see as a single word, but the __xg() thing should be
obsoleted by asm volatile + "memory", neither of which were in the
1.3.11 version.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

