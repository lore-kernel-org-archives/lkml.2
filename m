Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323Ab0HFBXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 21:23:04 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934131Ab0HFBW7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 21:22:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=SRCXBIHncoSKPQGDKQo6msn0AbMBBoE3K0MN4VvyCQMNXtYpMpP+agko4J94szxDU
	RMxTFOQS7fBx/m3+WFOcg==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
References: <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
	<20100805004802.GP24163@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
	<20100805151211.GA10080@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm>
	<AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
	<20100805203102.GN2447@linux.vnet.ibm.com>
	<AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
	<alpine.DEB.2.00.1008051453450.30632@asgard.lang.hm>
	<AANLkTikCCeMG=DAQ04xqkvqH9tngBWyBA5VQTD4_15xU@mail.gmail.com>
	<20100805230304.GQ2447@linux.vnet.ibm.com>
	<AANLkTinatKEBfHhMnKc5wbys13P81PKWSc+nxccgHe-Y@mail.gmail.com>
	<alpine.DEB.2.00.1008051715520.30632@asgard.lang.hm>
	<AANLkTikOuY-q42mDRmxc-9W0uLeJeW-hiFG26WrV7CfU@mail.gmail.com>
	<alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
Date: Thu, 5 Aug 2010 18:22:56 -0700
Message-ID: <AANLkTimWqFkDWvGwVGWD94488gs+CXgpB9juwM5G11ud@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Brian Swetland <swetland@google.com>
To: david@lang.hm
Cc: paulmck@linux.vnet.ibm.com, kevin granade <kevin.granade@gmail.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 6:01 PM,  <david@lang.hm> wrote:
> On Thu, 5 Aug 2010, Brian Swetland wrote:
>> On Thu, Aug 5, 2010 at 5:16 PM,  <david@lang.hm> wrote:
>>>>>
>>>>> So for an mp3 playback, does an Android suspend between data fetches?
>>>>
>>>> It can if the latency is long enough (which is why I point out low
>>>> power audio which is usually high latency).  For low latency (system
>>>> sounds, etc) 10-25ms between buffers it's not practical to fully
>>>> suspend but we will go to the lowest power state in idle if possible.
>>>
>>> the playback is able to continue even with all the clocks stopped? that
>>> surprises me. I would hav expected it to be able to sleep while playing
>>> audio, but not do a full suspend.
>>
>> Obviously not all clocks are stopped (the DSP and codec are powered
>> and clocked, for example), but yeah we can clock gate and power gate
>> the cpu and most other peripherals while audio is playing on a number
>> of ARM SoC designs available today (and the past few years).
>
> does this then mean that you have multiple variations of suspend?
>
> for example, one where the audio stuff is left powered, and one where it
> isn't?

While the cpu (and the bulk of the system) is suspended, it's not
uncommon for some peripherals to continue to operate -- for example a
cellular radio, gps, low power audio playback, etc.  Details will vary
depending on the SoC and board design.  It's not so much a different
suspend mode (the system is still suspended), just a matter of whether
a peripheral can operate independently (and if it is lower power for
it to do so).

Brian
