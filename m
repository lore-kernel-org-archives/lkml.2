Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1AYB1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:27:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab1AYB1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:27:06 -0500
Message-ID: <4D3E26E3.3000209@redhat.com>
Date: Mon, 24 Jan 2011 20:26:59 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 14/16] KVM-GST: KVM Steal time registration
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>	 <1295892397-11354-15-git-send-email-glommer@redhat.com>	 <4D3E0BB9.5070805@redhat.com> <1295918712.15920.16.camel@mothafucka.localdomain>
In-Reply-To: <1295918712.15920.16.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 08:25 PM, Glauber Costa wrote:
> On Mon, 2011-01-24 at 18:31 -0500, Rik van Riel wrote:
>> On 01/24/2011 01:06 PM, Glauber Costa wrote:
>>> Register steal time within KVM. Everytime we sample the steal time
>>> information, we update a local variable that tells what was the
>>> last time read. We then account the difference.
>>>
>>> Signed-off-by: Glauber Costa<glommer@redhat.com>
>>> CC: Rik van Riel<riel@redhat.com>
>>> CC: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
>>> CC: Peter Zijlstra<peterz@infradead.org>
>>> CC: Avi Kivity<avi@redhat.com>
>>
>> On second thought - how does this deal with cpu hotplug and
>> hot unplug?
>>
>> Do you allocate a new one of these structs every time a cpu
>> is hot unplugged and then hotplugged, leaking the old one?
>>
>> Will leaving the old value around confuse the steal time
>> calculation?
>
> If you look closely, there are no allocations happening at all,
> it's all static.

In that case, does the per-cpu steal area need to be
reinitialized at hotplug time?

-- 
All rights reversed
