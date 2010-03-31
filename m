Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab0CaMMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:12:24 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:15112
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757037Ab0CaMMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 08:12:21 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R98dNzz1202hzzz32i2a8h6bh43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0L05B86-01-H48-02
X-M-MSG: 
Message-ID: <4BB33C0D.9090808@amd.com>
Date: Wed, 31 Mar 2010 14:11:57 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090329)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: KVM warning about uncertified CPU for SMP for AMD model 2, stepping
 3
References: <alpine.LNX.2.00.1003310047470.24576@pobox.suse.cz> <20100331024213.GV20695@one.firstfloor.org>
In-Reply-To: <20100331024213.GV20695@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2010 12:12:03.0734 (UTC) FILETIME=[5FC7AB60:01CAD0CB]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Mar 31, 2010 at 01:03:02AM +0200, Jiri Kosina wrote:
>> Hi,
>>
>> booting 32bit guest on 32bit host on AMD system gives me the following 
>> warning when KVM is instructed to boot as SMP:
> 
> I guess these warnings could be just disabled. With nearly everyone
> using multi-core these days they are kind of obsolete anyways.
Well, the warning refers to an old single-core only CPU model. Most of 
those were able to run in SMP boards, but only a subset of them was 
officially certified to do so (Athlon-MP instead of Athlon-XP).
To avoid complaints about instability of such systems, the warning was 
introduced. If you consider these systems still supported, I wouldn't 
disable this warning, at least the check should be disabled only if the 
hypervisor CPUID bit is set.

But the far better solution is to instruct QEMU/KVM to inject a better 
CPU model (as it was suggested by some people two weeks ago). I am about 
to test various guests with respect to their behavior regarding 
different family/model/stepping settings (one issue is already fixed). 
If this goes well, I will send out the patch to inject the host's CPUID 
F/M/S into the guest by default (which has other advantages, but denies 
migration mostly).

BTW.: I encourage people to test their KVM guests with "-cpu host" (on 
newer QEMUs) and send me any crash logs.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany
Tel: +49 351 448-3567-12

