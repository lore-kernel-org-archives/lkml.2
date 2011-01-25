Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1AYRhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:37:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59277 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1AYRhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:37:02 -0500
Message-ID: <4D3F095E.9000004@zytor.com>
Date: Tue, 25 Jan 2011 09:33:18 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu> <20110125150834.GD27510@htj.dyndns.org>
In-Reply-To: <20110125150834.GD27510@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 07:08 AM, Tejun Heo wrote:
> 
> There are holes but writing to them without full knowledge of the
> configuration can be quite dangerous.  I don't think it would be
> possible to mass deploy it without manual configuration unless we
> specifically reserve (and maybe mark) it in the filesystem.
> 

Reserve and mark in the filesystem is relatively straightforward, except
for btrfs, which doesn't have support for reserved extents.  This is a
bit of a shortcoming in btrfs.

>> All in one, a very intriguing idea IMO, and the hardest bits
>> (lowlevel x86 transition) is all implemented already.

Lowlevel x86 transition is not at all the hardest part.  It's
detail-oriented but well defined (and, I might add, incompletely
implemented -- 64 bits only, not using facilities we already have); the
*hard* part, and I mean harder by orders of magnitude, is to get the
BIOS to behave sanely without an intervening reboot, *AND* not trash
your data, ever.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

