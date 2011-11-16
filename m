Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1KPWtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 17:49:31 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:49300 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab1KPWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 17:49:30 -0500
Message-ID: <4EC43DF7.4010902@atlas.cz>
Date: Wed, 16 Nov 2011 23:49:27 +0100
From: Clarinet <clarinet@atlas.cz>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: 647095@bugs.debian.org
CC: Jonathan Nieder <jrnieder@gmail.com>, Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        john.stultz@linaro.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz> <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz> <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net> <4EBD2825.6050806@atlas.cz>
In-Reply-To: <4EBD2825.6050806@atlas.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

>> Result of bisecting: v2.6.38-rc1 exhibits the problem. v2.6.37 and
>> many of the topic branches merged in the 2.6.38 merge window work ok.
>> Some other topic branches do not boot at all.
>>
>> Jiri: if you have gitk installed, then "git bisect visualize" can help
>> get a sense of what's in the middle of the regression range.
>> "gitk --bisect --first-parent v2.6.37..v2.6.38-rc1" might be a good way
>> to find mainline commits to test before finding a topic branch to delve
>> into.
>
> I have been able to narrow the interval manually a little bit from the
> "top" (the bad side) and I will go on from the bottom now. However,
> there seems to be a large area where kernels are unbootable for me -
> they mostly stop when init is called and I do not know why.

Finally! After another 50+ compilations a have it! It took some time as 
first I had to find a reason why some revisions did not boot (almost 2/3 
were unbootable and the first bad commit was among them). Having this 
solved I have been able to bisect without "skipping". The result is 
surprising (at least for me) - believe it or not, the first bad commit 
is 6610e089 "RTC: Rework RTC code to use timerqueue for events" from 
John Stultz (I am sending him a copy of this message).

I would never expect this would be a problem, but my understanding of 
this commit is very limited, so I am certainly missing the point. 
However, I have tried to compile 2.6.38 (which was "bad") with "Real 
Time Clock" configuration option turned off and it behaves "normally" 
then (= is "good").

Can you please comment this result? What does it mean? Any idea what is 
"wrong" there?

Best regards,

Jiri Polach

