Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2FHHXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 03:23:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55560 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2FHHXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 03:23:22 -0400
MIME-Version: 1.0
In-Reply-To: <84FF21A720B0874AA94B46D76DB98269045F78E1@008-AM1MPN1-004.mgdnok.nokia.com>
References: <20120601122118.GA6128@lizard> <1338553446-22292-2-git-send-email-anton.vorontsov@linaro.org>
 <4FD170AA.10705@gmail.com> <20120608065828.GA1515@lizard> <84FF21A720B0874AA94B46D76DB98269045F7890@008-AM1MPN1-004.mgdnok.nokia.com>
 <CAHGf_=rHGotkPYJt65wv+ZDNeO2x+3c5sA8oJmGJX8ehsMHqoA@mail.gmail.com> <84FF21A720B0874AA94B46D76DB98269045F78E1@008-AM1MPN1-004.mgdnok.nokia.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 8 Jun 2012 03:23:00 -0400
Message-ID: <CAHGf_=pNJAQP4GhTwtOkBxUDYU4n_-CKmKU7T4PzszwdL9Ju6Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] vmevent: Convert from deferred timer to deferred work
To: leonid.moiseichuk@nokia.com
Cc: anton.vorontsov@linaro.org, penberg@kernel.org, b.zolnierkie@samsung.com,
        john.stultz@linaro.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > It also will cause page trashing because user-space code could be pushed
>> out from cache if VM decide.
>>
>> This is completely unrelated issue. Even if notification code is not swapped,
>> userland notify handling code still may be swapped. So, if you must avoid
>> swap, you must use mlock.
>
> If you wakeup only by signal when memory situation changed you can be not mlocked.
> Mlocking uses memory very inefficient way and usually cannot be applied for apps which wants to be notified due to resources restrictions.

That's your choice. If you don't need to care cache dropping, We don't
enforce it. I only pointed out your explanation was technically
incorrect.
