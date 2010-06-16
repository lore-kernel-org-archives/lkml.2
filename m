Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab0FPVeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 17:34:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756644Ab0FPVeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 17:34:44 -0400
Message-ID: <4C193F02.1090406@redhat.com>
Date: Wed, 16 Jun 2010 11:15:46 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] Keep SMP VMs more in sync on unstable TSC
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-6-git-send-email-zamsden@redhat.com> <20100616133257.GK19104@mothafucka.localdomain>
In-Reply-To: <20100616133257.GK19104@mothafucka.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 03:32 AM, Glauber Costa wrote:
> On Mon, Jun 14, 2010 at 09:34:07PM -1000, Zachary Amsden wrote:
>    
>> SMP VMs on machines with unstable TSC have their TSC offset adjusted by the
>> local offset delta from last measurement.  This does not take into account how
>> long it has been since the measurement, leading to drift.  Minimize the drift
>> by accounting for any time difference the kernel has observed.
>>
>> Signed-off-by: Zachary Amsden<zamsden@redhat.com>
>>      
> I believe this should be done not only if we have check_tsc_unstable() == true,
> but anytime we adjust the tsc. I mean:
>
> Sure it is expected to be much more relevant in this case, but if we're testing
> generally for tsc_delta<  0 in the adjustment code, it is because we believe
> it can happen, even if tsc is stable (otherwise, we'd better take it off completely).
>
> And in that case, we should account elapsed time too.
>    

If we get tsc_delta < 0 test turning true, we've got an unstable tsc to 
begin with, so perhaps we should just check that and let the TSC code 
deal with detecting an unstable TSC for us.
