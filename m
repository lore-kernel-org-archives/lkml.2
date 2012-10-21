Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab2JUESM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 00:18:12 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46566 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2JUESK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 00:18:10 -0400
MIME-Version: 1.0
In-Reply-To: <5081B7F8.7040302@draigBrady.com>
References: <CAMjzKwXZLGX7EM7dVOHWcN-8Ay40bbhiR4v5M352Xd2g2uHY1g@mail.gmail.com>
	<5081B7F8.7040302@draigBrady.com>
Date: Sun, 21 Oct 2012 09:48:09 +0530
Message-ID: <CAMjzKwVn4Y+ocZ7Ud_CSM34KP=zO1N84ZApG1s6CG6onSP_x-g@mail.gmail.com>
Subject: Re: [Perf] Adding timeout option
From: abhishek agarwal <abhigem.126@gmail.com>
To: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigbrady.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep does not offer a good timeout resolution and it is not a good
option (according to me) either.
perfmon had "timeout" option and i guess, same do oprofile.

On Sat, Oct 20, 2012 at 1:58 AM, Pádraig Brady <P@draigbrady.com> wrote:
> On 10/13/2012 08:54 AM, abhishek agarwal wrote:
>>
>> Hi folks..
>>
>> I was thinking that why cant we have a timeout option in perf stat
>> command.  The timeout feature will help us to profile a process for a
>> stipulated time (preferably in millisecs) and make perf stat return
>> after that time.
>> Eg:
>>
>> perf stat --timeout=10 sleep 100
>>
>> This will make perf return and report stats after 10 ms...
>>
>> Hope anyone can shed some more light on the idea
>
>
> It seems preferable to use the timeout program to do this.
> Either sending a handled signal to the perf process like:
>
>     timeout -s HUP 10 perf stat sleep 100
>
> Or even better, just use that to kill the monitored process itself
>
>     perf stat timeout 10 sleep 100
>
> cheers,
> Pádraig.
