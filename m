Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1EXMNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 08:13:47 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50605 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab1EXMNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 08:13:46 -0400
Date: Tue, 24 May 2011 14:13:43 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] timers: consider slack value in mod_timer()
Message-ID: <20110524121343.GA17312@Chamillionaire.breakpoint.cc>
References: <20110521105828.GA29442@Chamillionaire.breakpoint.cc>
 <BANLkTinGZ0L4oQkBYo9H=R==X5Z+efjRaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <BANLkTinGZ0L4oQkBYo9H=R==X5Z+efjRaQ@mail.gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yong Zhang | 2011-05-24 15:54:17 [+0800]:

>> diff --git a/kernel/timer.c b/kernel/timer.c
>> index fd61986..bf09726 100644
>> --- a/kernel/timer.c
>> +++ b/kernel/timer.c
>> @@ -804,6 +804,8 @@ int mod_timer(struct timer_list *timer, unsigned long expires)
>> ?? ?? ?? ?? ?? ?? ?? ??return 1;
>>
>> ?? ?? ?? ??expires = apply_slack(timer, expires);
>
>So, why not move above line up, then we can use the recalculated
>expires?

We leave often before apply_slack() kicks in. From printks() it looks
like we leave more often in first "return 1" than in the second. Moving
that line up would lead to more __mode_timer() calls.

>
>Thanks,
>Yong

Sebastian
