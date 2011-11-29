Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1K2M0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:26:44 -0500
Received: from marge.uochb.cas.cz ([147.231.129.3]:44919 "EHLO
	marge.uochb.cas.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1K2M0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:26:42 -0500
Message-ID: <4ED4CF7C.8020808@atlas.cz>
Date: Tue, 29 Nov 2011 13:26:36 +0100
From: Clarinet <clarinet@atlas.cz>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Jiri Polach <clarinet@atlas.cz>, 647095@bugs.debian.org,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: CPU hyperthreading turned on after soft power-cycle
References: <20111030110543.5872.61279.reportbug@supermicro.uochb.cas.cz>	 <1319988329.6759.88.camel@deadeye> <4EAE9D3A.7000108@atlas.cz>	 <4EB92181.5030500@seznam.cz> <20111110015212.GB2399@elie.gateway.2wire.net>	 <4EBD2825.6050806@atlas.cz> <4EC43DF7.4010902@atlas.cz>	 <1321561946.25715.16.camel@work-vm> <4EC59BCE.6050902@atlas.cz>	 <1321574019.25715.52.camel@work-vm> <4ECA51B9.3010707@seznam.cz>	 <1321905728.6445.2.camel@work-vm> <4ECAC340.8090908@atlas.cz> <1322533915.24090.69.camel@work-vm>
In-Reply-To: <1322533915.24090.69.camel@work-vm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Using an older "known-good" kernel, could you build and run the test
> case at the end of Documentation/rtc.txt a few times and see if it
> triggers the same problem?
>
> I'm suspicious that the setting the alarm is whats tripping the BIOS
> into enabling the HT bit. Because with older kernels, we used PIE mode
> irqs which hwclock usually uses at boot, but with newer kernels, we
> emulate PIE via AIE alarm mode. So if the BIOS was broken before, you
> wouldn't have noticed unless you tried to use AIE irqs.
>
> If this doesn't work, I'll get some patches to both 2.6.27 and 2.6.28
> kernels to debug the exact flow of how we're touching the hardware and
> then we can further narrow it down.

I ran the tests the following way:

- boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
- halt
- boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
- run rtctest
- reboot
- boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
- halt
- boot 2.6.37.6 - check /proc/cpuinfo - 12 processors
- run rtctest
- halt
- boot 2.6.37.6 - check /proc/cpuinfo - 24 processors

So the conclusion is that only if rtctest is run and the machine is 
halted, it triggers the HT problem. Reboot seems to "neutralize" 
whatever rtctest did.

Jiri
