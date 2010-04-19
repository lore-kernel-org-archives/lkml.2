Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab0DSSfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:35:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab0DSSfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:35:53 -0400
Message-ID: <4BCCA281.6040509@redhat.com>
Date: Mon, 19 Apr 2010 08:35:45 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BCA026D.3070309@redhat.com> <1271673975.1674.763.camel@laptop>	 <4BCC3520.6090305@redhat.com> <1271674273.1674.777.camel@laptop> <4BCC3654.2090600@redhat.com>
In-Reply-To: <4BCC3654.2090600@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 12:54 AM, Avi Kivity wrote:
> On 04/19/2010 01:51 PM, Peter Zijlstra wrote:
>>
>>>> Right, so on x86 we have:
>>>>
>>>> X86_FEATURE_CONSTANT_TSC, which only states that TSC is frequency
>>>> independent, not that it doesn't stop in C states and similar fun 
>>>> stuff.
>>>>
>>>> X86_FEATURE_TSC_RELIABLE, which IIRC should indicate the TSC is 
>>>> constant
>>>> and synced between cores.
>>>>
>>>>
>>> Sockets and boards too?  (IOW, how reliable is TSC_RELIABLE)?
>> Not sure, IIRC we clear that when the TSC sync test fails, eg when we
>> mark the tsc clocksource unusable.
>
> Worrying.  By the time we detect this the guest may already have 
> gotten confused by clocks going backwards.

Upstream, we are marking the TSC unstable preemptively when hardware 
which will eventually sync test is detected, so this should be fine.

Zach
