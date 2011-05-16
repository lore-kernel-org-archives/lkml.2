Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1EPTxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:53:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49654 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab1EPTxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YBHuPkXGq7RFzmTyLRW7buNN/V6k/pLEmaAj0VYoOlkj89jY8Jp+clu/qvbkKNdxuU
         Q0rdgu+94oglY/2jj4G1kukSF75KGINEyRAOiWBPLVxjlZjfkYvhzg/A7uwqUkk1xVv1
         CaEucjXOINGeSyDLZSgH0s5KRIJB3ZIU7PLQU=
Message-ID: <4DD1809D.8090403@gmail.com>
Date: Mon, 16 May 2011 23:53:01 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Huang Ying <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com> <4DCD4B85.3040702@gmail.com> <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com> <4DCE3493.4090404@gmail.com> <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com> <4DCF7413.4070704@gmail.com> <4DD07959.4030608@intel.com> <20110516190310.GH31888@redhat.com>
In-Reply-To: <20110516190310.GH31888@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2011 11:03 PM, Don Zickus wrote:
> On Mon, May 16, 2011 at 09:09:45AM +0800, Huang Ying wrote:
>>>   Ying, the concern is rather related to the code scheme in general. Since
>>> we have notifiers I think the better way to be consistent here and use
>>> hwerr notifier too. But it's IMHO ;)
>>
>> As for go notifiers or not.  IMHO, a rule can be:
>>
>> - If it is something like a driver, than it should go notifier
>> - If it is architectural/PC defacto standard, it can sit outside of
>> notifier.
> 
> Hmm, then what do you do about perf?  That is architectural and a defacto
> standard, but I am not sure hardcoding that would be appropriate.

  Good point!

> 
>>
>> I think that seeing unknown NMI as hardware error should be part of PC
>> defacto standard.  Do you think so?
> 
> Well after thinking about it, I would say no.  And my reason is, if
> vendors are really serious about using NMIs as an indicator for hardware
> errors, shouldn't they be setting a bit in the memory controller/north
> bridge or south bridge/IOHC for an NMI handler to read?  I mean hardware

  UV platform has such bit iirc :)

> devices don't just get wired directly to the NMI pin on the cpu, right?
> They generally have to go through some hub that acts as a multiplexer.
> 
> In those cases, why can't those hubs set a bit saying it detected an error
> (don't PCIe bridges already do that?) and let the NMI handler read it to
> confirm.  This way we can leave 'unknown NMIs' as a way to say an
> unclaimed NMI entered the system and we can have users set policy about
> what to do, panic, printk, whatever.
> 
> But for the HEST stuff, it should be smart enough by now to trap any
> hardware error, no?  How does a machine that supports HEST let a hardware
> error get through without detecting it?  Isn't that the point?  Detect a
> hardware error, grab as much info about it as possible, save the error
> record and then panic?
> 
> Otherwise if you just panic, then you have no idea why the machine errored
> in the first place.  It might be the safe thing to do in some
> circumstances, but then you have to wonder why the fancy HEST enabled
> server didn't catch it.  Isn't that what people are spending extra money
> for those Intel servers with RAS features?
> 
> Cheers,
> Don

-- 
            Cyrill
