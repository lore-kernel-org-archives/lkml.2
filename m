Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab1EPTow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:44:52 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:51507 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1EPTov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:44:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BJFVcZIxgfC3TvdDhChOWhGD1vOWj6FwPE1oslZWyYBMzIqTvYgYs+/4INeOxGX/PD
         5PBdroYgy7+c2F4TUEytZjPsVkY9Avu6mR8zNji9kUrNFj5D69XDFp3pkHcOZRz6o8IA
         2W18Z03IOYwFmeqqbsEuhOedxVfK4yr1SBml8=
Message-ID: <4DD17EAF.4040305@gmail.com>
Date: Mon, 16 May 2011 23:44:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>	<4DCD4B85.3040702@gmail.com>	<BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>	<4DCE3493.4090404@gmail.com> <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com> <4DCF7413.4070704@gmail.com> <4DD07959.4030608@intel.com>
In-Reply-To: <4DD07959.4030608@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 05:09 AM, Huang Ying wrote:
...
>>
>>   I'm personally fine even if it's enabled by default, only worried to have
>> an option to disable hwerr from boot line.
> 
> The white list mechanism is not sufficient?  Spurious unknown NMI can
> occur on white list machines?  People don't want to protect their data?
> 

  I suppose no, it's not sufficient considering how many cpu errata already
out in general. And I see no guarantee that unknown NMIs never triggers on
white list machines and I know that you know that as well ;)

>>> And, I am not a big fan of notifiers, that makes code hard to be
>>> understood.  If you have concerns about the size of traps.c, we can
>>> move all NMI logic to a new file.
>>
>>   Ying, the concern is rather related to the code scheme in general. Since
>> we have notifiers I think the better way to be consistent here and use
>> hwerr notifier too. But it's IMHO ;)
> 
> As for go notifiers or not.  IMHO, a rule can be:
> 
> - If it is something like a driver, than it should go notifier
> - If it is architectural/PC defacto standard, it can sit outside of notifier.
> 
> I think that seeing unknown NMI as hardware error should be part of PC
> defacto standard.  Do you think so?

  Ying, movin the handler into notifier is my IMHO, this would release nmi handler
from details since with time more and more "standarts" would appear. If Don, Ingo
and x86-team is fine with your approach -- of course I'm pretty fine too ;)

> 
> Best Regards,
> Huang Ying

/me Just found Don has some more concerns

-- 
            Cyrill
