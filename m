Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab2HFRVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:21:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56234 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756379Ab2HFRVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:21:52 -0400
Message-ID: <501FFD23.9080109@linaro.org>
Date: Mon, 06 Aug 2012 10:21:39 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: Fix adjustment cleanup bug in timekeeping_adjust()
References: <201208032318.FGJ64576.tOMVLOFHFQOFJS@I-love.SAKURA.ne.jp> <201208042024.GFG34353.OFtFVQJMLOHFSO@I-love.SAKURA.ne.jp> <201208042110.EFH81212.OSVOLMOtFQHJFF@I-love.SAKURA.ne.jp> <201208042246.HBH81275.FVOOSLtJFMQOFH@I-love.SAKURA.ne.jp> <20120804192114.GA28347@gmail.com>
In-Reply-To: <20120804192114.GA28347@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080617-7182-0000-0000-0000022F2B77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2012 12:21 PM, Ingo Molnar wrote:
> * Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
>
>> Hello.
>>
>> Bisected to 2a8c0883 "time: Move xtime_nsec adjustment
>> underflow handling timekeeping_adjust".
>>
>> Would you check?
> probably caused by this stray return in timekeeping_adjust():
>
>          } else
>                  return;
>
> which should really be a proper goto - like the (totally
> untested!) patch below.

Ooof.   Your analysis looks correct, thanks for fixing this, Ingo!
And thanks for catching the issue Tetsuo!

thanks
-john

