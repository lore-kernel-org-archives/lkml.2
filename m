Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab1D2UN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:13:56 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:12936
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab1D2UNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:13:55 -0400
X-SpamScore: -28
X-BigFish: VPS-28(zzbb2dK9371Odf9M154dM1432N98dKzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKFK6V-02-CS0-02
X-M-MSG: 
Message-ID: <4DBB1B6E.9060203@amd.com>
Date: Fri, 29 Apr 2011 16:11:26 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Boris Ostrovsky <ostr@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jvpeetz@web.de" <jvpeetz@web.de>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>
Subject: Re: [PATCH] Subject: [PATCH] x86, AMD: K8 Rev.A-E processors are
 subject to erratum 400
References: <1304106663-3720-1-git-send-email-ostr@amd64.org> <20110429195548.GA17166@elte.hu>
In-Reply-To: <20110429195548.GA17166@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2011 03:55 PM, Ingo Molnar wrote:
>
> * Boris Ostrovsky<ostr@amd64.org>  wrote:
>
>> Signed-off-by: Boris Ostrovsky<Boris.Ostrovsky@amd.com>
>> Acked-by: Borislav Petkov<borislav.petkov@amd.com>
>> Reported-by: Joerg-Volker Peetz<jvpeetz@web.de>
>> Tested-by: Joerg-Volker Peetz<jvpeetz@web.de>
>>
>> Older AMD K8 processors (Revisions A-E) are affected by erratum 400 (APIC
>> timer interrupts don't occur in C states greater than C1). This, for example,
>> means that X86_FEATURE_ARAT flag should not be set for these parts.
>>
>> This addresses regression introduced by commit
>> b87cf80af3ba4b4c008b4face3c68d604e1715c6 (x86, AMD: Set ARAT feature on AMD
>> processors") so it is somewhat high priority.
>
> Hm, what is the regression, how do users see it? Hangs? Delays? Crashes?
> Something more benign? The changelog should really contain such information.


The system becomes unresponsive until an external interrupt (e.g. 
keyboard input) happens. The most obvious effect is that time is not 
reported correctly. We haven't seen anything worse but that's probably 
bad enough.

Do you want me to resubmit the patch with updated comments?

Thanks.
-boris

