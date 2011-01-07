Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab1AGUoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:44:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab1AGUoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:44:23 -0500
Message-ID: <4D277B24.5000409@redhat.com>
Date: Fri, 07 Jan 2011 10:44:20 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-3-git-send-email-zamsden@redhat.com> <20110107104859.GA12056@amt.cnet>
In-Reply-To: <20110107104859.GA12056@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 12:48 AM, Marcelo Tosatti wrote:
> On Thu, Jan 06, 2011 at 12:10:45AM -1000, Zachary Amsden wrote:
>    
>> Use an MSR to allow "soft" migration to hosts which do not support
>> TSC trapping.  Rather than make this a required element of any
>> migration protocol, we allow the TSC rate to be exported as a data
>> field (useful in its own right), but we also allow a one time write
>> of the MSR during VM creation.  The result is that for the common
>> use case, no protocol change is required to communicate TSC rate
>> to the receiving host.
>>      
> Migration to hosts which do not support the feature can be achieved by
> saving/restoring the TSC rate + flags in a subsection. A subsection
> seems more appropriate than an MSR for this.
>    

Yes, I looked at that, but it looked to me like a subsection was 
intended for an optional feature which MUST be present on the 
destination if the source is using the feature.  This way, newer hosts 
without the feature enabled can migrate to older hosts which do not 
support the feature.

The TSC rate migration is slightly different; we may wish to migrate 
from a host with the TSC rate feature enabled to a host which does not 
support the TSC rate feature.  This is exactly the current behavior, the 
TSC rate will change on that migration, and I wanted to preserve that 
behavior.  I don't advise that mode of usage, but there may be use cases 
for it and it should be decided by policy, not dictated by our feature set.

That said, I'm happy to remove the MSR if we truly don't want to support 
that mode of usage.

Zach
