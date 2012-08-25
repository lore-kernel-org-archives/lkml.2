Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab2HYXjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 19:39:42 -0400
Received: from mx2.parallels.com ([64.131.90.16]:47091 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2HYXjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 19:39:39 -0400
Message-ID: <50396173.4020005@parallels.com>
Date: Sat, 25 Aug 2012 19:36:19 -0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: <mjw@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <peterz@infradead.org>, <mtosatti@redhat.com>, <mingo@redhat.com>,
        <avi@redhat.com>
Subject: Re: [PATCH RFC 0/3] Add guest cpu_entitlement reporting
References: <20120823231346.11681.1502.stgit@lambeau>  <503708C8.2090401@parallels.com> <1345821066.4950.6.camel@lambeau>
In-Reply-To: <1345821066.4950.6.camel@lambeau>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [32.167.60.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 11:11 AM, Michael Wolf wrote:
> On Fri, 2012-08-24 at 08:53 +0400, Glauber Costa wrote:
>> On 08/24/2012 03:14 AM, Michael Wolf wrote:
>>> This is an RFC regarding the reporting of stealtime.  In the case of
>>> where you have a system that is running with partial processors such as
>>> KVM the user may see steal time being reported in accounting tools such
>>> as top or vmstat.  This can cause confusion for the end user.  To
>>> ease the confusion this patch set adds a sysctl interface to set the
>>> cpu entitlement.  This is the percentage of cpu that the guest system is
>>>  expected to receive.  As long as the steal time is within its expected
>>> range it will show up as 0 in /proc/stat.  The user will then see in the
>>> accounting tools that they are getting a full utilization of the cpu
>>> resources assigned to them.
>>>
>>
>> And how is such a knob not confusing?
>>
>> Steal time is pretty well defined in meaning and is shown in top for
>> ages. I really don't see the point for this.
> 
> Currently you can see the steal time but you have no way of knowing if
> the cpu utilization you are seeing on the guest is the expected amount.
> I decided on making it a knob because a guest could be migrated to
> another system and it's entitlement could change because of hardware or 
> load differences.  It could simply be a /proc file and report the
> current entitlement if needed.   As things are currently implemented I 
> don't see how someone knows if the guest is running as expected or
> whether there is a problem.
> 

Turning off steal time display won't get even close to displaying the
information you want. What you probably want is a guest-visible way to
say how many miliseconds you are expected to run each second. Right?
