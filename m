Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0D0SKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:10:47 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:40553 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0D0SKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <20100427130139.GC3681@ucw.cz>
References: <20100418115949.7b743898@infradead.org>
	 <4BCC147B.10708@tremplin-utc.net>
	 <20100419064325.49cb3108@infradead.org>
	 <201004201124.00326.trenn@suse.de>
	 <m2x8bb80c381004261729r2e9b0df2q961c1d10430b2e1f@mail.gmail.com>
	 <20100427130139.GC3681@ucw.cz>
Date: Tue, 27 Apr 2010 11:10:40 -0700
Message-ID: <j2v8bb80c381004271110r7626ed3ch7947f044f66a7035@mail.gmail.com>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with 
	ondemand during disk IO
From: Mike Chan <mike@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Renninger <trenn@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       "?ric Piel" <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       tglx@linutronix.de, davej@redhat.com, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 6:01 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> > But I follow Eric and agree that if it costs that much, changing
>> > above sounds sane.
>> > Still, I could imagine some people might want to not raise freq on IO bound
>> > process activity, therefore this should get another ondemand param, similar
>> > to ignore_nice_load.
>> >
>>
>> I agree with Thomas here. Some of these assumptions on IO / FSB
>> performance with cpu speed do not hold true on various ARM platforms.
>>
>> Perhaps we could have a min_io_freq value? Which is the min speed for
>> the cpu to run at for IO bound activity. In the original patch,
>> min_io_freq = scaling_max_freq. For various arm devices I can happily
>> set min_io_freq to the lowest cpu speed that satisfies bus speeds.
>
> 'satisfies bus speeds' == minimum cpu frequency where i/o works at all
>
>  or
>
>  == minimum cpu frequency where i/o works at full speed
>

Sorry for the confusion, I mean the later, cpu frequency where i/o
works at full speed. However this value can be set via sysfs, it could
be both. Really its up to the user, if they want max io performance,
minimum io performance or a happy medium.

-- Mike

> ?
>                                                                Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
