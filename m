Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886Ab1BISsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 13:48:06 -0500
Received: from claw.goop.org ([74.207.240.146]:49696 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab1BISsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 13:48:05 -0500
Message-ID: <4D52E162.5030308@goop.org>
Date: Wed, 09 Feb 2011 10:48:02 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Jiri Slaby <jslaby@suse.cz>, Tim Deegan <Tim.Deegan@citrix.com>,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix jiffy calculations in calibrate_delay_direct	 to
 handle overflow
References: <4D525EF00200007800030F0F@vpn.id2.novell.com> <4D525CA8.60604@suse.cz> <4D526FF40200007800030FEF@vpn.id2.novell.com> <4D52641E.9020001@suse.cz> <4D52A241020000780003107A@vpn.id2.novell.com>
In-Reply-To: <4D52A241020000780003107A@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 05:18 AM, Jan Beulich wrote:
>>>> On 09.02.11 at 10:53, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 02/09/2011 10:44 AM, Jan Beulich wrote:
>>>>>> On 09.02.11 at 10:21, Jiri Slaby <jslaby@suse.cz> wrote:
>>>> On 02/09/2011 09:31 AM, Jan Beulich wrote:
>>>>> Fixes a hang when booting as dom0 under Xen, when jiffies can be
>>>>> quite large by the time the kernel init gets this far.
>>>> As I wrote this might happen if the boot till this point takes ~ 5
>>>> minutes because we start at -5 minutes.
>>>>
>>>> That said, is this a candidate for stable? (If so, please CC stable.)
>>> Honestly, I'm not certain (given that mainline Xen Dom0 support
>>> is still only in its beginnings).
>> What about other VMs? If I run few non-kvm qemu VMs (kvm presets lpj) on
>> a busy dual-core machine, this will be a problem too, right?
> Yes, quite possible indeed.

Seems like stable material since it 1) has fixed a real bug, and 2) is
the right way to do things anyway.  It just hasn't been seen to fix a
bug in a stable kernel, so perhaps not.  If it were any more complex
then wouldn't push it.

    J
