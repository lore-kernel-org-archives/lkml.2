Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1EOGfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 02:35:06 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57111 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1EOGfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 02:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x444jCPlCBEiYmAFgnTyHqd1PXKwHUAuapurTQyR7t/q1qr9XfjNbaZFabwlVWECTb
         HV9hRYCmzsthbmxkEIHEhm3fDNATAZJspSks4RcKLfVz0pTfDVVuW+EQ9kmA4dAobKGA
         b0yZTgIFMOMbfE1a08WQrmUKtVwdB8WE92xb4=
Message-ID: <4DCF7413.4070704@gmail.com>
Date: Sun, 15 May 2011 10:34:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>	<4DCD4B85.3040702@gmail.com>	<BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>	<4DCE3493.4090404@gmail.com> <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com>
In-Reply-To: <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2011 04:06 AM, huang ying wrote:
...
>>
>> yes, is not good. But at least we *must* provide a way to turn this new feature off
>> via command line I think. One of a reason for me is perf unknown nmis (at moment we seems
>> to have captured and cured all parasite NMIs sources but there is no guarantee we wont
>> meet them in future due to some code change or whatever). And bloating trap.c with
>> new if()'s is not that good I guess, that is why I asked if there a way to do all the
>> work via notifiers ;)
> 
> Yes.  We should consider about perf unknown NMI issues.  But compared
> with pushing all magic to user, I think the better way is to have a
> better default behavior in kernel.  For example, we can turn off
> unknown NMI as hwerr logic temporarily if there are more than 1 perf
> NMI events in action.  Is that reasonable?

  I'm personally fine even if it's enabled by default, only worried to have
an option to disable hwerr from boot line.

> 
> And, I am not a big fan of notifiers, that makes code hard to be
> understood.  If you have concerns about the size of traps.c, we can
> move all NMI logic to a new file.

  Ying, the concern is rather related to the code scheme in general. Since
we have notifiers I think the better way to be consistent here and use
hwerr notifier too. But it's IMHO ;)

> 
> Best Regards,
> Huang Ying

-- 
            Cyrill
