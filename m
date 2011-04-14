Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab1DNTFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:05:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab1DNTE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:04:59 -0400
Message-ID: <4DA74548.7050702@redhat.com>
Date: Thu, 14 Apr 2011 15:04:40 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH -v3] x86, MCE: Drop the default decoding notifier
References: <20110413143642.GC2791@aftab> <4DA5D6CC.9090500@redhat.com> <4DA5D9FB.1010503@redhat.com> <20110413173705.GJ2791@aftab> <20110414150036.GG10080@aftab> <4DA70D0B.3080407@redhat.com> <20110414151621.GI10080@aftab> <4DA71158.6020302@redhat.com> <20110414154405.GK10080@aftab> <4DA71774.9020900@redhat.com> <20110414190253.GQ10080@aftab>
In-Reply-To: <20110414190253.GQ10080@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/14/2011 03:02 PM, Borislav Petkov wrote:
> On Thu, Apr 14, 2011 at 11:49:08AM -0400, Prarit Bhargava wrote:
>   
>>> And we don't want to fix that - we want to fix the case with the
>>> occasional CE MCEs which get detected in the polling path but none of
>>> their MCA regs get dumped for decoding so the decoding hint there is
>>> out of place. And we fixed that at least partially so that it doesn't
>>> flood the logs. If you're not fine with the default ratelimit of 10 msgs
>>> per 5 seconds we can always raise the ratelimit but tweaking an almost
>>> hypothetical case is just not worth it.
>>>
>>>       
>> Okay -- I'm good then.
>>     
> Ok, injecting MCEs with this patch looks like this. Nevermind the
> decoded MCEs, I simply uncommented the "if (ret != NOTIFY_DONE)" line
> so that I can see the rate limiting. So we still have them there, this
> is the default setting of 10 calls per 5 secs, we might want to dial it
> down in the output. After the 10th MCE, it doesn't appear anymore.
>
> Hmm...
>
> Prarit, you said you have a machine which spits a lot of CECCs on boot,
> does the final version help there, did you have a chance to run it?
>   

Yup -- it looked good and did what I expected it to do ... I didn't save
the output though :(

P.

