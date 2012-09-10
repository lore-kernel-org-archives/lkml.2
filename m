Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab2IJIKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:10:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2IJIKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:10:15 -0400
Message-ID: <504DA064.3070402@redhat.com>
Date: Mon, 10 Sep 2012 11:10:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: tsc deadline timer works only when hrtimer high
 resolution configured
References: <DE8DF0795D48FD4CA783C40EC829233531F0E4@SHSMSX101.ccr.corp.intel.com> <5048AC08.5050100@redhat.com> <DE8DF0795D48FD4CA783C40EC8292335322311@SHSMSX101.ccr.corp.intel.com> <504CA787.2000905@redhat.com> <DE8DF0795D48FD4CA783C40EC8292335323599@SHSMSX101.ccr.corp.intel.com> <504CAEC7.9000807@redhat.com> <DE8DF0795D48FD4CA783C40EC82923353235C7@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923353235C7@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 06:10 PM, Liu, Jinsong wrote:
> Avi Kivity wrote:
>> On 09/09/2012 05:54 PM, Liu, Jinsong wrote:
>>>> 
>>>> hrtimers is an intrusive feature, I don't think we should
>>>> force-enable it.  Please change it to a depends on.
>>> 
>>> Hmm, if it changed as
>>> config KVM
>>> 	depends on HIGH_RES_TIMERS
>>> The item 'Kernel-based Virtual Machine (KVM) support (NEW)' even
>>> didn't appear to user when make menuconfig (when HIGH_RES_TIMERS
>>> disable)  
>>> 
>>> Is it good? I just have a little concern here:)
>> 
>> It's not good, but that's what we have.
>> 
>> It's okay to force-enable low-impact features (like preempt notifies).
>> 
>> hrimers, on the other hand, change kernel behaviour quite deeply.
>> 
>> Maybe over time someone will fix the config tools to unhide features
>> that can be enabled by turning on a dependency.
> 
> OK, updated as attached.

Thanks, applied.


-- 
error compiling committee.c: too many arguments to function
