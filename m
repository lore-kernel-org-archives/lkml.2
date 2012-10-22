Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab2JVLCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab2JVLCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:02:52 -0400
Message-ID: <508527D8.9020004@draigBrady.com>
Date: Mon, 22 Oct 2012 12:02:48 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: abhishek agarwal <abhigem.126@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Perf] Adding timeout option
References: <CAMjzKwXZLGX7EM7dVOHWcN-8Ay40bbhiR4v5M352Xd2g2uHY1g@mail.gmail.com> <5081B7F8.7040302@draigBrady.com> <CAMjzKwVn4Y+ocZ7Ud_CSM34KP=zO1N84ZApG1s6CG6onSP_x-g@mail.gmail.com>
In-Reply-To: <CAMjzKwVn4Y+ocZ7Ud_CSM34KP=zO1N84ZApG1s6CG6onSP_x-g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 05:18 AM, abhishek agarwal wrote:

> perfmon had "timeout" option and i guess, same do oprofile.
>
> On Sat, Oct 20, 2012 at 1:58 AM, Pádraig Brady <P@draigbrady.com> wrote:
>> On 10/13/2012 08:54 AM, abhishek agarwal wrote:
>>>
>>> Hi folks..
>>>
>>> I was thinking that why cant we have a timeout option in perf stat
>>> command.  The timeout feature will help us to profile a process for a
>>> stipulated time (preferably in millisecs) and make perf stat return
>>> after that time.
>>> Eg:
>>>
>>> perf stat --timeout=10 sleep 100
>>>
>>> This will make perf return and report stats after 10 ms...
>>>
>>> Hope anyone can shed some more light on the idea
>>
>>
>> It seems preferable to use the timeout program to do this.
>> Either sending a handled signal to the perf process like:
>>
>>      timeout -s HUP 10 perf stat sleep 100
>>
>> Or even better, just use that to kill the monitored process itself
>>
>>      perf stat timeout 10 sleep 100

 > sleep does not offer a good timeout resolution and it is not a good
 > option (according to me) either.

sleep was just following on the command example.
timeout(1) supports subsecond resolution,
through timer_create (CLOCK_REALTIME...) and
timeout indication through signals.

thanks,
Pádraig.
