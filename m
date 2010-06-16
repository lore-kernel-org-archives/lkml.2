Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab0FPSns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759027Ab0FPSnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:43:46 -0400
Message-ID: <4C191B5F.7080109@redhat.com>
Date: Wed, 16 Jun 2010 08:43:43 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] Fix deep C-state TSC desynchronization
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com> <1276587259-32319-5-git-send-email-zamsden@redhat.com> <4C18870C.9070707@redhat.com>
In-Reply-To: <4C18870C.9070707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:10 PM, Jason Wang wrote:
> Zachary Amsden wrote:
>    
>> When CPUs with unstable TSCs enter deep C-state, TSC may stop
>> running.  This causes us to require resynchronization.  Since
>> we can't tell when this may potentially happen, we assume the
>> worst by forcing re-compensation for it at every point the VCPU
>> task is descheduled.
>>
>>
>>      
> Is there any method to do the compensation on host TSC when recovering
> from C-state? It should be simpler than do it on guest TSC.
>    

Actually, yes, we could re-calibrate from HPET.  Considering this patch 
is already broken, maybe that's a better idea.
