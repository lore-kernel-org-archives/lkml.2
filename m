Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045Ab1EMNYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:24:13 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:32781 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab1EMNYL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:24:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ulAHQl51NefSeYuTEL558fV18psXf9XUwk+6y1sKAOQ4C2Uf/XtAw2C11w/QnPCyD3
         JD/TGfsRWYxzcH5LeUUunP8ksxxJjUUDxRBM4ex7QR7vCH0D97AqNZxAWrwB1LLuPTor
         Uj16tDscCQ3f1NgEZiBuPQAaZW/j/56p5qUXA=
MIME-Version: 1.0
In-Reply-To: <20110513130011.GA6474@elte.hu>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
	<20110513124523.GM13984@redhat.com>
	<20110513130011.GA6474@elte.hu>
Date: Fri, 13 May 2011 21:24:10 +0800
Message-ID: <BANLkTi=Z_3MZVs2CQyk82NfvZj-KdSw5kw@mail.gmail.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
From: huang ying <huang.ying.caritas@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo,

On Fri, May 13, 2011 at 9:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Don Zickus <dzickus@redhat.com> wrote:
>
>> On Fri, May 13, 2011 at 04:23:38PM +0800, Huang Ying wrote:
>> > In general, unknown NMI is used by hardware and firmware to notify
>> > fatal hardware errors to OS. So the Linux should treat unknown NMI as
>> > hardware error and go panic upon unknown NMI for better error
>> > containment.
>>
>> I have a couple of concerns about this patch.  One I don't think BIOSes
>> are ready for this.  I have Intel Westmere boxes that say they have a
>> valid HEST, GHES, and EINJ table, but when I inject an error there is no
>> GHES record.  This leaves me with an unknown NMI and panic.  Yeah, it is a
>> BIOS bug I guess, but I think vendors are going to be slow fixing all this
>> stuff (my Nehalem box is in even worse shape with this stuff).
>
> Agreed, doing this is not a very good idea - we have spurious unknown NMIs
> again and again, crashing the box is not a good idea.

So we use white list to filter out spurious hardware.

> What should be done instead is to add an event for unknown NMIs, which can then
> be processed by the RAS daemon to implement policy.
>
> By using 'active' event filters it could even be set on a system to panic the
> box by default.

If there is real fatal hardware error, maybe we have no luxury to go
from NMI handler to user space RAS daemon to determine what to do.
System may explode, bad data may go to disk before that.

Best Regards,
Huang Ying
