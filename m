Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab2BWUEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:04:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58653 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab2BWUEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:04:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.42.108.6 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
In-Reply-To: <1329988135.24994.43.camel@twins>
References: <1329957415-15239-1-git-send-email-venki@google.com>
	<20120223075027.GB15306@elte.hu>
	<1329988135.24994.43.camel@twins>
Date: Thu, 23 Feb 2012 12:04:45 -0800
Message-ID: <CABeCy1aUztmELNiD59L1cDj_KPPBYn=UYiF-Nu=K5sdeH3T2Sg@mail.gmail.com>
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES interrupts
 to an idle CPU -v1
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resending without the ugly email client formatting ]

On Thu, Feb 23, 2012 at 1:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2012-02-23 at 08:50 +0100, Ingo Molnar wrote:
>> * Venkatesh Pallipadi <venki@google.com> wrote:
>
>> > * We can also eliminate TS_POLLING flag in favor of this. But, that will have
>> >   a lot more touchpoints and better done as a standlone change.
>>
>> Should most definitely be done for this series to be acceptble -
>> as a preparatory patch in the series, with the feature at the
>> end of the series.
>
> I don't think you can, TS_POLLING still works for idle=poll, whereas
> this new stuff requires monitor/mwait.
>

Even poll_idle should be able to use this ipiless_wakeup. It just have
to poll for an additional IPI_PENDING bit along with need_resched.
