Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442Ab0FPWig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 18:38:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759346Ab0FPWie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 18:38:34 -0400
Message-ID: <4C195266.5010000@redhat.com>
Date: Wed, 16 Jun 2010 12:38:30 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, avi@redhat.com, mtosatti@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/17] Fix a possible backwards warp of kvmclock
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-12-git-send-email-zamsden@redhat.com> <4C18872E.4030105@redhat.com> <20100616135845.GM19104@mothafucka.localdomain>
In-Reply-To: <20100616135845.GM19104@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 03:58 AM, Glauber Costa wrote:
> On Wed, Jun 16, 2010 at 04:11:26PM +0800, Jason Wang wrote:
>    
>> Zachary Amsden wrote:
>>      
>>> Kernel time, which advances in discrete steps may progress much slower
>>> than TSC.  As a result, when kvmclock is adjusted to a new base, the
>>> apparent time to the guest, which runs at a much higher, nsec scaled
>>> rate based on the current TSC, may have already been observed to have
>>> a larger value (kernel_ns + scaled tsc) than the value to which we are
>>> setting it (kernel_ns + 0).
>>>
>>>        
>> This is one issue of kvmclock which tries to supply a clocksource whose
>> precision may even higher than host.
>>      
> What if we export to the guest the current clock resolution, and when doing guest
> reads, simply chop whatever value we got to the lowest acceptable value?
>    

I considered it, but it still doesn't solve the problem, at least, not 
without adding TSC trap and emulate.  If you can see a higher resolution 
clock advance faster than the resolution of the kernel, you still have 
the problem, and any visible TSC will do that.
