Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1BCVKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:10:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41720 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1BCVKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:10:13 -0500
Message-ID: <4D4B18F6.8090403@zytor.com>
Date: Thu, 03 Feb 2011 13:07:02 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
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
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
References: <20110125134748.GA10051@laptop> <20110125140948.GA26762@elte.hu> <20110125150834.GD27510@htj.dyndns.org> <20110203143644.GA4085@ucw.cz> <4D4AC996.4070307@zytor.com> <20110203175721.GB8785@elte.hu>
In-Reply-To: <20110203175721.GB8785@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 09:57 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 02/03/2011 06:36 AM, Pavel Machek wrote:
>>>
>>> Could we read the log area, first, verify it contains signature, write
>>> it back?
>>> 								Pavel
>>
>> Yes, but that doesn't guarantee no data corruption caused by handing
>> over from one driver to another.
> 
> Waiting a few seconds? Is there any sufficiently high number of X where waiting X 
> seconds would make it safe to touch the hardware? (i.e. it would guarantee that 
> pending commands are flushed, etc.)
> 

Probably not... if you have enough control over the hardware to force a
device reset you should be okay, though.  This kind of comes down to
wanting a complete set of system drivers, i.e. kexec/kdump again.

	-hpa
