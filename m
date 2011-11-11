Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab1KKNum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 08:50:42 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:53287 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab1KKNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 08:50:41 -0500
Message-ID: <4EBD2825.6050806@atlas.cz>
Date: Fri, 11 Nov 2011 14:50:29 +0100
From: Clarinet <clarinet@atlas.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: 647095@bugs.debian.org, Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz> <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz> <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>
In-Reply-To: <20111110015212.GB2399@elie.gateway.2wire.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

> Hi Jiri,
>
> Jiri Polach wrote:
>
>> On Ben's advice I am trying to locate the commit that causes the problem to
>> appear more precisely using 'git bisect'. However, too many of generated
>> revisions are unbootable so I have to use 'bisect skip' frequently.
>
> Ok, so I've looked over the log at<http://bugs.debian.org/647095>, and
> this seems totally weird.  Have I described the symptoms correctly below?
> (Warning: I am making some guesses, especially at step 5.  In case of
> doubt, see the bug log just mentioned.)
>
> 	1. Disable SMT in the BIOS.
>
> 	2. Boot a bad kernel.  /proc/cpuinfo (correctly) shows one entry
> 	   per core.
>
> 	3. "shutdown -h now".  Enter BIOS.  SMT is still disabled.
> 	   Don't save.
>
> 	4. Boot any kernel.  /proc/cpuinfo shows two entries per core.
>
> 	5. "shutdown -h now".  Boot any kernel.  /proc/cpuinfo still shows
> 	   two entries per core.
>
> 	6. "shutdown -h now".  Enter BIOS.  SMT is still disabled.  Save.
> 	   Now /proc/cpuinfo will (correctly) shows one entry per core.
>
> Reproducible for Jiri with v3.0.4.

Yes, this is exactly how it works. Something happens when kernel shuts 
down. Not when kernel reboots.

> Result of bisecting: v2.6.38-rc1 exhibits the problem.  v2.6.37 and
> many of the topic branches merged in the 2.6.38 merge window work ok.
> Some other topic branches do not boot at all.
>
> Jiri: if you have gitk installed, then "git bisect visualize" can help
> get a sense of what's in the middle of the regression range.
> "gitk --bisect --first-parent v2.6.37..v2.6.38-rc1" might be a good way
> to find mainline commits to test before finding a topic branch to delve
> into.

I have been able to narrow the interval manually a little bit from the 
"top" (the bad side) and I will go on from the bottom now. However, 
there seems to be a large area where kernels are unbootable for me - 
they mostly stop when init is called and I do not know why.

> x86 people: do the symptoms seem familiar?  Any hints for tracking it
> down?

Please! I have spent more than a month trying to resolve it. I cannot 
revert back to 2.6.37 kernels and I cannot live with SMT changing on 
every shutdown - I have too many servers to allow such unusual behavior ...

Thank you,

Jiri Polach

> Thanks and hope that helps,
> Jonathan

