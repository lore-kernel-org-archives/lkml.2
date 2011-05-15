Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457Ab1EOAGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 20:06:34 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36051 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab1EOAGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 20:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DCHdqm+P1UgC63SpyL/5XqjJ5MJvbTp1j5CBpDiT2QZfTjcZmk4+mwPqHPdbezMve5
         N0ecQ0btVh2n0fNPcJCLLtKaAX0lvY/Eo499RGFIRcwrJWBeabHosCBx75e/MBSx+/2O
         CL5g6RWgnqVureamTut875iNqrUkpxuT12IZo=
MIME-Version: 1.0
In-Reply-To: <4DCE3493.4090404@gmail.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
	<4DCD4B85.3040702@gmail.com>
	<BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>
	<4DCE3493.4090404@gmail.com>
Date: Sun, 15 May 2011 08:06:30 +0800
Message-ID: <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
From: huang ying <huang.ying.caritas@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 3:51 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 05/14/2011 04:26 AM, huang ying wrote:
>> On Fri, May 13, 2011 at 11:17 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> Hi Ying,
>>>
>>> just curious (regardless the concerns Don and Ingo have) -- if there still a need
>>> for such semi-unknown nmi handling maybe it's worth to register a *notifier* for it
>>> and we panic only when user *explicitly* specify how to treat this class of NMIs
>>> (via say "hest-nmi-panic" boot option or something like that). Maybe such partially
>>> modular scheme would be better? If only I don't miss anything.
>>
>> Hi, Cyrill,
>>
>> IMHO, Pushing all policy to user is not good too.  How many users
>> understand unknown NMI and hardware error clearly?  It is better if we
>> can determine what is the right behavior.
>>
>
> yes, is not good. But at least we *must* provide a way to turn this new feature off
> via command line I think. One of a reason for me is perf unknown nmis (at moment we seems
> to have captured and cured all parasite NMIs sources but there is no guarantee we wont
> meet them in future due to some code change or whatever). And bloating trap.c with
> new if()'s is not that good I guess, that is why I asked if there a way to do all the
> work via notifiers ;)

Yes.  We should consider about perf unknown NMI issues.  But compared
with pushing all magic to user, I think the better way is to have a
better default behavior in kernel.  For example, we can turn off
unknown NMI as hwerr logic temporarily if there are more than 1 perf
NMI events in action.  Is that reasonable?

And, I am not a big fan of notifiers, that makes code hard to be
understood.  If you have concerns about the size of traps.c, we can
move all NMI logic to a new file.

Best Regards,
Huang Ying
