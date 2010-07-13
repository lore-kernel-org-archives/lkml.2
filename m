Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0GMVpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:45:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556Ab0GMVpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:45:54 -0400
Message-ID: <4C3CDE8F.60304@redhat.com>
Date: Tue, 13 Jul 2010 11:45:51 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "David S. Ahern" <daahern@cisco.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/18] Robust TSC compensation
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com> <1278987938-23873-10-git-send-email-zamsden@redhat.com> <20100713203418.GA903@amt.cnet> <4C3CD77B.9050108@redhat.com> <4C3CDDD4.6010009@cisco.com>
In-Reply-To: <4C3CDDD4.6010009@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 11:42 AM, David S. Ahern wrote:
>
> On 07/13/10 15:15, Zachary Amsden wrote:
>
>    
>>> What prevents a vcpu from seeing its TSC go backwards, in case the first
>>> write in the 5 second window is smaller than the victim vcpu's last
>>> visible TSC value ?
>>>
>>>        
>> Nothing, unfortunately.  However, the TSC would already have to be out
>> of sync in order for the problem to occur.  It can never happen in
>> normal circumstances on a stable hardware TSC except in one case;
>> migration.  During the CPU state transfer phase of migration, however,
>>      
> What about across processor sockets? Aren't CPUs brought up at different
> points such that their TSCs start at different times?
>    

Yes, that's called an unsynchronized TSC.  In that case, the 
compensation does the best it can based on time since the first TSC 
write, but it will never be exact.
