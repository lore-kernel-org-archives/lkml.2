Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0KKCw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 21:52:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47881 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932104Ab0KKCw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 21:52:27 -0500
Message-ID: <4CDB5A20.7070106@zytor.com>
Date: Wed, 10 Nov 2010 18:51:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Marcus Meissner <meissner@suse.de>,
        linux-kernel@vger.kernel.org, jason.wessel@windriver.com,
        fweisbec@gmail.com, tj@kernel.org, mort@sgi.com, akpm@osdl.org,
        security@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
References: <20101104100914.GC25118@suse.de> <20101104114648.GA23381@elte.hu> <20101104122906.GH25118@suse.de> <20101104135802.GA31416@elte.hu> <20101104141104.GA31753@elte.hu> <20101104143322.GL25118@suse.de> <871v6xt3l1.fsf@basil.nowhere.org> <a4676065-571a-4dda-bd3a-798a9b2d7edf@email.android.com> <20101110085314.GB8370@elte.hu>
In-Reply-To: <20101110085314.GB8370@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2010 12:53 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> We already do virtual relocation on 32 bits, and replicating that on 64 bits 
>> wouldn't be hard.  However, the linkage script strongly assumes congruency mod 2/4 
>> MiB, and that is probably nontrivial to change.  However, that still gives about 9 
>> bits of entrophy to play with.  The question is if that is enough, or if we'd have 
>> to do more clever hacks.
> 
> Even 1 bit of entropy would bring a visible improvement: a failed exploit attempt to 
> the wrong address can crash the kernel with a 50% chance. 9 bits would be very nice.
> 
> If an exploit can be brute-forced without crashing the kernel then only some 
> significantly large bitness would help. So while 9 bits would be rather low for a 
> user-space ASLR scheme [many user-space bugs can be brute-forced without crashing 
> the system and raising alarms], it's very attractive for kernel ASLR.
> 

Now, *relative* symbol addresses will typically not have any randomness
at all, which may limit the usefulness, of course.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

