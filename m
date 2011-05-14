Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778Ab1ENAsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 20:48:10 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35776 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1ENAsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 20:48:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iTTtsKCTzOLT+3bv3J9Iy4dVfIyAm3e9W3FuUo8nME/S+rXGi7DNrdaKImr5Ne57lq
         h2vlqVJTMkt7sFFLFo+Ju/BCu8H26cTkAqkHoljz5ACWolAEKX7qWKfSOXU04gtBPHZt
         JBHt4QvhT4+b0gACsuhPnNXWHKbHSNlDxETqg=
MIME-Version: 1.0
In-Reply-To: <4DCD4B85.3040702@gmail.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
	<4DCD4B85.3040702@gmail.com>
Date: Sat, 14 May 2011 08:47:10 +0800
Message-ID: <BANLkTim_7A8fSHnWta7jiWOW33Y8fS=t7A@mail.gmail.com>
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

On Fri, May 13, 2011 at 11:17 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 05/13/2011 12:23 PM, Huang Ying wrote:
>> In general, unknown NMI is used by hardware and firmware to notify
>> fatal hardware errors to OS. So the Linux should treat unknown NMI as
>> hardware error and go panic upon unknown NMI for better error
>> containment.
>>
>> But there are some legacy machine which would randomly send unknown
>> NMIs for no good reason.  To support these machines, a white list
>> mechanism is provided to treat unknown NMI as hardware error only on
>> some known working system.
>>
>> These systems are identified via the presentation of APEI HEST or
>> some PCI ID of the host bridge. The PCI ID of host bridge instead of
>> DMI ID is used, so that the checking can be done based on the platform
>> type instead of motherboard. This should be simpler and sufficient.
>>
>> The method to identify the platforms is designed by Andi Kleen.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Don Zickus <dzickus@redhat.com>
>> ---
> ...
>
> Hi Ying,
>
> just curious (regardless the concerns Don and Ingo have) -- if there still a need
> for such semi-unknown nmi handling maybe it's worth to register a *notifier* for it
> and we panic only when user *explicitly* specify how to treat this class of NMIs
> (via say "hest-nmi-panic" boot option or something like that). Maybe such partially
> modular scheme would be better? If only I don't miss anything.

Hi, Cyrill,

IMHO, Pushing all policy to user is not good too.  How many users
understand unknown NMI and hardware error clearly?  It is better if we
can determine what is the right behavior.

Best Regards,
Huang Ying
