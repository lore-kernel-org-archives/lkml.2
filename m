Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab0KPLTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 06:19:42 -0500
Received: from daytona.panasas.com ([67.152.220.89]:27509 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab0KPLTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:19:41 -0500
Message-ID: <4CE268C8.5010203@panasas.com>
Date: Tue, 16 Nov 2010 13:19:36 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>	 <20101112120834.33062900.akpm@linux-foundation.org>	 <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>	 <20101114092533.GB5323@albatros>	 <20101114180643.593d19ac.akpm@linux-foundation.org> <1289848341.2607.125.camel@edumazet-laptop>
In-Reply-To: <1289848341.2607.125.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Nov 2010 11:19:39.0794 (UTC) FILETIME=[28DAFF20:01CB8580]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 09:12 PM, Eric Dumazet wrote:
> Le dimanche 14 novembre 2010 à 18:06 -0800, Andrew Morton a écrit : 
>> On Sun, 14 Nov 2010 12:25:33 +0300 Vasiliy Kulikov <segoon@openwall.com> wrote:
>>>  
>>>  	if (timeval) {
>>> -		rtv.tv_sec = rts.tv_sec;
>>> -		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
>>> +		struct timeval rtv = {
>>> +			.tv_sec = rts.tv_sec,
>>> +			.tv_usec = rts.tv_nsec / NSEC_PER_USEC
>>> +		};
>>>  
>>>  		if (!copy_to_user(p, &rtv, sizeof(rtv)))
>>>  			return ret;
>>
>> Please check the assembly code - this will still leave four bytes of
>> uninitalised stack data in 'rtv', surely.
> 
> Thats a good question.
> 
> In my understanding, gcc should initialize all holes (and other not
> mentioned fields) with 0, even for automatic storage [C99 only mandates
> this on static storage]
> 
> I tested on x86_64 and this is the case, but could not find a definitive
> answer in gcc documentation.
> 
> This kind of construct is widely used in networking tree.
> 
> Maybe we should ask to gcc experts if this behavior is guaranteed by
> gcc, or if we must review our code ;(
> 
> CC Jakub
> 
> Thanks !
> 

This is what I thought too. If it is not there are tones of bugs I wrote
of code that relays on this behaviour.

It would be interesting to know for sure

Thanks
Boaz
