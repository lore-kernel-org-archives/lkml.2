Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1ENHvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 03:51:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51674 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1ENHvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 03:51:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gl4d0WM8t3zYNwI+Ge4bknnSBpiokWG/3MTTwRYU6HPSYNtxRxtMeVtdorsb7s9gMY
         bnja0AujaivBdFzUl86tZv9EzaXLr5R7LkFSX6f/RmiNM/03Ix/A7IZfu9n+5MedgpHq
         ZqPPjUA6qipIRWDsRUjgnYVN8RL24Ico+P838=
Message-ID: <4DCE3493.4090404@gmail.com>
Date: Sat, 14 May 2011 11:51:47 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>	<4DCD4B85.3040702@gmail.com> <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>
In-Reply-To: <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2011 04:26 AM, huang ying wrote:
> On Fri, May 13, 2011 at 11:17 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On 05/13/2011 12:23 PM, Huang Ying wrote:
>>> In general, unknown NMI is used by hardware and firmware to notify
>>> fatal hardware errors to OS. So the Linux should treat unknown NMI as
>>> hardware error and go panic upon unknown NMI for better error
>>> containment.
>>>
>>> But there are some legacy machine which would randomly send unknown
>>> NMIs for no good reason.  To support these machines, a white list
>>> mechanism is provided to treat unknown NMI as hardware error only on
>>> some known working system.
>>>
>>> These systems are identified via the presentation of APEI HEST or
>>> some PCI ID of the host bridge. The PCI ID of host bridge instead of
>>> DMI ID is used, so that the checking can be done based on the platform
>>> type instead of motherboard. This should be simpler and sufficient.
>>>
>>> The method to identify the platforms is designed by Andi Kleen.
>>>
>>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>>> Cc: Andi Kleen <ak@linux.intel.com>
>>> Cc: Don Zickus <dzickus@redhat.com>
>>> ---
>> ...
>>
>> Hi Ying,
>>
>> just curious (regardless the concerns Don and Ingo have) -- if there still a need
>> for such semi-unknown nmi handling maybe it's worth to register a *notifier* for it
>> and we panic only when user *explicitly* specify how to treat this class of NMIs
>> (via say "hest-nmi-panic" boot option or something like that). Maybe such partially
>> modular scheme would be better? If only I don't miss anything.
> 
> Hi, Cyrill,
> 
> IMHO, Pushing all policy to user is not good too.  How many users
> understand unknown NMI and hardware error clearly?  It is better if we
> can determine what is the right behavior.
> 
> Best Regards,
> Huang Ying

  Hi Ying,

yes, is not good. But at least we *must* provide a way to turn this new feature off
via command line I think. One of a reason for me is perf unknown nmis (at moment we seems
to have captured and cured all parasite NMIs sources but there is no guarantee we wont
meet them in future due to some code change or whatever). And bloating trap.c with
new if()'s is not that good I guess, that is why I asked if there a way to do all the
work via notifiers ;)

-- 
            Cyrill
