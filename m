Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab0D0A3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 20:29:06 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:49751 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab0D0A3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 20:29:04 -0400
MIME-Version: 1.0
In-Reply-To: <201004201124.00326.trenn@suse.de>
References: <20100418115949.7b743898@infradead.org>
	 <4BCC147B.10708@tremplin-utc.net>
	 <20100419064325.49cb3108@infradead.org>
	 <201004201124.00326.trenn@suse.de>
Date: Mon, 26 Apr 2010 17:29:01 -0700
Message-ID: <m2x8bb80c381004261729r2e9b0df2q961c1d10430b2e1f@mail.gmail.com>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with 
	ondemand during disk IO
From: Mike Chan <mike@android.com>
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 2:24 AM, Thomas Renninger <trenn@suse.de> wrote:
> On Monday 19 April 2010 15:43:25 Arjan van de Ven wrote:
>> On Mon, 19 Apr 2010 10:29:47 +0200
>> Éric Piel <eric.piel@tremplin-utc.net> wrote:
>> > >
>> > > The problem and fix are both verified with the "perf timechar" tool.
>> > Hi,
>> > I don't doubt that keeping the cpu full frequency during IO can
>> > improve some specific workloads, however in your log message you
>> > don't explain how much we are loosing.
>>
>> first of all, it's so bad that people will just turn the whole power
>> management off... at which point fixing the really bad bug is actually
>> quite a win
> Not sure you fix a bug, I expect this was done on purpose.
> The ondemand governor disadvantages processes with alternating short CPU
> load peaks and idle sequences.
> IO bound processes typically show up with such a behavior.
>
> But I follow Eric and agree that if it costs that much, changing
> above sounds sane.
> Still, I could imagine some people might want to not raise freq on IO bound
> process activity, therefore this should get another ondemand param, similar
> to ignore_nice_load.
>

I agree with Thomas here. Some of these assumptions on IO / FSB
performance with cpu speed do not hold true on various ARM platforms.

Perhaps we could have a min_io_freq value? Which is the min speed for
the cpu to run at for IO bound activity. In the original patch,
min_io_freq = scaling_max_freq. For various arm devices I can happily
set min_io_freq to the lowest cpu speed that satisfies bus speeds.

-- Mike

>    Thomas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
