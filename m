Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0FNPok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:44:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754645Ab0FNPoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:44:38 -0400
Message-ID: <4C164E63.2020204@redhat.com>
Date: Mon, 14 Jun 2010 18:44:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: balbir@linux.vnet.ibm.com, kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page cache
 control
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>	 <20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>	 <4C10B3AF.7020908@redhat.com> <20100610142512.GB5191@balbir.in.ibm.com>	 <1276214852.6437.1427.camel@nimitz>	 <20100611045600.GE5191@balbir.in.ibm.com> <4C15E3C8.20407@redhat.com>	 <20100614084810.GT5191@balbir.in.ibm.com> <4C16233C.1040108@redhat.com>	 <20100614125010.GU5191@balbir.in.ibm.com>  <4C162846.7030303@redhat.com> <1276529596.6437.7216.camel@nimitz>
In-Reply-To: <1276529596.6437.7216.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 06:33 PM, Dave Hansen wrote:
> On Mon, 2010-06-14 at 16:01 +0300, Avi Kivity wrote:
>    
>> If we drop unmapped pagecache pages, we need to be sure they can be
>> backed by the host, and that depends on the amount of sharing.
>>      
> You also have to set up the host up properly, and continue to maintain
> it in a way that finds and eliminates duplicates.
>
> I saw some benchmarks where KSM was doing great, finding lots of
> duplicate pages.  Then, the host filled up, and guests started
> reclaiming.  As memory pressure got worse, so did KSM's ability to find
> duplicates.
>    

Yup.  KSM needs to be backed up by ballooning, swap, and live migration.

> At the same time, I see what you're trying to do with this.  It really
> can be an alternative to ballooning if we do it right, since ballooning
> would probably evict similar pages.  Although it would only work in idle
> guests, what about a knob that the host can turn to just get the guest
> to start running reclaim?
>    

Isn't the knob in this proposal the balloon?  AFAICT, the idea here is 
to change how the guest reacts to being ballooned, but the trigger 
itself would not change.

My issue is that changing the type of object being preferentially 
reclaimed just changes the type of workload that would prematurely 
suffer from reclaim.  In this case, workloads that use a lot of unmapped 
pagecache would suffer.

btw, aren't /proc/sys/vm/swapiness and vfs_cache_pressure similar knobs?

-- 
error compiling committee.c: too many arguments to function

