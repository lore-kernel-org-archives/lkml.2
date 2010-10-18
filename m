Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab0JRV2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 17:28:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47422 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab0JRV2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 17:28:49 -0400
Message-ID: <4CBCBBFC.1090500@zytor.com>
Date: Mon, 18 Oct 2010 14:28:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
References: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com> <alpine.DEB.2.00.1010181340080.10965@chino.kir.corp.google.com> <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010182320440.6815@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2010 02:23 PM, Thomas Gleixner wrote:
> On Mon, 18 Oct 2010, David Rientjes wrote:
> 
>> On Mon, 18 Oct 2010, Frederic Weisbecker wrote:
>>
>>> 9, 19 and 26 values are missing from the TIF shift range, probably
>>> due to flags that were removed by the past. Now repack the range
>>> so that we can quickly retrieve the remaining free shift slots.
>>>
>>> But take care of keeping the seperation between high and low bits
>>> as some masks are created on top of this boundary.
>>>
>>
>> What's the benefit of doing this?
>>
>> These flags are exported to userspace through SysRq-T, SysRq+W, the hung 
>> task detector, and the rcu stall detector, so there may be external 
>> dependencies testing for these bits.
>>
>> We use this to look for TIF_MEMDIE to determine whether an oom killed task 
>> has failed to exit and becomes hung after having access to memory 
>> reserves, and that's one of the bits you've changed here.
> 
> I agree in general, but this is stupid as hell. No fcking interface
> should exposed kernel internal flag bits just as hex values and no
> fcking luser space should rely on it to be a subject of no change.
> 
> Seriously, if we can't even change TIF_* bits anymore then we are
> doing something wrong. That's a pure kernel internal affair and
> subject to change.
> 

The problem is that someone exports something as debugging information,
then someone else suddenly thinks it's an ABI.  I believe the same
complainant in the past has objected to changing of formatting in dmesg,
which is equally insane.

	-hpa
