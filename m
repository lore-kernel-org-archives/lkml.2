Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab2FHDzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 23:55:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:47920 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab2FHDzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 23:55:43 -0400
Message-ID: <4FD177BD.1070004@gmail.com>
Date: Thu, 07 Jun 2012 23:55:41 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 0/5] Some vmevent fixes...
References: <20120507121527.GA19526@lizard> <4FA82056.2070706@gmail.com> <CAOJsxLHQcDZSHJZg+zbptqmT9YY0VTkPd+gG_zgMzs+HaV_cyA@mail.gmail.com> <CAHGf_=q1nbu=3cnfJ4qXwmngMPB-539kg-DFN2FJGig8+dRaNw@mail.gmail.com> <CAOJsxLFAavdDbiLnYRwe+QiuEHSD62+Sz6LJTk+c3J9gnLVQ_w@mail.gmail.com> <CAHGf_=pSLfAue6AR5gi5RQ7xvgTxpZckA=Ja1fO1AkoO1o_DeA@mail.gmail.com> <CAOJsxLG1+zhOKgi2Rg1eSoXSCU8QGvHVED_EefOOLP-6JbMDkg@mail.gmail.com> <20120601122118.GA6128@lizard> <alpine.LFD.2.02.1206032125320.1943@tux.localdomain> <4FCC7592.9030403@kernel.org> <20120604113811.GA4291@lizard> <4FCD14F1.1030105@gmail.com> <CAOJsxLGbX33TfGvMEzV4By=n8JojHcXV32FRueb3kmti38jBPQ@mail.gmail.com>
In-Reply-To: <CAOJsxLGbX33TfGvMEzV4By=n8JojHcXV32FRueb3kmti38jBPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/5/12 3:52 AM), Pekka Enberg wrote:
> On Mon, Jun 4, 2012 at 11:05 PM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com>  wrote:
>>> - On desktops, apps can drop their caches on demand if they want to
>>>    and can avoid swap activity?
>>
>> In this case, fallocate(VOLATILE) is work more better.
>
> For some cases, yes, but probably not for all.
>
> For example, if userspace doesn't know about "about to swap real soon"
> condition, it can continue to grow its caches making
> fallocate(VOLATILE) pretty much useless.

Fair enough. But, Please consider your scenario don't need vmevent(2),
cat /proc/meminfo works enough. Only dropping activity need a quick work
and just in time notification. cache growing limitation don't need.
